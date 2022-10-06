class CreateConsolidadoVendaRelatorios < ActiveRecord::Migration[5.2]
  def change
    create_table :consolidado_venda_relatorios do |t|
      t.references :consolidado_venda, foreign_key: true
      t.bigint :venda_id
      t.string :usuario_login
      t.string :usuario_nome
      t.string :partner_name
      t.string :venda_categoria_zap
      t.datetime :venda_created_at
      t.string :venda_status_desc_error_description_pt
      t.string :venda_lancamento_nome
      t.string :venda_customer_number
      t.string :venda_smartcard
      t.bigint :venda_movimentacoes_conta_corrente_id
      t.bigint :venda_product_id
      t.string :venda_product_nome
      t.string :venda_product_subtipo
      t.float :venda_valor_original
      t.float :venda_desconto_aplicado
      t.float :porcentagem_venda_desconto_aplicado
      t.float :venda_value
      t.float :rodape_valor_original_total
      t.float :rodape_desconto_total
      t.float :rodape_valor_total

      t.timestamps
    end
  end
end
