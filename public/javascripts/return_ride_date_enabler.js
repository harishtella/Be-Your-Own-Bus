function return_ride_date_enabler(check_box, element_name){
  return_ride_desired = !check_box.getChecked()

  month = document.getElementById("Month_" + element_name); 
  month.setDisabled(return_ride_desired)
  day = document.getElementById("Day_" + element_name);
  day.setDisabled(return_ride_desired)
  year = document.getElementById("Year_" + element_name);
  year.setDisabled(return_ride_desired)
  min = document.getElementById("Minute_" + element_name);
  min.setDisabled(return_ride_desired)
  hour = document.getElementById("Hour_" + element_name);
  hour.setDisabled(return_ride_desired)
  ampm = document.getElementById("Ampm_" + element_name);
  ampm.setDisabled(return_ride_desired)
  
  cal = document.getElementById("StartCal" + element_name);

}
