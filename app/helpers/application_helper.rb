# frozen_string_literal: true

module ApplicationHelper
  def error_or_not(alert)
    alert ? 'opacity-30' : ''
  end
end
