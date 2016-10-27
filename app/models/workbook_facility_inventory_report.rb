class WorkbookFacilityInventoryReport < ActiveRecord::Base
  belongs_to :workbook_facility_monthly_report

  PRODUCTS = [
    :rdt,
    :asaq_infant,
    :asaq_small_child,
    :asaq_child,
    :asaq_adult,
    :al,
    :sp,
    :artesunate_inj,
    :artemether_inj,
    :quinine_inj,
    :quinine_caps,
    :milda,
  ]

  ROW_MAPPING = {
    rdt: 34,
    asaq_infant: 35,
    asaq_small_child: 36,
    asaq_child: 37,
    asaq_adult: 38,
    al: 39,
    sp: 40,
    artesunate_inj: 41,
    artemether_inj: 42,
    quinine_inj: 43,
    quinine_caps: 44,
    milda: 45,
  }

  def self.report_for report, product
    props = {workbook_facility_monthly_report: report, product: product}
    where(props).first || WorkbookFacilityInventoryReport.new(props)
  end

  def apply_sheet! sheet
    row = ROW_MAPPING[product.to_sym]

    self.stock_month_start      = sheet.cell('E', row)
    self.stock_month_received   = sheet.cell('G', row)
    self.num_delivered_to_ac    = sheet.cell('I', row)
    self.num_delivered_to_ps    = sheet.cell('K', row)
    self.num_used               = sheet.cell('M', row)
    self.num_lost               = sheet.cell('O', row)
    self.num_close_to_expire    = sheet.cell('S', row)
    self.num_days_out_of_stock  = sheet.cell('U', row)

    self.save!
  end

end
