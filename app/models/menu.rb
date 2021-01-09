class Menu < ApplicationRecord
  default_scope { order("sessao asc, nome asc") }
end
