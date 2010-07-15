# Methods added to this helper will be available to all templates in the application.
require 'date'

module ApplicationHelper
  def gen_month_options(cur_month)
    month_names = Date::ABBR_MONTHNAMES[1,12]
    month_options = ""
    month_numbers = (1..12).to_a.reverse

    month_names.each do |mname|
      mnum = month_numbers.pop
      month_options += "<option value=\"#{mnum}\"" 
      month_options += if (mnum == cur_month) then " selected " else "" end 
      month_options += "> #{mname}</option>"
    end  
  end

end
