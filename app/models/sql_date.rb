class SqlDate
  def self.sql_parse(data)
  	if Rails.env == "production"
  		return (data - 1.hours).strftime("%Y-%m-%d %H:%M:%S")
  	else
  		return data.strftime("%Y-%m-%d %H:%M:%S")
  	end
  end

	def self.fix_sql_date_query
  	if Rails.env == "production"
  		return " - interval '1 hour'"
  	else
  		return ""
  	end
  end
end