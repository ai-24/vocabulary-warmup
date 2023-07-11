# frozen_string_literal: true

class UsersController < ApplicationController
  def destroy
    current_user.destroy!
    reset_session
    redirect_to root_path, notice: t('.success')
  end
end
