json.array!(@trees) do |tree|
  json.extract! tree, :id, :common_name, :scientific_name, :family_name
  json.url tree_url(tree, format: :json)
end
