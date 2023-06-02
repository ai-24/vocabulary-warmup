json.array! @bookmarkings do |bookmarking|
  json.id bookmarking.expression_id
  json.tags bookmarking.expression.tags.pluck(:name)# インクリメントサーチでタグの検索ために記載
  json.expression_items do
    json.array! bookmarking.expression.expression_items.order(:created_at, :id) do |expression_item|
      json.expression expression_item.content
    end
  end
end
