# encoding: utf-8

class ContentMediaUploader < CarrierWave::Uploader::Base
  if Rails.env.staging? || Rails.env.integration?
    include Cloudinary::CarrierWave
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  ##
  # use a timestamp in filenames
  # https://github.com/carrierwaveuploader/carrierwave/wiki/How-to%3A-Use-a-timestamp-in-file-names
  def filename
    @name ||= "#{timestamp}-#{super}" if original_filename.present? and super.present?
  end

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
  end

  def public_id
    Cloudinary::PreloadedFile.split_format(original_filename).first + "_" + Cloudinary::Utils.random_public_id[0,6]
  end
end