class SqlDate
  def self.sql_parse(data)
  	if Rails.env == "production"
  		return (data - 1.hours).strftime("%Y-%m-%d %H:%M:%S")
  	else
  		return data.strftime("%Y-%m-%d %H:%M:%S")
  	end
  end
end