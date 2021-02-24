class Log < ApplicationRecord
  default_scope { order(created_at: :desc) }

  def self.responsavel_log=(responsavel)
    @@responsavel_log = responsavel
  end

  def self.responsavel_log
    @@responsavel_log
  rescue
    nil
  end

  def self.save_log(titulo, dados)
    if Log.responsavel_log.present?
      Log.create(titulo: titulo, responsavel: Log.responsavel_log, dados_alterados: dados.to_json)
    end
  end

  def responsavel_obj_compara
    log_anterior = Log.where(titulo: self.titulo).where("id not in (#{self.id}) and id < #{self.id} and dados_alterados ilike '%id\":#{self.responsavel_obj["id"]},%' ").limit(1).first

    return self.responsavel_obj if log_anterior.blank?

    dados = {}
    log_anterior.responsavel_obj.each do |key_old,value_old|
      self.responsavel_obj.each do |key,value|
        if key_old == key && value_old != value
          dados[key] = "<br><b>Atual:</b> #{value}<br><b>Anterior:</b> <i>#{value_old}</i><br><br>"
        end
      end
    end

    return dados
  end

  def responsavel_obj
  	JSON.parse(self.dados_alterados)
  rescue
  	{}
  end
end
