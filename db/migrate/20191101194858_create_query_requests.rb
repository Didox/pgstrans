class CreateQueryRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :query_requests do |t|
      t.string :header_element
      t.string :query_request_req_header
      t.string :header_request_id
      t.timestamp :header_timestamp
      t.string :header_source_system
      t.string :credentials_element
      t.string :credentials_user
      t.string :credentials_password
      t.string :attributes_list
      t.string :attribute_element
      t.string :attribute_name
      t.string :attribute_value
      t.string :body_element
      t.string :body_query_request_req_element
      t.string :body_query_request_input_message
      t.string :body_query_request_id
      t.string :od_header_element
      t.string :od_query_request_input_message
      t.string :od_query_request_request_id
      t.string :od_query_request_return_code
      t.string :od_query_request_return_message
      t.timestamp :od_query_request_timestamp
      t.string :od_query_request_body_element
      t.string :od_query_request_output_message
      t.string :od_query_request_request_id
      t.integer :od_query_request_status

      t.timestamps
    end
  end
end
