json.id @expression.id
json.note @expression.note
json.tags @expression.tags.pluck(:name)
json.expressionItems do
  json.array! @expression.expression_items do |expression_item|
    json.id expression_item.id
    json.expression expression_item.content
    json.explanation expression_item.explanation
    json.examples expression_item.examples.pluck(:id, :content)
  end
end
