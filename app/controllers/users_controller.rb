# frozen_string_literal: true

class UsersController < ApplicationController
  def destroy
    current_user.destroy!
    reset_session
    redirect_to welcome_path, notice: t('user.deleted_account')
  end
end
