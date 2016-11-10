class HealthFacility < ActiveRecord::Base
  belongs_to :district

  def self.district_named district, name
    return nil if name.blank?
    where("district_id = :district_id", district_id: district.id) 
      .where("lower(name) = :name OR :name = ANY(lower(alternative_names::text)::text[])", 
        name: name.mb_chars.strip.downcase)
      .first
  end

end
