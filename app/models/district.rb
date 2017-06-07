class District < ActiveRecord::Base

  has_many :health_facilities

  def self.named name
    return nil if (name.blank? || !name.is_a?(String))
    where("lower(name) = :name OR :name = ANY(lower(alternative_names::text)::text[])", 
      name: name.mb_chars.strip.downcase).first
  end  

  def is_also_named? _name
    return false if _name.blank?
    name_to_check = _name.mb_chars.strip.downcase
    thisname = name.mb_chars.strip.downcase
    thisname == name_to_check || (alternative_names || []).any? {|n| n.mb_chars.strip.downcase == name_to_check}
  end

  def dhis2_id
    "DIS#{id.to_s.rjust(8, '0')}"
  end

end
