class UsuarioAcesso < ApplicationRecord
  include PermissionamentoDados
  belongs_to :usuario
end
