class GlucoseLevel < ApplicationRecord
  belongs_to :user

  ## Callback to validate there is no more than 4 entries per day.
  before_validation :check_daily_limit
  
  ## DAILY_LIMIT will take care of the maxium allowed glucose reading per day
  DAILY_LIMIT = 4

  ## Scope to 
  scope :of_date, -> (date) { where("DATE(created_at) = ?", date)}

  ## validations
  validates :value, presence: true, numericality: {less_than_or_equal_to: 200, greater_than_or_equal_to: 50}
  
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

  ## Below action make will sure before validation that there are no more than specified(here 4) entries on a given day.
  def check_daily_limit
    # unless self.user.glucose_levels.of_date(Date.today).count < GlucoseLevel::DAILY_LIMIT
    unless GlucoseLevel.where(user: self.user).of_date(Date.today).count < GlucoseLevel::DAILY_LIMIT
      self.errors.add(:value, "Daily limit exeeds, You cannot create a new entry today")
    end
  end
end
