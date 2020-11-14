module PermissionamentoDados
  def self.included(base)
    base.class_eval do 
      attr_accessor :responsavel
      
      validate :verifica_responsavel
      after_validation :salvar_responsavel

      def self.com_acesso(usuario)
        if(usuario.admin? || usuario.operador?)
          self.all
        else
          sql_where = ""
          if self.new.respond_to?(:usuario_id)
            sql_where = "(#{self.to_s.underscore.pluralize}.usuario_id = #{usuario.id}) or "
          end
          sql_where += "
            (
              #{self.to_s.underscore.pluralize}.id in (
                select grupo_registros.modelo_id from grupo_registros
                where grupo_registros.modelo = '#{self.to_s}' and 
                  grupo_registros.modelo_id = #{self.to_s.underscore.pluralize}.id and 
                  grupo_registros.grupo_id in (#{usuario.grupos_id.join(",")})
              )
            )
          "
          self.where(sql_where)
        end
      end

      def salva_responsavel(_responsavel)
        self.responsavel = _responsavel
        self.save
      end

      private 
        def verifica_responsavel
          self.errors.add(:responsavel, "Responsável não definido") if self.responsavel.blank?
        end

        def salvar_responsavel
          raise "Responsável não definido" if self.responsavel.blank?

          return if self.responsavel.admin? || self.responsavel.operador?
          
          responsavel.grupo_usuarios.each do |gu|
            if gu.escrita
              grs = GrupoRegistro.where(grupo_id: gu.grupo_id, modelo: self.class.to_s, modelo_id: self.id)
              if grs.count == 0
                GrupoRegistro.create(grupo_id: gu.grupo_id, modelo: self.class.to_s, modelo_id: self.id, created_at: self.created_at, updated_at: self.updated_at)
              end
            end
          end
        end
    end
  end
end