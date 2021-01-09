json.extract! menu, :id, :sessao, :nome, :link, :controller, :action, :created_at, :updated_at
json.url menu_url(menu, format: :json)
