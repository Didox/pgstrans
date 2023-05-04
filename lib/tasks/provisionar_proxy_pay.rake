namespace :jobs do
    desc "Importa csv"
    task importa_csv_proxy_pay: :environment do
        require 'csv'
        csv_file = Rails.root.join('lib/tasks', 'usuarios_com_nro_pagto_referencia_202305041741.csv')

        # Abre o arquivo CSV e itera através de cada linha
        CSV.foreach(csv_file, headers: true) do |row|
            # Extrai o ID, nome e número de cada linha
            id = row['id']
            nome = row['nome']
            email = row['email']
            telefone = row['telefone']
            login = row['login']
            nro_pagamento_referencia = row['nro_pagamento_referencia']
            next if nro_pagamento_referencia.to_s.strip.blank?

            usuario = Usuario.where(id: id).first
            if usuario.present?
                usuario.nro_pagamento_referencia = row['nro_pagamento_referencia']
                Usuario.where(id: usuario.id).update_all(nro_pagamento_referencia: row['nro_pagamento_referencia'])
                sucesso = ProxyPay.gerar_referencia(usuario)
                sleep(1)
                if sucesso
                    #require 'byebug'
                    #debugger
                    puts "========="
                    puts usuario.nro_pagamento_referencia
                    puts row['nro_pagamento_referencia']
                    puts sucesso.inspect
                    puts "========="
                end
            end
            
            # Imprime as informações extraídas para o console
            puts "ID: #{id}, Nome: #{nome}, Telefone: #{telefone}, Login: #{login}, Nro Pagamento Referencia: #{nro_pagamento_referencia}"

            arquivo_saida = File.open("lib/tasks/provisiona_proxy_pay_resultado.txt", "a")
            arquivo_saida.puts "ID: #{id}, Nome: #{nome}, Telefone: #{telefone}, Login: #{login}, Nro Pagamento Referencia: #{nro_pagamento_referencia}"
          
        end
    end
end









