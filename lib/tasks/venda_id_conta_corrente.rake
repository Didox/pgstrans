return_code = ReturnCodeApi..where("error_description ilike ?", "%#{mensagem}%").where(partner_id: self.partner_id).first 
if return_code.present?
  return return_code if return_code.present?
end



ReturnCodeApi.where(return_code: venda.status, sucesso: true, partner_id: venda.partner_id).count > 0




fazer uma rake que busca todas as vendas que não tem registro em conta corrente
se a venda foi sucesso rodar o codigo abaixo
Venda.where("created_at > ?", Time.zone.now - 3.months).each do |venda| 
  if ContaCorrente.where(venda_id: venda.id).count == 0
    if venda.sucesso?

      cc = ContaCorrente.where(usuario_id: usuario.id).first
      if cc.blank?
        banco = Banco.first
        iban = ""
      else
        iban = cc.iban
        banco = cc.banco
      end

      banco = Banco.first if banco.blank?

      lancamento = Lancamento.where(nome: Lancamento::COMPRA_DE_CREDITO_OU_RECARGA).first
      lancamento = Lancamento.first if lancamento.blank?

      conta_corrente = ContaCorrente.new(
        usuario_id: usuario.id,
        valor: "-#{valor}",
        observacao: "Compra de recarga dia #{venda.created_at.strftime("%d/%m/%Y %H:%M:%S")}",
        lancamento_id: lancamento.id,
        banco_id: (banco.id rescue Banco.first.id),
        partner_id: parceiro.id,
        iban: iban,
        venda_id: venda.id,
        created_at:venda.created_at,
        updated_at:venda.created_at,
      )
      conta_corrente.responsavel = usuario
      conta_corrente.save!
    end
  end
end
