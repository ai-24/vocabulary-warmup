# frozen_string_literal: true

module PageTabHelper
  def current_page_tab_or_not(target_name)
    path = request.fullpath[1..]
    path == target_name ? 'bg-lavender-600 text-black-900' : ''
  end
end
