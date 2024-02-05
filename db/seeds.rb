PerfilUsuario.create(nome: "Admin", admin: true) if PerfilUsuario.where(nome: "Admin").count == 0
Usuario.create(nome: "Time Pagaso", email: "time@pagaso.com", senha: "123456", perfil_usuario_id:  PerfilUsuario.first.id, responsavel: Usuario.new) if Usuario.where(email: "time@pagaso.com").count == 0
