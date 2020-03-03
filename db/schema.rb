# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_03_090501) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bancos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sigla"
    t.string "morada_sede"
    t.string "telefone_sede"
    t.string "fax_sede"
    t.string "morada_escritorio"
    t.string "telefone_escritorio"
    t.string "fax_escritorio"
    t.string "website"
    t.string "email"
    t.string "logomarca"
  end

  create_table "canal_vendas", force: :cascade do |t|
    t.string "nome"
    t.float "carregamento_minimo"
    t.bigint "dispositivo_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispositivo_id"], name: "index_canal_vendas_on_dispositivo_id"
  end

  create_table "conta_correntes", force: :cascade do |t|
    t.bigint "usuario_id"
    t.bigint "lancamento_id"
    t.bigint "banco_id"
    t.float "valor"
    t.string "iban"
    t.datetime "data_alegacao_pagamento"
    t.float "saldo_anterior"
    t.float "saldo_atual"
    t.datetime "data_ultima_atualizacao_saldo"
    t.text "observacao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "partner_id"
    t.index ["banco_id"], name: "index_conta_correntes_on_banco_id"
    t.index ["lancamento_id"], name: "index_conta_correntes_on_lancamento_id"
    t.index ["partner_id"], name: "index_conta_correntes_on_partner_id"
    t.index ["usuario_id"], name: "index_conta_correntes_on_usuario_id"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name_eng"
    t.string "name_pt"
    t.string "iso2"
    t.integer "bacen"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dispositivos", force: :cascade do |t|
    t.string "nome"
    t.string "marca"
    t.string "modelo"
    t.string "numero_serie"
    t.string "macaddr"
    t.string "imei"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "imei2"
    t.string "rated"
    t.string "screensize"
    t.string "so"
    t.string "ram_rom"
    t.string "conectividade"
  end

  create_table "industries", force: :cascade do |t|
    t.string "descricao_seccao"
    t.string "descricao_divisao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "descricao_grupo"
  end

  create_table "lancamentos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_profiles", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matrix_users", force: :cascade do |t|
    t.integer "master_profile"
    t.integer "sub_distribuidor"
    t.integer "sub_agente"
    t.integer "filial"
    t.integer "pdv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "usuario_id"
    t.index ["usuario_id"], name: "index_matrix_users_on_usuario_id"
  end

  create_table "moedas", force: :cascade do |t|
    t.string "nome"
    t.string "codigo_iso"
    t.string "simbolo"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_moedas_on_country_id"
  end

  create_table "municipios", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "parametros", force: :cascade do |t|
    t.string "url_integracao_desenvolvimento"
    t.string "url_integracao_producao"
    t.bigint "partner_id"
    t.string "agent_key_movicel_desenvolvimento"
    t.string "agent_key_movicel_producao"
    t.string "user_id_movicel_desenvolvimento"
    t.string "user_id_movicel_producao"
    t.string "data_source_dstv_desenvolvimento"
    t.string "data_source_dstv_producao"
    t.string "payment_vendor_code_dstv_desenvolvimento"
    t.string "payment_vendor_code_dstv_producao"
    t.string "vendor_code_dstv_desenvolvimento"
    t.string "vendor_code_dstv_producao"
    t.string "agent_account_dstv_desenvolvimento"
    t.string "agent_account_dstv_producao"
    t.string "currency_dstv_desenvolvimento"
    t.string "currency_dstv_producao"
    t.string "product_user_key_dstv_desenvolvimento"
    t.string "product_user_key_dstv_producao"
    t.string "mop_dstv_desenvolvimento"
    t.string "mop_dstv_producao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_key_zaptv_desenvolvimento"
    t.string "api_key_zaptv_producao"
    t.index ["partner_id"], name: "index_parametros_on_partner_id"
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "status_parceiro_id"
    t.integer "order"
    t.index ["status_parceiro_id"], name: "index_partners_on_status_parceiro_id"
  end

  create_table "perfil_usuarios", force: :cascade do |t|
    t.string "nome"
    t.boolean "admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "produtos", force: :cascade do |t|
    t.string "description"
    t.bigint "partner_id"
    t.bigint "status_produto_id"
    t.float "valor_compra_telemovel"
    t.float "valor_compra_site"
    t.float "valor_compra_pos"
    t.float "valor_compra_tef"
    t.float "valor_minimo_venda_telemovel"
    t.float "valor_minimo_venda_site"
    t.float "valor_minimo_venda_pos"
    t.float "valor_minimo_venda_tef"
    t.float "margem_telemovel"
    t.float "margem_pos"
    t.float "margem_tef"
    t.text "mensagem_cupom_venda"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "margem_site"
    t.bigint "moeda_id"
    t.string "produto_id_parceiro"
    t.float "valor_unitario"
    t.string "tipo"
    t.string "subtipo"
    t.index ["moeda_id"], name: "index_produtos_on_moeda_id"
    t.index ["partner_id"], name: "index_produtos_on_partner_id"
    t.index ["status_produto_id"], name: "index_produtos_on_status_produto_id"
  end

  create_table "provincia", force: :cascade do |t|
    t.string "nome"
    t.string "capital"
    t.string "area_km2"
    t.integer "population"
    t.string "image_map"
    t.bigint "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_provincia_on_country_id"
  end

  create_table "relatorio_conciliacao_zaptvs", force: :cascade do |t|
    t.bigint "partner_id"
    t.string "url"
    t.string "operation_code"
    t.string "source_reference"
    t.bigint "product_code"
    t.integer "quantity"
    t.datetime "date_time"
    t.string "type_data"
    t.float "total_price"
    t.string "status"
    t.float "unit_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["partner_id"], name: "index_relatorio_conciliacao_zaptvs_on_partner_id"
  end

  create_table "remuneracaos", force: :cascade do |t|
    t.bigint "usuario_id"
    t.bigint "produto_id"
    t.float "valor_venda_final_telemovel"
    t.float "valor_venda_final_site"
    t.float "valor_venda_final_pos"
    t.float "valor_venda_final_tef"
    t.datetime "vigencia_inicio"
    t.datetime "vigencia_fim"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["produto_id"], name: "index_remuneracaos_on_produto_id"
    t.index ["usuario_id"], name: "index_remuneracaos_on_usuario_id"
  end

  create_table "return_code_apis", force: :cascade do |t|
    t.string "return_code"
    t.string "return_description"
    t.string "error_description"
    t.string "error_description_pt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "partner_id"
    t.boolean "sucesso"
    t.index ["partner_id"], name: "index_return_code_apis_on_partner_id"
  end

  create_table "status_alegacao_pagamentos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "status_clientes", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "status_parceiros", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "status_produtos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_agentes", force: :cascade do |t|
    t.string "razao_social"
    t.string "nome_fantasia"
    t.string "bi"
    t.string "morada"
    t.string "bairro"
    t.string "email"
    t.string "telefone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "provincia_id"
    t.bigint "industry_id"
    t.string "contato"
    t.string "store_id_parceiro"
    t.string "agent_id_parceiro"
    t.string "terminal_id_parceiro"
    t.bigint "seller_id_parceiro"
    t.index ["industry_id"], name: "index_sub_agentes_on_industry_id"
    t.index ["provincia_id"], name: "index_sub_agentes_on_provincia_id"
  end

  create_table "sub_distribuidors", force: :cascade do |t|
    t.string "nome"
    t.string "bi"
    t.string "telefone"
    t.string "morada"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "provincia_id"
    t.bigint "municipio_id"
    t.index ["municipio_id"], name: "index_sub_distribuidors_on_municipio_id"
    t.index ["provincia_id"], name: "index_sub_distribuidors_on_provincia_id"
  end

  create_table "tipo_transacaos", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "uni_pessoal_empresas", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unitel_sequences", force: :cascade do |t|
    t.integer "sequence_id"
    t.bigint "venda_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["venda_id"], name: "index_unitel_sequences_on_venda_id"
  end

  create_table "usuario_acessos", force: :cascade do |t|
    t.bigint "usuario_id"
    t.string "mac_adress"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["usuario_id"], name: "index_usuario_acessos_on_usuario_id"
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "senha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "perfil_usuario_id"
    t.bigint "sub_agente_id"
    t.bigint "status_cliente_id"
    t.index ["perfil_usuario_id"], name: "index_usuarios_on_perfil_usuario_id"
    t.index ["status_cliente_id"], name: "index_usuarios_on_status_cliente_id"
    t.index ["sub_agente_id"], name: "index_usuarios_on_sub_agente_id"
  end

  create_table "vendas", force: :cascade do |t|
    t.string "product_id"
    t.string "agent_id"
    t.string "store_id"
    t.string "seller_id"
    t.string "terminal_id"
    t.float "value"
    t.string "client_msisdn"
    t.text "request_send"
    t.text "response_get"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "partner_id"
    t.bigint "usuario_id"
    t.string "status"
    t.string "request_id"
    t.index ["partner_id"], name: "index_vendas_on_partner_id"
    t.index ["usuario_id"], name: "index_vendas_on_usuario_id"
  end

  add_foreign_key "canal_vendas", "dispositivos"
  add_foreign_key "conta_correntes", "bancos"
  add_foreign_key "conta_correntes", "lancamentos"
  add_foreign_key "conta_correntes", "partners"
  add_foreign_key "conta_correntes", "usuarios"
  add_foreign_key "matrix_users", "usuarios"
  add_foreign_key "moedas", "countries"
  add_foreign_key "parametros", "partners"
  add_foreign_key "partners", "status_parceiros"
  add_foreign_key "produtos", "moedas"
  add_foreign_key "produtos", "partners"
  add_foreign_key "produtos", "status_produtos"
  add_foreign_key "provincia", "countries"
  add_foreign_key "relatorio_conciliacao_zaptvs", "partners"
  add_foreign_key "remuneracaos", "produtos"
  add_foreign_key "remuneracaos", "usuarios"
  add_foreign_key "return_code_apis", "partners"
  add_foreign_key "sub_agentes", "industries"
  add_foreign_key "sub_agentes", "provincia", column: "provincia_id"
  add_foreign_key "sub_distribuidors", "municipios"
  add_foreign_key "sub_distribuidors", "provincia", column: "provincia_id"
  add_foreign_key "unitel_sequences", "vendas"
  add_foreign_key "usuario_acessos", "usuarios"
  add_foreign_key "usuarios", "perfil_usuarios"
  add_foreign_key "usuarios", "status_clientes"
  add_foreign_key "usuarios", "sub_agentes"
  add_foreign_key "vendas", "partners"
  add_foreign_key "vendas", "usuarios"
end
