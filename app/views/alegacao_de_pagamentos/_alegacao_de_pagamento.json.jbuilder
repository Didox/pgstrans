json.extract! alegacao_de_pagamento, :id, :usuario_id, :valor_deposito, :data_deposito, :numero_talao, :banco_id, :comprovativo, :created_at, :updated_at
json.url alegacao_de_pagamento_url(alegacao_de_pagamento, format: :json)
