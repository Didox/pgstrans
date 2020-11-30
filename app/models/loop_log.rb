class LoopLog < ApplicationRecord
  belongs_to :movicel_loop
  default_scope { order(updated_at: :desc) }
end
