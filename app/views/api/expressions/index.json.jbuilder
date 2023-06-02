json.array! @expressions do |expression|
  json.id expression.id
  json.tags expression.tags.pluck(:name)
  json.expression_items do
    json.array! expression.expression_items.order(:created_at, :id) do |expression_item|
      json.expression expression_item.content
    end
  end
end
