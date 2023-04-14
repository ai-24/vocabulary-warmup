json.array! @quiz do |resource|
  json.content resource.content
  json.explanation resource.explanation
  json.expressionId resource.expression_id
end
