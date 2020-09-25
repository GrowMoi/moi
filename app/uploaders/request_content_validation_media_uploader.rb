class RequestContentValidationMediaUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave

  ##
  # use a timestamp in filenames
  # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Use-a-timestamp-in-file-names
  def filename
    # @name ||= "#{timestamp}-#{super}" if original_filename.present? and super.present?
  end

  def timestamp
    # var = :"@#{mounted_as}_timestamp"
    # model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  end
end
