module DateHelper extend ActiveSupport::Concern

  def is_a_date? val
    if val.is_a? Date
      return true
    end
    begin
      val.to_date
      return true
    rescue => e
      return false
    end
  end

end