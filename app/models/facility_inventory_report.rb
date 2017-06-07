class FacilityInventoryReport < ActiveRecord::Base

  self.primary_key = 'id'
  
  belongs_to :facility_monthly_report, 
    foreign_key: 'workbook_facility_monthly_report_id', 
    class_name: 'FacilityMonthlyReport'

  ELEMENT_DHIS2_MAPPING = {
    stock_month_start: 'PZUz6ocp5GK',
    stock_month_received: 'EhVedNmo383',
    num_delivered_to_ac: 'zcUTCzF6dCU',
    num_delivered_to_ps: 'mol8g7y99qT',
    num_used: 'RZsiq7yEwi0',
    num_lost: 'qMnzlzUqRWn',
    num_close_to_expire: 'iaflmUEkS4K',
    num_days_out_of_stock: 'dOQ1lQ3kSzG'
  }

  PRODUCTS_DHIS2_MAPPING = {
    rdt: 'jkpF4jTRSxU',
    asaq_infant: 'g7ZZUOZ354p',
    asaq_small_child: 'Bcvni3XrBhx',
    asaq_child: 'dfVl7IUKfwc',
    asaq_adult: 'hnogp8uZxRx',
    al: 'HoqUfLn8u8j',
    al_infant: 'MXf2VNO8VMS',
    al_small_child: 'D7vUeWAYnIa',
    al_child: 'dpJBMMA8YYP',
    al_adult: 'fGCihiR55XB',
    sp: 'Flp0KaIaSiV',
    artesunate_inj: 'bo5gcVuS9Lq',
    artemether_inj: 'TUveYYmYvPq',
    quinine_inj: 'gpgzxsuBR0D',
    quinine_caps: 'Savyh70RrQb',
    milda: 'vkQBzTH7WDc'
  }

  def dhis2_elements
    [
      to_dhis2_element(:stock_month_start, self.stock_month_start),
      to_dhis2_element(:stock_month_received, self.stock_month_received),
      to_dhis2_element(:num_delivered_to_ac, self.num_delivered_to_ac),
      to_dhis2_element(:num_delivered_to_ps, self.num_delivered_to_ps),
      to_dhis2_element(:num_used, self.num_used),
      to_dhis2_element(:num_lost, self.num_lost),
      to_dhis2_element(:num_close_to_expire, self.num_close_to_expire),
      to_dhis2_element(:num_days_out_of_stock, self.num_days_out_of_stock)
    ]
  end

  def to_dhis2_element field, value
    {
      dataElement: ELEMENT_DHIS2_MAPPING[field.to_sym],
      period: facility_monthly_report.workbook_file.workbook.dhis2_period,
      orgUnit: facility_monthly_report.health_facility.dhis2_id,
      categoryOptionCombo: PRODUCTS_DHIS2_MAPPING[product.to_sym],
      attributeOptionCombo: "HllvX50cXC0",
      value: value,
      followUp: false
    }
  end

end
