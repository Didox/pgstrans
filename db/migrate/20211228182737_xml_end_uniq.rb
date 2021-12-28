class XmlEndUniq < ActiveRecord::Migration[5.2]
  def change
    add_column :ende_uniq_numbers, :xml_enviado, :text
    add_column :ende_uniq_numbers, :xml_recebido, :text
  end
end
