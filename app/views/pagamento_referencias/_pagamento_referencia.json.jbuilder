json.extract! pagamento_referencia, :id, :usuario_id, :nro_pagamento_referencia, :id_trn_parceiro, :valor_pagamento, :data_pagamento, :data_conciliacao, :terminal_id, :terminal_location, :terminal_type, :created_at, :updated_at
json.url pagamento_referencia_url(pagamento_referencia, format: :json)
