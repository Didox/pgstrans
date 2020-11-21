class GrupoUsuariosController < ApplicationController
  before_action :set_grupo_usuario
  skip_before_action :verify_authenticity_token, only: [:update]
  skip_before_action :verify_authenticity_token, only: [:update]

  def update
    if @grupo_usuario.update(grupo_usuario)
      render json: {}, status: 204
    else
      render json: @usuario.errors, status: :unprocessable_entity
    end
  end

  private
    def set_grupo_usuario
      @grupo_usuario = GrupoUsuario.find(params[:grupo_usuario_id] || params[:grupo_usuario][:id])
    end

    def grupo_usuario
      params.require(:grupo_usuario).permit(
        :id, 
        :escrita
      )
    end
end
