class UserDecorator < LittleDecorator
  GRAVATAR_DEFAULT = "mm"

  def avatar(opts = {})
    options = opts.merge(class: "avatar #{opts[:class]}")
    image_tag gravatar_url, options
  end

  def avatar_with_link
    link_to avatar, record_path
  end

  def name_with_link
    link_to name, record_path
  end

  def gravatar_url
    @gravatar_url ||= "http://www.gravatar.com/avatar/#{email_hexdigest}?d=#{GRAVATAR_DEFAULT}"
  end

  def role_badge
    content_tag :span, record.role, class: "label label-default"
  end

  private

  def email_hexdigest
    @email_hexdigest ||= Digest::MD5.hexdigest(email)
  end

  def record_path
    admin_user_path(record)
  end
end
