class AlegacaoDePagamento < ApplicationRecord
  include PermissionamentoDados
  belongs_to :usuario
  belongs_to :banco
  belongs_to :status_alegacao_de_pagamento

  before_validation do
    if self.status_alegacao_de_pagamento_id.blank?
      self.status_alegacao_de_pagamento = StatusAlegacaoDePagamento.where("lower(nome) = ?", StatusAlegacaoDePagamento::PADRAO.downcase).first
    end
  end
end
