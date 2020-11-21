class GrupoUsuario < ApplicationRecord
  belongs_to :usuario
  belongs_to :grupo

  default_scope { order(created_at: :asc) }
end
