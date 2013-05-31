namespace :db do
  desc "backup the database and uploads"
  task :backup => :environment do
    message "Beginning DB backup and cleanup task at #{Time.now} \n\n"
    results = DbBackup::FullBackup.backup
    message "Backed up #{results[:file]} Successfully \n\n" if results[:file]
    message "Errors: \n #{results[:errors]} \n\n" if results[:errors]
    message "DB backup and cleanup completed at #{Time.now}"

    message "Beginning Uploads backup task at #{Time.now} \n\n"
    results = DbBackup::FullBackup.uploads_backup

    SystemNotifier.deliver_developer_notification("DB Backup and Cleanup #{Date.today}", @message.join("\n"))
  end
end

def message(str)
  @message ||= []
  RAILS_DEFAULT_LOGGER.info(str)
  @message << str
end
