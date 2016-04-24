json.array!(@financial_data) do |financial_datum|
  json.extract! financial_datum, :id
  json.url financial_datum_url(financial_datum, format: :json)
end
