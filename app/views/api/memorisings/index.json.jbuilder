json.array! @memorisings do |memorising|
  json.id memorising.expression_id
  json.expression_items do
    json.array! memorising.expression.expression_items.order(:created_at, :id) do |expression_item|
      json.expression expression_item.content
    end
  end
end
