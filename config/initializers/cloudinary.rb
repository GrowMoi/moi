# hack: set cloudinary URL for dev
if Rails.env.development?
  ENV["CLOUDINARY_URL"] = "cloudinary://234492286161472:55GOQ_bKx4KxioWgLpZMFYvT84Q@hprtcgwsj"
end
