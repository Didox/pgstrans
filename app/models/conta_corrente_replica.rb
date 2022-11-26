class ContaCorrenteReplica < ContaCorrente
  self.table_name = "conta_correntes"
  establish_connection :primary_replica
end