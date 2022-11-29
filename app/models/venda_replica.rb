class VendaReplica < Venda
  self.table_name = "vendas"
  establish_connection :primary_replica
end