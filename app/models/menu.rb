class Menu < ApplicationRecord
  default_scope { order("ordem_secao asc, ordem_item asc") }
  validates :secao, presence: true
  validates :nome, presence: true, uniqueness: true
end
