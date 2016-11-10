class District < ActiveRecord::Base

  def self.named name
    where("lower(name) = :name OR :name = ANY(lower(alternative_names::text)::text[])", 
      name: name.mb_chars.strip.downcase).first
  end  

  def is_also_named? _name
    return false if _name.blank?
    name_to_check = _name.mb_chars.strip.downcase
    thisname = name.mb_chars.strip.downcase
    thisname == name_to_check || (alternative_names || []).any? {|n| n.mb_chars.strip.downcase == name_to_check}
  end

end
