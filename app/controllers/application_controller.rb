# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user, :logged_in?
  before_action :store_location

  private

  def current_user
    return unless session[:user_id]

    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !!current_user
  end

  def store_location
    session.delete(:forwarding_url)
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_back_or_default
    redirect_to(session[:forwarding_url] || home_path)
    session.delete(:forwarding_url)
  end
end
