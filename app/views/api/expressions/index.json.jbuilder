json.array! @expressions do |expression|
  json.id expression.id
  json.note expression.note
  json.tags expression.tags.pluck(:name)
  json.expression_items do
    json.array! expression.expression_items do |expression_item|
      json.expression expression_item.content
      json.explanation expression_item.explanation
      json.examples expression_item.examples.pluck(:content)
    end
  end
end
