class Rest
  def self.all(url, aluno_id=nil, query={})
    uri = URI.parse(URI.escape(url))
    request = HTTParty.get(uri, :query => query)
    if (200...300).include?(request.code.to_i)
      if request.body.present?
        return JSON.parse(request.body)
      end
    end
    return []
  rescue
    return []
  end

  def self.exist?(url, aluno_id=nil, query={})
    uri = URI.parse(URI.escape(url))
    request = HTTParty.get(uri, :query => query)
    if (200...300).include?(request.code.to_i)
      return true
    end
    return false
  rescue
    return false
  end

  def self.show(url, aluno_id=nil, query={})
    uri = URI.parse(URI.escape(url))
    request = HTTParty.get(uri, :query => query)
    if (200...300).include?(request.code.to_i)
      if request.body.present?
        return JSON.parse(request.body);
      end
    end
    return {}
  rescue
    return {}
  end

  def self.post(url, data={})
    uri = URI.parse(URI.escape(url))
    request = HTTParty.post(uri, :body => data)
    if (200...300).include?(request.code.to_i)
      if request.body.present?
        return JSON.parse(request.body);
      end
    else
      if request.body.present?
        return JSON.parse(request.body);
      end
      return {}
    end
  rescue Exception => erro
    return {}
  end

  def self.put(url, data={})
    uri = URI.parse(URI.escape(url))
    request = HTTParty.put(uri, :body => data)
    if (200...300).include?(request.code.to_i)
      if request.body.present?
        return JSON.parse(request.body);
      end
    else
      if request.body.present?
        return JSON.parse(request.body);
      end
      return {}
    end
  rescue Exception => erro
    return {}
  end
end
