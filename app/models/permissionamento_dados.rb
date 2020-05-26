module PermissionamentoDados
  def self.included(base)
    base.class_eval do 
      attr_accessor :responsavel
      
      validate :verifica_responsavel
      after_validation :salvar_responsavel

      def self.com_acesso(usuario)
        if(usuario.admin || usuario.operador)
          self.all
        else
          self.joins("
          inner join grupo_registros on 
            grupo_registros.modelo = '#{self.to_s}' and 
            grupo_registros.modelo_id = #{self.to_s.underscore.pluralize}.id and 
            grupo_registros.grupo_id in (#{usuario.grupos_id.join(",")}) 
          ").distinct
        end
      end

      def salva_responsavel(_responsavel)
        self.responsavel = _responsavel
        self.save
      end

      private 
        def verifica_responsavel
          return if usuario.admin || usuario.operador
          self.errors.add(:responsavel, "Responsável não definido") if responsavel.blank?
        end

        def salvar_responsavel
          return if usuario.admin || usuario.operador

          raise "Responsável não definido" if responsavel.blank?
          
          responsavel.grupo_usuarios.each do |gu|
            if gu.escrita
              grs = GrupoRegistro.where(grupo_id: gu.grupo_id, modelo: self.class.to_s, modelo_id: self.id)
              GrupoRegistro.create(grupo_id: gu.grupo_id, modelo: self.class.to_s, modelo_id: self.id) if grs.count == 0
            end
          end
        end
    end
  end
end