class HealthFacility < ActiveRecord::Base
  belongs_to :district

  def self.district_named district, name
    where("district_id = :district_id", district_id: district.id) 
      .where("lower(name) = :name OR :name = ANY(lower(alternative_names::text)::text[])", 
        name: name.strip.downcase)
      .first
  end

end
