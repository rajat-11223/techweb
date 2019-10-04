json.array!(@staff_profiles) do |staff_profile|
  json.extract! staff_profile, :id
  json.url staff_profile_url(staff_profile, format: :json)
end
