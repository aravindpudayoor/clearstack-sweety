class GlucoseLevel < ApplicationRecord
  belongs_to :user

  ## DAILY_LIMIT will take care of the maxium allowed glucose reading per day
  DAILY_LIMIT = 4

  ## validations
  validates :value, presence: true

  ## This class method will filter the data based on the report user selected
  ## If user not selected any report type all data will be displayed

  def self.search_and_order(end_dt, report)
    unless report.blank?
    	case report
    	when "daily"
    		start_date = Date.today.beginning_of_day 
    		end_date = Date.today.end_of_day
      when "month_to_date"
      	start_date = Date.today.beginning_of_month 
        end_date =  Date.parse(end_dt.to_date.to_s).end_of_day
      when "monthly"
      	start_date = (Date.today - 30.days).beginning_of_day
      	end_date = Date.today.end_of_day
      end
      where("DATE(created_at) >= ? AND DATE(created_at) <= ?", start_date, end_date).order(created_at: :desc)
    else
      order(created_at: :desc)
    end
  end
end
