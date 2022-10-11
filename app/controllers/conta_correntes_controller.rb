class ContaCorrentesController < ApplicationController
  before_action :set_conta_corrente, only: [:show, :edit, :update, :destroy]
  skip_before_action :verify_authenticity_token

  def index_api
    index
  end

  def index
    if usuario_logado.admin? || usuario_logado.operador?
      @conta_correntes = ContaCorrente.all
    else
      @conta_correntes = ContaCorrente.com_acesso(usuario_logado)
    end

    @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
    @conta_correntes = @conta_correntes.reorder("data_alegacao_pagamento desc")
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", SqlDate.sql_parse(params[:data_alegacao_pagamento_inicio].to_datetime)) if params[:data_alegacao_pagamento_inicio].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento <= ?", SqlDate.sql_parse(params[:data_alegacao_pagamento_fim].to_datetime)) if params[:data_alegacao_pagamento_fim].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_ultima_atualizacao_saldo >= ?", SqlDate.sql_parse(params[:data_ultima_atualizacao_saldo_inicio].to_datetime.beginning_of_day)) if params[:data_ultima_atualizacao_saldo_inicio].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_ultima_atualizacao_saldo <= ?", SqlDate.sql_parse(params[:data_ultima_atualizacao_saldo_fim].to_datetime)) if params[:data_ultima_atualizacao_saldo_fim].present?
    @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @conta_correntes = @conta_correntes.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
    @conta_correntes = @conta_correntes.where("usuarios.id = ?", params[:id]) if params[:id].present?
    @conta_correntes = @conta_correntes.where("usuarios.perfil_usuario_id = ?", params[:perfil_usuario_id]) if params[:perfil_usuario_id].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.lancamento_id = ?", params[:lancamento_id]) if params[:lancamento_id].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.observacao ilike '%#{params[:observacao].remove_injection}%'") if params[:observacao].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.iban ilike '%#{params[:iban].remove_injection}%'") if params[:iban].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.id = ?", params[:id_lancamento]) if params[:id_lancamento].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.banco_id = ?", params[:banco_id]) if params[:banco_id].present?

    params[:status] = (StatusCliente.where("lower(nome) = 'ativo'").first.id rescue "") unless params.has_key?(:status)
    if params[:status].present?
      @conta_correntes  = @conta_correntes.where("usuarios.status_cliente_id = ?", params[:status])
    end
    
    if params[:responsavel].present?
      @conta_correntes = @conta_correntes.joins("inner join usuarios as responsavel on responsavel.id = conta_correntes.responsavel_aprovacao_id")
      @conta_correntes = @conta_correntes.where("responsavel.nome ilike '%#{params[:responsavel].remove_injection}%'")
    end

    @conta_correntes_total = @conta_correntes.count
    @valor_total = @conta_correntes.sum(:valor)
    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
  end

  def conta_corrente_resumido
    @page = params[:page] || 1
    @per_page = 10
    @page = @page.to_i
    fetch = (@page - 1) * @per_page

    sqlDatas = ""
    sqlDatas += " and conta_correntes.data_alegacao_pagamento >= '#{SqlDate.sql_parse(params[:data_inicio].to_datetime)}'" if params[:data_inicio].present?
    sqlDatas += " and conta_correntes.data_alegacao_pagamento <= '#{SqlDate.sql_parse(params[:data_fim].to_datetime)}'" if params[:data_fim].present?

    if (params[:data_inicio].present? || params[:data_fim].present?)
      data_formatada = "conta_correntes.data_alegacao_pagamento" 
      observacao = "conta_correntes.observacao, usuarios_credito.nome as cliente, "
    else
      data_formatada = "to_char((conta_correntes.data_alegacao_pagamento #{SqlDate.fix_sql_date_query}), 'YYYY/MM/DD')"
      observacao = ""
    end

    sql_nome = params[:responsavel].present? ? " and lower(usuarios.nome) ilike '%#{params[:responsavel].remove_injection.downcase}%'" : ""
    sql_observacao = params[:observacao].present? ? " and lower(conta_correntes.observacao) ilike '%#{params[:observacao].remove_injection.downcase}%'" : ""
    sql_lancamento_id = params[:lancamento_id].present? ? " and conta_correntes.lancamento_id = '#{params[:lancamento_id].remove_injection}'" : ""
    status_cliente_id = params[:status_cliente_id].present? ? " and usuarios.status_cliente_id = '#{params[:status_cliente_id].remove_injection}'" : ""
    perfil_usuario_id = params[:perfil_usuario_id].present? ? " and usuarios.perfil_usuario_id = '#{params[:perfil_usuario_id].remove_injection}'" : ""

    sql = "
      select
        #{data_formatada} as data_alegacao_pagamento,
        usuarios.nome as usuario,
        lancamentos.nome as lancamento,
        #{observacao}
        sum(valor) as valor
      from conta_correntes
      inner join usuarios on usuarios.id = conta_correntes.responsavel_aprovacao_id
      inner join usuarios usuarios_credito on usuarios_credito.id = conta_correntes.usuario_id
      inner join lancamentos on lancamentos.id = conta_correntes.lancamento_id
      where usuarios.id is not null
      #{sqlDatas}
      #{sql_nome}
      #{sql_observacao}
      #{sql_lancamento_id}
      #{status_cliente_id}
      #{perfil_usuario_id}
      group by
        #{data_formatada}, 
        #{observacao.gsub(/as cliente/, "")}
        usuarios.id,
        lancamentos.id
      order by data_alegacao_pagamento desc
      limit #{@per_page} offset #{fetch}
    "
    @sql = sql.gsub(/\n/, "")

    sqlTotalGeral = "select  
                      sum(valor) as valor
                    from#{@sql.gsub(/select.*?from|group by.*/, "")}"
    
    sqlQuantidade = "select  
                        count(1) as quantidade
                      from#{@sql.gsub(/select.*?from|group by.*/, "")}"
    
    @valor_total = ActiveRecord::Base.connection.exec_query(sqlTotalGeral).first["valor"] rescue 0
    @quantidade = ActiveRecord::Base.connection.exec_query(sqlQuantidade).first["quantidade"] rescue 0
    @conta_correntes = ActiveRecord::Base.connection.exec_query(sql)
  end

  def conciliacao
    if usuario_logado.admin? || usuario_logado.operador?
      @conta_correntes = ContaCorrente.all
    else
      @conta_correntes = ContaCorrente.com_acesso(usuario_logado)
    end

    @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
    @conta_correntes = @conta_correntes.reorder("data_alegacao_pagamento desc")
    @conta_correntes = @conta_correntes.where("conta_correntes.data_alegacao_pagamento >= ?", SqlDate.sql_parse(params[:data_alegacao_pagamento].to_datetime.beginning_of_day)) if params[:data_alegacao_pagamento].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.data_ultima_atualizacao_saldo <= ?", SqlDate.sql_parse(params[:data_ultima_atualizacao_saldo].to_datetime)) if params[:data_ultima_atualizacao_saldo].present?
    @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @conta_correntes = @conta_correntes.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
    @conta_correntes = @conta_correntes.where("usuarios.id = ?", params[:id]) if params[:id].present?
    @conta_correntes = @conta_correntes.where("usuarios.perfil_usuario_id = ?", params[:perfil_usuario_id]) if params[:perfil_usuario_id].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.lancamento_id = ?", params[:lancamento_id]) if params[:lancamento_id].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.observacao ilike '%#{params[:observacao].remove_injection}%'") if params[:observacao].present?
    @conta_correntes = @conta_correntes.where("conta_correntes.id = ?", params[:conta_corrente_id]) if params[:conta_corrente_id].present?

    @conta_correntes = @conta_correntes.reorder("id asc")
    @primeira_entrada_id = @conta_correntes.first.id
    paginas = 50
    paginas = params[:quantidade_registros].to_i if params[:quantidade_registros].present?
    options = {page: params[:page] || 1, per_page: paginas}
    @conta_correntes_total = @conta_correntes.count
    @conta_correntes = @conta_correntes.paginate(options)
  end

  def conciliacao_aplicar
    if params[:cc_id].blank?
      params[:conta_corrente_id].each do |conta_corrente_id|
        cc = ContaCorrente.find(conta_corrente_id)
        ContaCorrente.where(id: cc.id).update_all(saldo_atual: cc.saldo_atual_do_registro_atual, saldo_anterior: cc.saldo_atual_do_registro_anterior)
      end
    else
      cc = ContaCorrente.find(params[:cc_id])
      ContaCorrente.where(id: cc.id).update_all(saldo_atual: params[:saldo_atual]) if params[:saldo_atual].present?
      ContaCorrente.where(id: cc.id).update_all(saldo_anterior: params[:saldo_anterior]) if params[:saldo_anterior].present?
      return if request.path_parameters[:format] == 'json'
    end

    redirect_to "/conta_correntes/conciliacao?data_alegacao_pagamento=#{params[:data_alegacao_pagamento]}&data_ultima_atualizacao_saldo=#{params[:data_ultima_atualizacao_saldo]}&nome=#{params[:nome]}&login=#{params[:login]}&id=#{params[:id]}&id_lancamento=#{params[:id_lancamento]}&responsavel=#{params[:responsavel]}&iban=#{params[:iban]}&lancamento_id=#{params[:lancamento_id]}&quantidade_registros=#{params[:quantidade_registros]}"
  end

  # GET /conta_correntes/1
  # GET /conta_correntes/1.json
  def show
  end

  def index_morada_saldo
    @usuarios = Usuario.com_acesso(usuario_logado)
    @usuarios = @usuarios.reorder("nome asc")
    @usuarios = @usuarios.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'") if params[:nome].present?
    @usuarios = @usuarios.where("usuarios.login ilike '%#{params[:login].remove_injection}%'") if params[:login].present?
    @usuarios = @usuarios.where("usuarios.morada ilike '%#{params[:morada].remove_injection}%'") if params[:morada].present?
    @usuarios = @usuarios.where("usuarios.bairro ilike '%#{params[:bairro].remove_injection}%'") if params[:bairro].present?
    @usuarios = @usuarios.where("usuarios.municipio_id = ?", params[:municipio_id]) if params[:municipio_id].present?
    @usuarios = @usuarios.where("usuarios.provincia_id = ?", params[:provincia_id]) if params[:provincia_id].present?
    @usuarios = @usuarios.where("usuarios.perfil_usuario_id = ?", params[:perfil_usuario_id]) if params[:perfil_usuario_id].present?

    params[:status] = (StatusCliente.where("lower(nome) = 'ativo'").first.id rescue "") unless params.has_key?(:status)
    if params[:status].present?
      @usuarios = @usuarios.where("usuarios.status_cliente_id = ?", params[:status])
    end
    @usuarios_total = @usuarios.count

    where = @usuarios.to_sql.gsub("\n","").scan(/WHERE.*/).first
    where = where.gsub(/ORDER.*/, "")
    sql = "
      select 
        sum((
          select conta_correntes.saldo_atual from conta_correntes 
          where conta_correntes.usuario_id = usuarios.id
          order by conta_correntes.data_ultima_atualizacao_saldo desc limit 1
        )) as total
      from usuarios
      #{where}
    "

    @valor_total = ActiveRecord::Base.connection.exec_query(sql).first["total"].to_i 

    if params[:saldo_menor_que].present?
      @usuarios = @usuarios.where("
        (
          select sum((
              select conta_correntes.saldo_atual from conta_correntes 
              where conta_correntes.usuario_id = u.id
              order by conta_correntes.data_ultima_atualizacao_saldo desc limit 1
            ))
          from usuarios u
          where u.id = usuarios.id
        ) <= ?
      ", params[:saldo_menor_que].to_f)
    end

    options = {page: params[:page] || 1, per_page: 10}
    @usuarios = @usuarios.paginate(options)
  end

  def index_carregamento_usuario
    @conta_correntes = ContaCorrente.com_acesso(usuario_logado)
    #@conta_correntes = @conta_correntes.where(usuario_id: params[:usuario_id])

    if params[:nome].present?
      @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
      @conta_correntes = @conta_correntes.where("usuarios.nome ilike '%#{params[:nome].remove_injection}%'")
    end
    
    if params[:login].present?
      @conta_correntes = @conta_correntes.joins("inner join usuarios on usuarios.id = conta_correntes.usuario_id")
      @conta_correntes = @conta_correntes.where("usuarios.login ilike '%#{params[:login].remove_injection}%'")
    end
    
    @conta_correntes = @conta_correntes.where("conta_correntes.lancamento_id = ?", params[:lancamento_id]) if params[:lancamento_id].present?
    
    if params[:responsavel].present?
      @conta_correntes = @conta_correntes.joins("inner join usuarios as responsavel on responsavel.id = conta_correntes.responsavel_aprovacao_id")
      @conta_correntes = @conta_correntes.where("responsavel.nome ilike '%#{params[:responsavel].remove_injection}%'")
    end

    @conta_correntes_total = @conta_correntes.count
    @valor_total = @conta_correntes.sum(:valor)
    options = {page: params[:page] || 1, per_page: 10}
    @conta_correntes = @conta_correntes.paginate(options)
    @conta_correntes = @conta_correntes.reorder("created_at desc")
  
    if params[:download_xlsx].present?
        filename = "carregamento_usuario_#{Time.zone.now.strftime("%Y%m%d%H%M%S")}.xlsx"
        workbook = WriteXLSX.new("/tmp/#{filename}")
        worksheet = workbook.add_worksheet

        format = workbook.add_format
        format.set_bold

        worksheet.write(0,0, "ID Usuário", format)
        worksheet.write(0,1, "Login do Usuário", format)
        worksheet.write(0,2, "Nome do Usuário", format)
        worksheet.write(0,3, "Valor do Lançamento", format)
        worksheet.write(0,4, "Data do Lançamento", format)
        worksheet.write(0,5, "Tipo do Lançamento", format)
        worksheet.write(0,6, "Responsável pela aprovação", format)

        i = 1
        @conta_correntes.each do |conta_corrente|
          worksheet.write(i, 0, conta_corrente.usuario.id)
          worksheet.write(i, 1, conta_corrente.usuario.login)
          worksheet.write(i, 2, conta_corrente.usuario.nome)
          worksheet.write(i, 3, conta_corrente.valor)
          worksheet.write(i, 4, conta_corrente.data_alegacao_pagamento.strftime("%d/%m/%Y %H:%M"))
          worksheet.write(i, 5, (conta_corrente.lancamento.nome rescue ""))
          worksheet.write(i, 6, (conta_corrente.responsavel_aprovacao.nome rescue ""))
          i += 1
        end

        workbook.close

        send_data File.read("/tmp/#{filename}"), type: "application/xlsx", filename: filename

        return
      end
  end


  # GET /conta_correntes/new
  def new
    @conta_corrente = ContaCorrente.new
    @conta_corrente.responsavel = usuario_logado
    @conta_corrente.data_alegacao_pagamento = Time.zone.now
  end

  # GET /conta_correntes/1/edit
  def edit
  end

  # POST /conta_correntes
  # POST /conta_correntes.json
  def create_api
    create
  end

  def create
    ActiveRecord::Base.transaction do
      if !usuario_logado.admin? && !usuario_logado.operador? && !usuario_logado.agente?
        flash[:error] = "Ação não permitida! Somente o Administrador tem acesso a essa operação."
        redirect_to conta_correntes_url
        return
      end

      if !usuario_logado.admin? && !usuario_logado.operador? && (usuario_logado.saldo < 0.1 || usuario_logado.saldo < conta_corrente_params[:valor].to_f)
        flash[:error] = "Saldo insuficiente."
        redirect_to conta_correntes_url
        return
      end
      
      @conta_corrente = ContaCorrente.new(conta_corrente_params)
      @conta_corrente.responsavel = usuario_logado
      @conta_corrente.responsavel_aprovacao_id = usuario_logado.id
      
      if @conta_corrente.lancamento_id.present? && @conta_corrente.lancamento.nome == Lancamento::DEBITO
        @conta_corrente.valor = "-#{@conta_corrente.valor.abs}"
      else
        @conta_corrente.valor = (@conta_corrente.valor || 0).abs
      end
      
      respond_to do |format|
        if @conta_corrente.save

          if !usuario_logado.admin? && !usuario_logado.operador? && @conta_corrente.lancamento.nome != Lancamento::DEBITO
            conta_corrente_retirada = ContaCorrente.new(conta_corrente_params)
            conta_corrente_retirada.id = nil
            conta_corrente_retirada.valor = "-#{conta_corrente_retirada.valor.abs}"
            conta_corrente_retirada.usuario = usuario_logado
            conta_corrente_retirada.responsavel = usuario_logado
            conta_corrente_retirada.lancamento = Lancamento.where(nome: Lancamento::TRANSFERENCIA_ENTRE_USUARIOS).first || Lancamento.first
            conta_corrente_retirada.responsavel_aprovacao_id = usuario_logado.id
            conta_corrente_retirada.observacao = "Transferência entre contas para o usuário #{@conta_corrente.usuario.nome} (#{@conta_corrente.usuario_id}). #{conta_corrente_retirada.observacao}"
            conta_corrente_retirada.save!
          end

          format.html { redirect_to conta_correntes_url, notice: 'Transação efetuada com sucesso.' }
          format.json { render :show, status: :created, location: @conta_corrente }
        else
          format.html { render :new }
          format.json { render json: @conta_corrente.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /conta_correntes/1
  # DELETE /conta_correntes/1.json
  def destroy
    if !usuario_logado.admin? && !usuario_logado.operador? && !usuario_logado.agente?
      flash[:error] = "Ação não permitida! Somente o Administrador tem acesso a essa operação."
      redirect_to conta_correntes_url
      return
    end

    @conta_corrente.destroy
    respond_to do |format|
      format.html { redirect_to conta_correntes_url, notice: 'Conta corrente foi apagada com sucesso.' }
      format.json { head :no_content }
    end
  end

  private
  
  def set_conta_corrente
    @conta_corrente = ContaCorrente.find(params[:id])
  end

  def conta_corrente_params
    parametros = request.path_parameters[:format] == 'json' ? params : params.require(:conta_corrente)
    parametros.permit(:usuario_id, :lancamento_id, :banco_id, :valor, :iban,
        :data_alegacao_pagamento, :observacao, :morada, :bairro, :municipio_id, 
        :provincia_id)
  end
end
