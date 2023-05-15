class CreateVendasConsolidadas < ActiveRecord::Migration[5.2]
  def change
    create_table :vendas_consolidadas do |t|
      t.integer :usuario_id
      t.integer :venda_id
      t.string :usuario_nome
      t.string :usuario_login
      t.integer :status_cliente_id
      t.string :status_cliente_nome
      t.integer :partner_status_parceiro_id
      t.string :partner_status_parceiro_nome
      t.float :vendas_valor_original_valor
      t.float :vendas_desconto_aplicado_lucro
      t.string :porcentagem_vendas_desconto_aplicado
      t.float :vendas_value_custo
      t.datetime :vendas_created_at
      t.datetime :vendas_updated_at
      t.integer :vendas_product_id
      t.string :vendas_product_nome
      t.string :vendas_product_subtipo
      t.string :return_code_api_return_code
      t.text :return_code_api_error_description_pt
      t.string :return_code_api_partner_name

      t.timestamps
    end
  end
end
