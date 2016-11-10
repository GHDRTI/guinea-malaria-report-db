module Validatable extend ActiveSupport::Concern

  CODE_MESSAGES = {
    unknown_district: "Unknown district '$district_name'",
    unknown_facility: "Unknown facility '$facility_name' in district '$district_name'",
    invalid_workbook_month: "Invalid workbook month & year from '$date', must be date type and not empty",
    district_not_same: "Workbook first reportable sheet specified district '$workbook_district_name', but sheet $sheet_name specified district '$sheet_district_name'",
    invalid_date_sheet: "Invalid date '$date' in sheet '$sheet_name'" 
  }

  def t_err code, args
    message_text = CODE_MESSAGES[code]
    raise "Unknown error code '#{code}'" if message_text.nil?
    args.each{ |k,v| message_text = message_text.gsub("$#{k}", "#{v}") }
    r = {
      code: code,
      values: args,
      message: message_text
    }
  end

end