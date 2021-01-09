class Menu < ApplicationRecord
  default_scope { order("ordem asc") }
end
