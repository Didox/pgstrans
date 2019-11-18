class MasterProfile
  def self.all()
    profiles = Rest.all("https://www.pagaso.com.br/master_profiles.json")
    profiles.map{|c| OpenStruct.new(c) }
  end
end
