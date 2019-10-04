json.array!(@tutor_groups) do |tutor_group|
  json.extract! tutor_group, :id
  json.url tutor_group_url(tutor_group, format: :json)
end
