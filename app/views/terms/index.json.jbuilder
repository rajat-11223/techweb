json.array!(@terms) do |term|
  json.extract! term, :id
  json.url term_url(term, format: :json)
end
