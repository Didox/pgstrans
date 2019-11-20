json.extract! master_profile, :id, :description, :created_at, :updated_at
json.url master_profile_url(master_profile, format: :json)
