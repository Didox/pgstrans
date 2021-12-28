class EndeUniqNumbersController < ApplicationController
    before_action :set_ende_uniq_number, only: [:show, :edit, :update, :destroy]
  
    # GET /ende_uniq_numbers
    # GET /ende_uniq_numbers.json
    def index
      @ende_uniq_numbers = EndeUniqNumber.all.order(id: :desc)
  
      @ende_uniq_numbers = @ende_uniq_numbers.where("id = ?", params[:id]) if params[:id].present?
      if params[:created_at].present?
        @ende_uniq_numbers = @ende_uniq_numbers.where("created_at >= ?", SqlDate.sql_parse(params[:created_at].to_datetime.beginning_of_day)) 
        @ende_uniq_numbers = @ende_uniq_numbers.where("created_at <= ?", SqlDate.sql_parse(params[:created_at].to_datetime.end_of_day))
      end
      #@ende_uniq_numbers = @ende_uniq_numbers.where("request_body ilike '%#{params[:request_body].remove_injection}%'") if params[:request_body].present?
      #@ende_uniq_numbers = @ende_uniq_numbers.where("response_body ilike '%#{params[:response_body].remove_injection}%'") if params[:response_body].present?
  
      @ende_uniq_numbers_total = @ende_uniq_numbers.count
      options = {page: params[:page] || 1, per_page: 10}
      @ende_uniq_numbers = @ende_uniq_numbers.paginate(options)
    end
  
    # GET /ende_uniq_numbers/1
    # GET /ende_uniq_numbers/1.json
    def show
    end
  
    # GET /ende_uniq_numbers/new
    def new
      @ende_uniq_number = EndeUniqNumber.new
    end
  
    # GET /ende_uniq_numbers/1/edit
    def edit
    end
  
    # POST /ende_uniq_numbers
    # POST /ende_uniq_numbers.json
    def create
      @ende_uniq_number = EndeUniqNumber.new(ende_uniq_number_params)
  
      respond_to do |format|
        if @ende_uniq_number.save
          format.html { redirect_to @ende_uniq_number, notice: 'Sequencial ENDE foi criado com sucesso.' }
          format.json { render :show, status: :created, location: @ende_uniq_number }
        else
          format.html { render :new }
          format.json { render json: @ende_uniq_number.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /ende_uniq_numbers/1
    # PATCH/PUT /ende_uniq_numbers/1.json
    def update
      respond_to do |format|
        if @ende_uniq_number.update(ende_uniq_number_params)
          format.html { redirect_to @ende_uniq_number, notice: 'Sequencial ENDE foi atualizado com sucesso.' }
          format.json { render :show, status: :ok, location: @ende_uniq_number }
        else
          format.html { render :edit }
          format.json { render json: @ende_uniq_number.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /ende_uniq_numbers/1
    # DELETE /ende_uniq_numbers/1.json
    def destroy
      @ende_uniq_number.destroy
      respond_to do |format|
        format.html { redirect_to ende_uniq_numbers_url, notice: 'Sequencial ENDE foi apagado com sucesso.' }
        format.json { head :no_content }
      end
    end
  
    private
      
      def set_ende_uniq_number
        @ende_uniq_number = EndeUniqNumber.find(params[:id])
      end
  
      # Never trust parameters from the scary internet, only allow the white list through.
      def ende_uniq_number_params
        params.require(:ende_uniq_number).permit(:id)
      end
  end
  