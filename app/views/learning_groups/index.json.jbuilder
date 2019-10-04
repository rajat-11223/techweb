json.array!(@learning_groups) do |learning_group|
  json.extract! learning_group, :id
  json.url learning_group_url(learning_group, format: :json)
end
