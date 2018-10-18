
namespace :export do

  task :orgs => :environment do |task, args|
    elements = []
    District.all.each do |district|
      elements << district_to_json(district)
      district.health_facilities.each do |facility|
        elements << facility_to_json(facility)
      end
    end
    puts({"organisationUnits": elements}.to_json)
  end

  task :values => :environment do
    elements = []
    FacilityMonthlyReport.all.each do |report|
      elements += report.dhis2_elements
    end
    puts({"dataValues": elements}.to_json)
  end

  task :values_suspect_severe_female => :environment do 
    elements = []
    FacilityMalariaGroupReport.all.each do |report|
      elements += report.suspect_severe_female_elements
    end
    puts({"dataValues": elements}.to_json)
  end

  task :values_since, [:date] => :environment do |task, args|
    date = Date.parse args.date
    elements = []
    FacilityMonthlyReport.where('created_at > ?', date).each do |report|
      elements += report.dhis2_elements
    end
    puts({"dataValues": elements}.to_json)
  end

  task :reporting_period, [:month, :year] => :environment do |task, args|
    elements = []
    FacilityMonthlyReport.joins(:workbook_file => :workbook).where(workbooks: { reporting_month: args.month, reporting_year: args.year }).each do |report|
      elements += report.dhis2_elements
    end
    puts({"dataValues": elements}.to_json)
  end


  task :population => :environment do
    elements = []
    FacilityMonthlyReport.all.each do |report|
      
      elements += report.dhis2_report_pop_elements
    end
    puts({"dataValues": elements}.to_json)
  end

  task :complete_datasets => :environment do
    elements = []
    FacilityMonthlyReport.all.each do |report|
      
      elements += report.dhis2_complete_datasets
    end
    puts({"completeDataSetRegistrations": elements}.to_json)
  end


  task :report_value, [:report_id] => :environment do |task, args|
    elements = []
    FacilityMonthlyReport.where('id = ?', args.report_id).each do |report|
      elements += report.dhis2_elements
    end
    puts({"dataValues": elements}.to_json)
  end

  def district_to_json district
    {
      "name": district.name,
      "id": district.dhis2_id,
      "shortName": district.name.downcase.gsub(/\s+/, ""),
      "featureType": "NONE",
      "openingDate": "2000-01-01T00:00:00.000",
      "parent": {
        "id": "AKk54WaURz5"
      },
      "attributeValues": [],
      "translations": []
    }
  end

  def facility_to_json facility
    {
      "name": facility.name,
      "id": facility.dhis2_id,
      "shortName": facility.name.downcase.gsub(/\s+/, ""),
      "featureType": "NONE",
      "openingDate": "2000-01-01T00:00:00.000",
      "parent": {
        "id": facility.district.dhis2_id
      },
      "attributeValues": [],
      "translations": []
    }
  end

end