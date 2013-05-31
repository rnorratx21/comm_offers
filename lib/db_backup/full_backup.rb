require "aws/s3"

class DbBackup::FullBackup
  CONFIG = YAML.load_file("#{RAILS_ROOT}/config/database.yml")[RAILS_ENV]
  S3 = YAML.load_file("#{RAILS_ROOT}/config/s3.yml")["backups"]
  BACKUPS_PATH_PREFIX = "/mysql_backups"

  class << self

  def backup
    msgs = {}
    msgs[:file] = file_with_path = backup_only
    if verify_backup(file_with_path)
      msgs[:s3] = move_to_s3
      msgs[:local_deletes] = cleanup_local_backups
    else
      msgs[:errors] = ["Unable to move to S3 because the file wasn't created_properly"]
    end
    msgs
  end

  def uploads_backup
    uploads_backup_only
    move_uploads_to_s3    
  end

  def backup_only
    @mysql_database = CONFIG["database"]
    @mysql_user = CONFIG["username"]
    @mysql_password = CONFIG["password"]

    FileUtils.mkdir_p backups_path
    dump_file = dump_file_with_path
    puts "Beginning backup"

    cmd = "mysqldump -u #{@mysql_user}"
    cmd += " -p#{@mysql_password}" unless @mysql_password.blank?
    cmd += " #{@mysql_database} | gzip > #{dump_file}"
    puts "Calling: #{cmd.gsub(@mysql_password || 'ignoreme','<FILTERED>')}"
    run(cmd)
    dump_file
  end  

  def verify_backup(file_with_path)
    File.exist?(file_with_path)
  end

  def uploads_backup_only
    puts "Removing old backup"
    run "rm -rf /uploads_backup/uploads"

    puts "Copy backups folder"
    run "cp -r #{RAILS_ROOT}/public/uploads /uploads_backup"

    puts "Clear old zip file"
    run "rm -rf /uploads_backup/uploads.tar.gz"

    puts "Clear tmp file from being backed up"
    run "rm -rf /uploads_backup/uploads/tmp"

    puts "Zip all folders"
    run "cd /uploads_backup && tar -cvzpf uploads.tar.gz uploads"

    puts "Backup complete"
    true
  end

  def move_uploads_to_s3
    s3_log = ""
    s3_uploads_bucket = "community-offers-uploads"

    s3_msg s3_log, "Connecting to S3..."
    AWS::S3::Base.establish_connection!(:access_key_id => S3["access_key_id"], :secret_access_key => S3["secret_access_key"], :use_ssl => true)
    backup_file = Dir.glob("/uploads_backup/uploads.tar.gz").max
    raise "Unable to find uploads backup file" unless backup_file
    
    s3_msg s3_log, "Writing file #{backup_file} to S3..." 
    AWS::S3::S3Object.store(File.basename(backup_file), open(backup_file), s3_uploads_bucket)

    s3_msg s3_log, "Completed S3 Uploads backup"
    s3_log

  end

  def move_to_s3(file_with_path=nil)
    s3_log = ""

    s3_msg s3_log, "Connecting to S3..."
    AWS::S3::Base.establish_connection!(:access_key_id => S3["access_key_id"], :secret_access_key => S3["secret_access_key"], :use_ssl => true)
    dump_file = file_with_path || Dir.glob("/mysql_backups/#{CONFIG["database"]}/dump*.sql.gz").max

    s3_msg s3_log, "Writing file #{dump_file} to S3..." 
    AWS::S3::S3Object.store(File.basename(dump_file), open(dump_file), "Community_Offers_Backup")

    s3_msg s3_log, "Copying to current dump.sql.gz"
    AWS::S3::S3Object.copy File.basename(dump_file), "dump.sql.gz", "Community_Offers_Backup"

    s3_msg s3_log, "Completed S3 backup"
    s3_log
  end

  def backups_path
    "#{BACKUPS_PATH_PREFIX}/#{CONFIG['database']}"
  end
  
  def file_timestamp
    "%Y-%m-%d_%H%M%S"
  end
  
  def cleanup_local_backups
    local_deletes = []
    # number_of_local_backups = Dir.glob("/mysql_backups/#{CONFIG["database"]}/dump*.sql.gz").size
    while files = Dir.glob("/mysql_backups/#{CONFIG["database"]}/dump*.sql.gz") and files.size >= 5
      file = files.first
      local_deletes << file
      File.delete(file)
    end
    local_deletes
  end

  private

  def run(command)
    result = system(command)
    raise("error, process exited with status #{$?.exitstatus}") unless result
  end
  
  def dump_file_with_path
    stamp = Time.now.strftime(file_timestamp)
    "#{backups_path}/dump_#{stamp}.sql.gz"
  end

  def parse_file_timestamp(file)
    Date.parse(file.gsub("dump_","").gsub(".sql.gz",""))
  end
  
  def s3_msg(master_msg, msg)
    master_msg ||= ""
    puts "#{msg} \n"
    master_msg += msg
  end
  
  end # class << self
end
