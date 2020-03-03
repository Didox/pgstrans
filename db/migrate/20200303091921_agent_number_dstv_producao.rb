class AgentNumberDstvProducao < ActiveRecord::Migration[5.2]
  def change
  	add_column :parametros, :agent_number_dstv_desenvolvimento, :string
  	add_column :parametros, :agent_number_dstv_producao, :string
  end
end
