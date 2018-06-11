desc 'Import a monthly malaria workbook file into the system'

namespace :import do

  task :workbook_file_dir, [:path, :user_id] => :environment do |task, args|
    if args.path.blank? || !File.directory?(args.path)
      puts "Path to valid directory is required"
      next
    end
    if args.user_id.blank?
      puts "User ID is required"
      next
    end
    user = User.find args.user_id.to_i
    Dir.entries(args.path).select{ |p| p =~ /\.xls[x]*/ }.each do |filename|
      import_workbook_file File.join(args.path, filename), user
    end
  end

  task :workbook_file, [:path, :user_id, :year, :month, :district_id] => :environment do |task, args|
    if args.path.blank? || !File.file?(args.path)
      puts "Path to valid file is required"
      next
    end
    if args.user_id.blank?
      puts "User ID is required"
      next
    end
    overrides = nil
    if args.year || args.month || args.district_id
      overrides = {}
      overrides['reporting_year'] = args.year.to_i unless args.year.blank?
      overrides['reporting_month'] = args.month.to_i unless args.month.blank?
      overrides['district_id'] = args.district_id.to_i unless args.district_id.blank?
    end
    user = User.find args.user_id.to_i
    import_workbook_file args.path, user, overrides
  end 

end

def import_workbook_file path, user, overrides={}
  puts "======================================="
  puts "Importing workbook at '#{path}'"

  workbook_file = WorkbookFile.create user: user, status: 'uploading', 
    uploaded_at: DateTime.now
  unless overrides.blank?
    puts "Using overrides: #{overrides}"
    workbook_file.update_attribute :import_overrides, overrides
  end

  workbook_file.direct_workbook_upload path
  puts "Uploaded workbook to #{workbook_file.workbook_file_bucket_path}"

  workbook_file.validate!
  if workbook_file.status == 'error'
    puts "Error validating file, status is error:"
    puts JSON.pretty_generate(workbook_file.import_errors)
    return
  end

  unless workbook_file.validation_errors['errors'].blank?
    puts "Workbook errors:"
    puts JSON.pretty_generate(workbook_file.validation_errors['errors'])

    cli_overrides = {}.merge(overrides || {})
    if errors_has_district_missing? workbook_file.validation_errors['errors']
      cli_overrides.merge! ask_for_district_override(workbook_file)
    end

    # Revalidate once to populate date if missing
    unless cli_overrides.empty?
      workbook_file.update_attribute :import_overrides, cli_overrides
      workbook_file.validate!
    end

    # Ask for date if missing
    if errors_has_workbook_date_missing? workbook_file.validation_errors['errors']
      cli_overrides.merge! ask_for_date_override(workbook_file)
    end

    # Revalidate once to populate district if missing
    unless cli_overrides.empty?
      workbook_file.update_attribute :import_overrides, cli_overrides
      workbook_file.validate!
    end

    # Ask for facilities if unknown
    unknown_facilities = errors_unknown_facility workbook_file.validation_errors['errors']
    if !unknown_facilities.empty?
      health_facility_overrides = {}
      unknown_facilities.each do |uf|
        health_facility_overrides.merge! ask_for_health_center_override(workbook_file, uf)
      end
      unless health_facility_overrides.empty?
        cli_overrides["health_facilities"] = health_facility_overrides
      end
    end

    unless cli_overrides.empty?
      workbook_file.update_attribute :import_overrides, cli_overrides
      workbook_file.validate!
      unless workbook_file.validation_errors['errors'].blank?
        puts "Workbook errors:"
        puts JSON.pretty_generate(workbook_file.validation_errors['errors'])
        return
      end
    else
      return
    end
  end
  unless workbook_file.validation_errors['warnings'].blank?
    puts "Workbook warnings:"
    puts JSON.pretty_generate(workbook_file.validation_errors['warnings'])
  end


  puts %(
  Workbook file reports for:
    District: #{workbook_file.workbook.district.name}
    Month: #{workbook_file.workbook.reporting_month}
    Year: #{workbook_file.workbook.reporting_year}
    =====
    Proceed with import? (y|n))
  input = STDIN.gets.chomp
  if input.strip.downcase != 'y'
    puts "Not importing workbook"
    return
  end
  
  workbook_file.import!

  if workbook_file.status == 'error'
    puts "Error importing file, status is error:"
    puts JSON.pretty_generate(workbook_file.import_errors)
    return
  end
  puts "Imported reports for workbook"

  workbook_file.activate!
  puts "Activated workbook for #{workbook_file.workbook.district.name}: #{workbook_file.workbook.reporting_year}/#{workbook_file.workbook.reporting_month}"

end

def ask_for_date_override workbook_file
  puts "Invalid date for workbook, would you like to specify an import date? (y|n)"
  input = STDIN.gets.chomp
  return {} if input.strip.downcase != 'y'

  month = 0
  while (month < 1 || month > 12)
    puts "Please enter the month of the year (1-12)"
    month = STDIN.gets.chomp.to_i
  end

  year = 0
  while (year < 1)
    puts "Please enter the year (YYYY)"
    year = STDIN.gets.chomp.to_i
  end

  return {
    'reporting_month' => month,
    'reporting_year' => year
  }
end

def ask_for_district_override workbook_file
  puts "Invalid district information for workbook, would you like to specify one? (y|n)"
  input = STDIN.gets.chomp
  return {} if input.strip.downcase != 'y'

  District.order('name asc').each do |district|
    puts "  #{district.id}) #{district.name}"
  end
  puts "Use district id: "

  id = STDIN.gets.chomp.to_i
  return {
    'district_id' => id
  }
end

def ask_for_health_center_override workbook_file, error
  facility_name = error['values']['facility_name']
  sheet_name = error['values']['sheet_name']
  puts "Unknown facility '#{facility_name}' on sheet '#{sheet_name}'.  Would you like to specify the facility or ignore the sheet (y|n|i)?"
  input = STDIN.gets.chomp
  return {} unless %w(y i).include?(input.strip.downcase)

  if input.strip.downcase == 'i'
    return {sheet_name => 'ignore'}
  end

  if workbook_file.workbook.district.nil?
    puts "Workbook must have a valid district specfied to specify a health facility"
    return {}
  end

  HealthFacility.where(district: workbook_file.workbook.district)
      .where(end_date: nil)
      .order("name asc").each do |health_facility|
    puts "  #{health_facility.id}) #{health_facility.name}"
  end
  puts "  new) Create a new facility"

  id = STDIN.gets.chomp
  if (id.strip.downcase == 'new')
    puts "What is the name of the new facility?"
    name = STDIN.gets.chomp.strip
    hf = HealthFacility.create name: name, district: workbook_file.workbook.district
    return {sheet_name => hf.id}
  else 
    hf = HealthFacility.where(id: id.to_i).first
    if hf
      return {sheet_name => hf.id}
    end
  end
  return {}
end

def errors_has_district_missing? errors
  errors.any?{ |err| %(unknown_district district_not_same).include? err["code"] }
end

def errors_has_workbook_date_missing? errors 
  errors.any?{ |err| %(invalid_workbook_month).include? err["code"] }
end

def errors_unknown_facility errors
  errors.select{ |err| err["code"] == "unknown_facility" }
end
