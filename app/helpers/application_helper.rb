module ApplicationHelper
  def usuario_logado
  	Usuario.find(JSON.parse(cookies[:usuario_pgstrans_oauth])["id"])
  end

  def formata_numero_duas_casas(numero)
    number_to_currency(numero.to_f, :precision => 2).downcase.gsub(/kz|\./,"").gsub(",",".")
  end

  def children_text(children)
    return "" if children.blank?

    html = ""

    name = children.name rescue nil
    html += "<b>name:</b> #{name}<br>" if name.present?

    qtd = children.size rescue 0
    if qtd > 0
      children.each do |child|
        name = child.name rescue nil
        html += "<b>name:</b> #{name}<br>" if name.present?

        value = child.value rescue nil
        html += "<b>value:</b> #{value}<br>" if value.present?

        values = child.values rescue nil
        html += "<b>values:</b> #{values.join(" ")}<br>" if values.present?

        html += attributes_xml(children)

        childs = children.children rescue nil
        html += children_text(childs) if childs.present?
      end
    else
      html += "<b>text:</b> #{children.text}<br>" if children.text.present?
      html += attributes_xml(children)
      
      childs = children.children rescue nil
      html += children_text(childs) if childs.present?
    end

    return html
  end

  def attributes_xml(children)
    attributes = children.attributes rescue nil
    html = ""
    if attributes.present?
      if attributes["name"].present?
        html += "<b>name: </b> #{attributes["name"].value}<br>"
      end
      if attributes["address"].present?
        html += "<b>address: </b> #{attributes["address"].value}<br>"
      end
      if attributes["taxRef"].present?
        html += "<b>taxRef: </b> #{attributes["taxRef"].value}<br>"
      end
      if attributes["type"].present?
        html += "<b>Type: </b> #{attributes["type"].value}<br>"
      end
      if attributes["ean"].present?
        html += "<b>Ean: </b> #{attributes["ean"].value}<br>"
      end
      if attributes["dateTime"].present?
        html += "<b>DateTime: </b> #{attributes["dateTime"]}<br>"
      end
      if attributes["availCredit"].present?
        html += "<b>availCredit: </b> #{attributes["availCredit"]}<br>"
      end
      if attributes["contactNo"].present?
        html += "<b>contactNo: </b> #{attributes["contactNo"]}<br>"
      end
      if attributes["accNo"].present?
        html += "<b>accNo: </b> #{attributes["accNo"]}<br>"
      end
      if attributes["locRef"].present?
        html += "<b>locRef: </b> #{attributes["locRef"]}<br>"
      end
      if attributes["utilityType"].present?
        html += "<b>utilityType: </b> #{attributes["utilityType"]}<br>"
      end
      if attributes["daysLastPurchase"].present?
        html += "<b>daysLastPurchase: </b> #{attributes["daysLastPurchase"]}<br>"
      end
      if attributes["receiptNo"].present?
        html += "<b>receiptNo: </b> #{attributes["receiptNo"]}<br>"
      end
      if attributes["uniqueNumber"].present?
        html += "<b>UniqueNumber: </b> #{attributes["uniqueNumber"]}<br>"
      end
      if attributes["krn"].present?
        html += "<b>krn: </b> #{attributes["krn"]}<br>"
      end
      if attributes["ti"].present?
        html += "<b>ti: </b> #{attributes["ti"]}<br>"
      end
      if attributes["sgc"].present?
        html += "<b>sgc: </b> #{attributes["sgc"]}<br>"
      end
      if attributes["unitOfMeasurement"].present?
        html += "<b>unitOfMeasurement: </b> #{attributes["unitOfMeasurement"]}<br>"
      end
      if attributes["msno"].present?
        html += "<b>msno: </b> #{attributes["msno"]}<br>"
      end
      if attributes["tt"].present?
        html += "<b>tt: </b> #{attributes["tt"]}<br>"
      end
      if attributes["siUnit"].present?
        html += "<b>siUnit: </b> #{attributes["siUnit"]}<br>"
      end
      if attributes["value"].present?
        html += "<b>value:</b> #{children2.attributes["value"].value}<br>"
      end
      if attributes["symbol"].present?
        html += "<b>symbol:</b> #{attributes["symbol"].value}<br>"
      end
    end

    return html
  end
end
