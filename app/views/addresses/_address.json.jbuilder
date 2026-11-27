json.extract! address, :id, :state, :city, :country, :pincode, :user_id, :created_at, :updated_at
json.url address_url(address, format: :json)
