class EndeUniqNumber < ApplicationRecord
  def unique_number
    self.id.to_s.rjust(4, '0')
  end
end
