# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    user_or_nil = User.find_by uid: request.env['omniauth.auth'][:uid]
    user = User.find_or_create_from_auth_hash!(request.env['omniauth.auth'])
    session[:user_id] = user.id
    Expression.copy_initial_expressions!(user.id) unless user_or_nil

    redirect_to root_path, notice: t('.success')
  end

  def destroy
    reset_session
    redirect_to root_path, notice: t('.success')
  end
end
