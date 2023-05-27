# frozen_string_literal: true

module Recordable
  def create_bookmarkings_or_memorisings!(user_id, expression_ids)
    exist_expression_ids = expression_ids.select { |expression_id| Expression.exists?(id: expression_id) }
    return 'failure' if exist_expression_ids.count.zero?

    transaction do
      exist_expression_ids.each do |expression_id|
        if self == Memorising
          bookmarking = Bookmarking.find_by(expression_id:)
          bookmarking&.destroy
        end

        object = new
        object.user_id = user_id
        object.expression_id = expression_id
        object.save!
      end
    end

    expression_ids.count == exist_expression_ids.count
  end
end
