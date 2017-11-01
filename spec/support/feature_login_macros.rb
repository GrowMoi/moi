module FeatureLoginMacros
  def login_as(user)
    login = I18n.t("activerecord.attributes.user.login")
    password = I18n.t("activerecord.attributes.user.password")
    submit_button = I18n.t("devise.login")

    visit new_user_session_path
    fill_in login, with: user.email
    fill_in password, with: user.password
    click_button submit_button
  end
end
