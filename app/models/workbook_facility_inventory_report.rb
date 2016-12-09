class WorkbookFacilityInventoryReport < ActiveRecord::Base
  belongs_to :workbook_facility_monthly_report

  PRODUCTS = [
    :rdt,
    :asaq_infant,
    :asaq_small_child,
    :asaq_child,
    :asaq_adult,
    :sp,
    :artesunate_inj,
    :artemether_inj,
    :quinine_inj,
    :quinine_caps,
    :milda,
  ]

  AL_PRODUCTS = [
    :al
  ]

  AL_PRODUCTS_AGES = [
    :al_infant,
    :al_small_child,
    :al_child,
    :al_adult
  ]

  ROW_MAPPING = {
    rdt: 34,
    asaq_infant: 35,
    asaq_small_child: 36,
    asaq_child: 37,
    asaq_adult: 38,
    al: 39,
    al_infant: 39,
    al_small_child: 40,
    al_child: 41,
    al_adult: 42,
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

  def self.sheet_products sheet
    # If cell B39 has a number, the AL products have ages
    if sheet.cell('B', 39) =~ /\d/
      return PRODUCTS + AL_PRODUCTS_AGES
    else
      return PRODUCTS + AL_PRODUCTS
    end
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
