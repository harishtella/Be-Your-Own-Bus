# Methods added to this helper will be available to all templates in the application.
require 'generator'
require 'date'

module ApplicationHelper
  def gen_month_options(cur_month)
    month_names = Date::ABBR_MONTHNAMES[1,12]
    month_options = ""

    SyncEnumerator.new( (1..12), month_names).each do |option|
      month_options += "<option value=\"#{option[0]}\"" 
      month_options += if (option[0] == cur_month) then " selected " else "" end 
      month_options += "> #{option[1]}</option>"
    end  
  end

end
