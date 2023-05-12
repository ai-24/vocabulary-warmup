# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    session.delete(:forwarding_url)
    store_location
    @expressions = if logged_in?
                     Expression.find_expressions_of_users_main_list(current_user.id)
                   else
                     Expression.where(user_id: nil)
                   end
  end
end
