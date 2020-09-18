VERSION="v2"

String.class_eval do
  def to_f_ptBR
    return self.to_f unless self.include?(",")
    self.gsub(".", "").gsub("R$", "").gsub(",", ".").to_f
  end
end