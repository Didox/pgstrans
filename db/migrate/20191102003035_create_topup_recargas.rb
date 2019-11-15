class CreateTopupRecargas < ActiveRecord::Migration[5.2]
  def change
    create_table :topup_recargas do |t|
      t.string :validation_id
      t.string :header_element
      t.string :topup_req_header
      t.string :request_id
      t.string :header_timestamp
      t.string :header_source_system
      t.string :credentials_element
      t.string :credentials_user
      t.string :credentials_password
      t.string :attributes_list
      t.string :attribute_element
      t.string :attribute_name
      t.string :attribute_value
      t.string :body_element
      t.string :body_req_element
      t.string :body_input_message
      t.integer :body_topup_req_body_type
      t.float :body_topup_req_body_amount
      t.string :body_topup_req_body_msisdn
      t.string :od_header_element
      t.string :od_topup_resp_input_message

      t.timestamps
    end
  end
end
