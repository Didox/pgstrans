class SaldoMoedaDstv < ActiveRecord::Migration[5.2]
  def change
    add_column :saldo_parceiro_dstvs, :saldo, :float
    add_column :saldo_parceiro_dstvs, :moeda, :string
    add_column :saldo_parceiro_dstvs, :agent_first_name, :string
    add_column :saldo_parceiro_dstvs, :agent_last_name, :string
    add_column :saldo_parceiro_dstvs, :audit_reference_number, :string
    add_column :saldo_parceiro_dstvs, :device_id, :string
    add_column :saldo_parceiro_dstvs, :device_description, :string
  end
end
