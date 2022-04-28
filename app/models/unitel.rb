class Unitel
  require 'openssl'

  def self.importa_produtos(categoria)
    raise PagasoError.new("Não importado, verificar")
  end
end