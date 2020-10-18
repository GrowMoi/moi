# hack: set cloudinary URL for dev
if Rails.env.development?
  ENV["CLOUDINARY_URL"] = "cloudinary://686632149634842:-KbPFR0lDcjUb5BIQU8PDa1kmi4@moi-images"
end
