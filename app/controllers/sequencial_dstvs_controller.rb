class SequencialDstvsController < ApplicationController
  before_action :set_sequencial_dstv, only: [:show, :edit, :update, :destroy]

  # GET /sequencial_dstvs
  # GET /sequencial_dstvs.json
  def index
    @sequencial_dstvs = SequencialDstv.all
  end

  # GET /sequencial_dstvs/1
  # GET /sequencial_dstvs/1.json
  def show
  end

  # GET /sequencial_dstvs/new
  def new
    @sequencial_dstv = SequencialDstv.new
  end

  # GET /sequencial_dstvs/1/edit
  def edit
  end

  # POST /sequencial_dstvs
  # POST /sequencial_dstvs.json
  def create
    @sequencial_dstv = SequencialDstv.new(sequencial_dstv_params)

    respond_to do |format|
      if @sequencial_dstv.save
        format.html { redirect_to @sequencial_dstv, notice: 'Sequencial dstv was successfully created.' }
        format.json { render :show, status: :created, location: @sequencial_dstv }
      else
        format.html { render :new }
        format.json { render json: @sequencial_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sequencial_dstvs/1
  # PATCH/PUT /sequencial_dstvs/1.json
  def update
    respond_to do |format|
      if @sequencial_dstv.update(sequencial_dstv_params)
        format.html { redirect_to @sequencial_dstv, notice: 'Sequencial dstv was successfully updated.' }
        format.json { render :show, status: :ok, location: @sequencial_dstv }
      else
        format.html { render :edit }
        format.json { render json: @sequencial_dstv.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sequencial_dstvs/1
  # DELETE /sequencial_dstvs/1.json
  def destroy
    @sequencial_dstv.destroy
    respond_to do |format|
      format.html { redirect_to sequencial_dstvs_url, notice: 'Sequencial dstv was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sequencial_dstv
      @sequencial_dstv = SequencialDstv.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def sequencial_dstv_params
      params.require(:sequencial_dstv).permit(:numero)
    end
end
