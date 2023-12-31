# frozen_string_literal: true

module SignInHelper
  def sign_in_with_welcome_page(selected_button, user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

    visit '/'
    within selected_button do
      click_button 'Sign up / Log in with Google'
    end
  end

  def sign_in_with_header(path, user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock(:google_oauth2, { uid: user.uid, info: { name: user.name } })

    visit path
    within '.button-on-header' do
      click_button 'Sign up / Log in with Google'
    end
  end
end
