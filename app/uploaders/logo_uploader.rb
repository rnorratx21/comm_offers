class LogoUploader < CarrierWave::Uploader::Base
  storage :file
  
  include CarrierWave::RMagick

  version :normal do
    process :resize_and_pad => [165, 165]
  end

  version :small do
    process :resize_and_pad => [65, 65]
  end
  
  def default_url
    "/images/advertiser_logo_place_holder_normal.gif"
  end
  
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  
  # Add a white list of extensions which are allowed to be uploaded,
  # for images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files
  #     def filename
  #       "something.jpg" if original_filename
  #     end
end