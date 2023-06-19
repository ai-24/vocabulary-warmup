json.id @expression.id
json.note @expression.note
json.tags @expression.tags.order('taggings.created_at').pluck(:name)
json.expressionItems do
  json.array! @expression.expression_items.order(:created_at, :id) do |expression_item|
    json.id expression_item.id
    json.expression expression_item.content
    json.explanation expression_item.explanation
    json.examples expression_item.examples.order(:created_at, :id).pluck(:id, :content)
  end
end
