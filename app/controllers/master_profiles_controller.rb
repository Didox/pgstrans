class MasterProfilesController < ApplicationController
  before_action :set_master_profile, only: [:show, :edit, :update, :destroy]

  # GET /master_profiles
  # GET /master_profiles.json
  def index
    #@master_profiles = MasterProfile.all.order(description: :asc)
    @master_profiles = MasterProfile.com_acesso(usuario_logado).order(description: :asc)

    options = {page: params[:page] || 1, per_page: 10}
    @master_profiles = @master_profiles.paginate(options)
  end

  # GET /master_profiles/1
  # GET /master_profiles/1.json
  def show
  end

  # GET /master_profiles/new
  def new
    @master_profile = MasterProfile.new
  end

  # GET /master_profiles/1/edit
  def edit
  end

  # POST /master_profiles
  # POST /master_profiles.json
  def create
    @master_profile = MasterProfile.new(master_profile_params)
    @master_profile.responsavel = usuario_logado

    respond_to do |format|
      if @master_profile.save
        format.html { redirect_to @master_profile, notice: 'Master profile foi criado com sucesso.' }
        format.json { render :show, status: :created, location: @master_profile }
      else
        format.html { render :new }
        format.json { render json: @master_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /master_profiles/1
  # PATCH/PUT /master_profiles/1.json
  def update
    respond_to do |format|
      if @master_profile.update(master_profile_params)
        format.html { redirect_to @master_profile, notice: 'Master profile foi atualizado com sucesso.' }
        format.json { render :show, status: :ok, location: @master_profile }
      else
        format.html { render :edit }
        format.json { render json: @master_profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /master_profiles/1
  # DELETE /master_profiles/1.json
  def destroy
    @master_profile.destroy
    respond_to do |format|
      format.html { redirect_to master_profiles_url, notice: 'Master profile foi apagado com sucesso.' }
      format.json { head :no_content }
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_master_profile
      @master_profile = MasterProfile.find(params[:id])
      @master_profile.responsavel = usuario_logado
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def master_profile_params
      params.require(:master_profile).permit(:description)
    end
end
