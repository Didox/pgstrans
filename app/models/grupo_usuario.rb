class GrupoUsuario < ApplicationRecord
  belongs_to :usuario
  belongs_to :grupo
end
