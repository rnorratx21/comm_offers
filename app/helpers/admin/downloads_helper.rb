module Admin::DownloadsHelper
  def generate_collection_csv
    CSVBuilder.new(@collection).build
  end
end
