# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :store_location

  def create
    user_or_nil = User.find_by uid: request.env['omniauth.auth'][:uid]
    user = User.find_or_create_from_auth_hash!(request.env['omniauth.auth'])
    session[:user_id] = user.id
    Expression.copy_initial_expressions!(user.id) unless user_or_nil

    flash[:notice] = t('.success')
    redirect_back_or_default
  end

  def destroy
    reset_session
    redirect_to root_path, notice: t('.success')
  end
end
