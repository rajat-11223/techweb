json.array!(@observations) do |observation|
  json.extract! observation, :id
  json.url observation_url(observation, format: :json)
end
