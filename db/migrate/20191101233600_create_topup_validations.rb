class CreateTopupValidations < ActiveRecord::Migration[5.2]
  def change
    create_table :topup_validations do |t|
      t.string :spree_order_id
      t.string :spree_products_id
      t.string :header_element
      t.string :validate_topup_req_header_element
      t.string :request_id
      t.timestamp :header_timestamp
      t.string :header_source_system
      t.string :credentials_element
      t.string :credentials_user
      t.string :credentials_password
      t.string :attributes_list
      t.string :attributes_element
      t.string :attribute_name
      t.string :attribute_value
      t.string :body_element
      t.string :validation_topup_req
      t.string :validate_topup_input_message
      t.integer :validate_topup_req_body_type
      t.float :validate_topup_req_body_amount
      t.string :validate_topup_req_body_msisdn
      t.string :op_header
      t.string :op_validate_topup_input_message
      t.string :op_request_id
      t.string :op_return_code
      t.string :op_return_message
      t.timestamp :op_timestamp
      t.string :op_body_element
      t.string :op_body_validate_topup_resp
      t.string :op_body_validate_topup_output_message
      t.timestamp :qtde_retry

      t.timestamps
    end
  end
end
