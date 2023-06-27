# frozen_string_literal: true

module PageTabHelper
  def current_page_tab_or_not(target_name)
    path = request.fullpath[1..]
    path == target_name ? 'bg-golden-yellow-800' : ''
  end
end
