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

ActiveRecord::Schema.define(version: 2019_11_19_001303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "industries", force: :cascade do |t|
    t.string "descr_curta"
    t.string "descr_longa"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "master_profiles", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "matrix_users", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "master_profile"
    t.integer "sub_distribuidor"
    t.integer "sub_agente"
    t.integer "filial"
    t.integer "pdv"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "municipios", force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "partners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "query_balances", force: :cascade do |t|
    t.string "header_element"
    t.string "query_balance_req_header"
    t.string "header_request_id"
    t.datetime "header_timestamp"
    t.string "header_source_system"
    t.string "credentials_element"
    t.string "credentials_user"
    t.string "credentials_password"
    t.string "attributes_list"
    t.string "attribute_element"
    t.string "attribute_name"
    t.string "attribute_value"
    t.string "body_element"
    t.string "body_query_balance_req_element"
    t.string "body_query_balance_input_message"
    t.string "od_header_element"
    t.string "od_query_balance_input_message"
    t.string "od_query_balance_request_id"
    t.string "od_query_balance_return_code"
    t.string "od_query_balance_return_message"
    t.datetime "od_query_balance_timestamp"
    t.string "od_query_balance_body_element"
    t.string "od_query_balance_resp"
    t.string "od_query_balance_output_message"
    t.float "od_query_balance_balance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "query_requests", force: :cascade do |t|
    t.string "header_element"
    t.string "query_request_req_header"
    t.string "header_request_id"
    t.datetime "header_timestamp"
    t.string "header_source_system"
    t.string "credentials_element"
    t.string "credentials_user"
    t.string "credentials_password"
    t.string "attributes_list"
    t.string "attribute_element"
    t.string "attribute_name"
    t.string "attribute_value"
    t.string "body_element"
    t.string "body_query_request_req_element"
    t.string "body_query_request_input_message"
    t.string "body_query_request_id"
    t.string "od_header_element"
    t.string "od_query_request_input_message"
    t.string "od_query_request_request_id"
    t.string "od_query_request_return_code"
    t.string "od_query_request_return_message"
    t.datetime "od_query_request_timestamp"
    t.string "od_query_request_body_element"
    t.string "od_query_request_output_message"
    t.integer "od_query_request_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "return_code_apis", force: :cascade do |t|
    t.string "return_code"
    t.string "return_description"
    t.string "error_description"
    t.string "error_description_pt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "partner_code"
  end

  create_table "sub_agentes", force: :cascade do |t|
    t.string "razao_social"
    t.string "nome_fantasia"
    t.string "bi"
    t.string "industry_id"
    t.string "morada"
    t.string "bairro"
    t.string "provincia"
    t.string "email"
    t.string "telefone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sub_distribuidors", force: :cascade do |t|
    t.string "nome"
    t.string "bi"
    t.string "telefone"
    t.string "morada"
    t.string "municipio"
    t.string "provincia"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topup_recargas", force: :cascade do |t|
    t.string "validation_id"
    t.string "header_element"
    t.string "topup_req_header"
    t.string "request_id"
    t.string "header_timestamp"
    t.string "header_source_system"
    t.string "credentials_element"
    t.string "credentials_user"
    t.string "credentials_password"
    t.string "attributes_list"
    t.string "attribute_element"
    t.string "attribute_name"
    t.string "attribute_value"
    t.string "body_element"
    t.string "body_req_element"
    t.string "body_input_message"
    t.integer "body_topup_req_body_type"
    t.float "body_topup_req_body_amount"
    t.string "body_topup_req_body_msisdn"
    t.string "od_header_element"
    t.string "od_topup_resp_input_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "topup_validations", force: :cascade do |t|
    t.string "spree_order_id"
    t.string "spree_products_id"
    t.string "header_element"
    t.string "validate_topup_req_header_element"
    t.string "request_id"
    t.datetime "header_timestamp"
    t.string "header_source_system"
    t.string "credentials_element"
    t.string "credentials_user"
    t.string "credentials_password"
    t.string "attributes_list"
    t.string "attributes_element"
    t.string "attribute_name"
    t.string "attribute_value"
    t.string "body_element"
    t.string "validation_topup_req"
    t.string "validate_topup_input_message"
    t.integer "validate_topup_req_body_type"
    t.float "validate_topup_req_body_amount"
    t.string "validate_topup_req_body_msisdn"
    t.string "op_header"
    t.string "op_validate_topup_input_message"
    t.string "op_request_id"
    t.string "op_return_code"
    t.string "op_return_message"
    t.datetime "op_timestamp"
    t.string "op_body_element"
    t.string "op_body_validate_topup_resp"
    t.string "op_body_validate_topup_output_message"
    t.datetime "qtde_retry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usuarios", force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.string "senha"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
