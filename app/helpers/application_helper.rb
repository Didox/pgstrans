module ApplicationHelper
  def usuario_logado
  	Usuario.find(JSON.parse(cookies[:usuario_pgstrans_oauth])["id"])
  end
end
