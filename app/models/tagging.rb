# frozen_string_literal: true

class Tagging < ApplicationRecord
  belongs_to :expression
  belongs_to :tag

  def self.destroy_taggings(params, expression)
    current_tags = expression.tags.map(&:name)
    new_tags = params[:tags_attributes].to_h.map { |tag| tag[1][:name] }
    delete_tag_names = current_tags.difference(new_tags)
    delete_tags = Tag.where(name: delete_tag_names)
    delete_tags.each { |tag| Tagging.find_by(tag:, expression:)&.destroy }
  end
end
