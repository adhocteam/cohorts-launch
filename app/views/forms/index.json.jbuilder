json.array!(@forms) do |form|
  json.extract! form, :hash, :name, :description, :url, :created_on, :last_update
  json.url form_url(form, format: :json)
end