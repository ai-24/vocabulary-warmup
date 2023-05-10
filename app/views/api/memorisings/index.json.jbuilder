json.array! @memorisings do |memorising|
  json.id memorising.expression_id
  json.tags memorising.expression.tags.pluck(:name)# インクリメントサーチでタグの検索ために記載
  json.expression_items do
    json.array! memorising.expression.expression_items do |expression_item|
      json.expression expression_item.content
    end
  end
end
