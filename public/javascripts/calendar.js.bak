/**
 * 	Code based on example posted on http://forum.developers.facebook.com/viewtopic.php?id=7002
 * 	improved by Miha Trtnik @ http://www.webeks.net	 
 */

function startCal(init) {

	/* see if we have a calendar object already and if so return it */
	if(typeof startCal.Calendar != 'undefined') {
		return startCal.Calendar;
	}

	var Calendar = document.getElementById("divCalender");

	Calendar.initialize = function(){

		Calendar.mNames = [ "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep",  "Oct", "Nov", "Dec"];

		Calendar.dNames = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

		Calendar.title = document.getElementById("CanlendarTitle");
		Calendar.todaytitle = document.getElementById("TodayTitle");

		Calendar.currentDate = new Date();
		Calendar.todaytitle.setTextValue('Today: ' + Calendar.dNames[Calendar.currentDate.getDay()] + ' ' + Calendar.currentDate.getDate() + ' ' + Calendar.mNames[Calendar.currentDate.getMonth()] + ' ' + Calendar.currentDate.getFullYear());

		Calendar.visible = false;
		Calendar.x = 0;
		Calendar.y = 0;

		document.getRootElement().addEventListener('mouseover',Calendar.isOutOfRange);

		for(var i=1;i<43;i++){
			document.getElementById('day_'+i).addEventListener('click',Calendar.dateSelected);
			document.getElementById('day_'+i).addEventListener('mouseover',Calendar.onMouseOver);
			document.getElementById('day_'+i).addEventListener('mouseout',Calendar.onMouseOut);
		}

		document.getElementById('prevMonth').addEventListener('click',Calendar.datePrevMonth);
		document.getElementById('prevYear').addEventListener('click',Calendar.datePrevYear);
		document.getElementById('nextMonth').addEventListener('click',Calendar.dateNextMonth);
		document.getElementById('nextYear').addEventListener('click',Calendar.dateNextYear);
	}

	Calendar.datePrevMonth = function(){
		var prevDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
		prevDate.setMonth( prevDate.getMonth() - 1);
		Calendar.setDate(prevDate);
	}

	Calendar.datePrevYear = function(){
		var prevDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
		prevDate.setFullYear( prevDate.getFullYear() - 1);
		Calendar.setDate(prevDate);    
	}

	Calendar.dateNextMonth = function(){
		var nextDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
		nextDate.setMonth( nextDate.getMonth() + 1);
		Calendar.setDate(nextDate);    
	}

	Calendar.dateNextYear = function(){
		var nextDate = new Date(Calendar.currentDate.getFullYear(),Calendar.currentDate.getMonth(),Calendar.currentDate.getDate());
		nextDate.setFullYear( nextDate.getFullYear() + 1);
		Calendar.setDate(nextDate);    
	}

	Calendar.isOutOfRange = function(evt){
		if(Calendar.visible == false) return true;
		var root = document.getRootElement();



		var cursorX = evt.pageX - root.getAbsoluteLeft();
		var cursorY = evt.pageY - root.getAbsoluteTop();

		var basePointX = Calendar.target.getAbsoluteLeft() - root.getAbsoluteLeft();
		var basePointY = Calendar.target.getAbsoluteTop() - root.getAbsoluteTop();

		var secondPointX = basePointX + Calendar.target.getClientWidth() + Calendar.getClientWidth() + 50;
		var secondPointY = basePointY + Calendar.target.getClientHeight() + Calendar.getClientHeight() + 50;        

		if((cursorX > basePointX && cursorX < secondPointX) && (cursorY > basePointY && cursorY < secondPointY)){
			return false;
		}

		Calendar.hide();
		return true;
	}
		
		/**
		 * shows calendar
		 * @param trgt - element where we want calendar to show
		 * @param idref - prefix of select elements (dobYear) idref = dob
		 * @param cDivId - id of the div containing calendar (theme) 
		 */
		Calendar.show = function(trgt,idref,cDivId){

		Calendar.target = trgt;
		Calendar.preid = idref;
		
		cDiv = document.getElementById(cDivId);
		var root = document.getRootElement();

		/** calculate position of the calendar **/
		if(trgt){
			if(cDiv)
			{
				Calendar.x = trgt.getAbsoluteLeft() - cDiv.getParentNode().getAbsoluteLeft();
				Calendar.y = trgt.getAbsoluteTop() - cDiv.getParentNode().getAbsoluteTop();
				Calendar.setStyle('top',(trgt.getAbsoluteTop() - cDiv.getParentNode().getAbsoluteTop())+"px");
				Calendar.setStyle('left',(trgt.getAbsoluteLeft() - cDiv.getParentNode().getAbsoluteLeft())+"px");
			} else {
				Calendar.x = trgt.getAbsoluteLeft() - root.getAbsoluteLeft() + trgt.getClientWidth();
				Calendar.y = trgt.getAbsoluteTop() - root.getAbsoluteTop() + trgt.getClientHeight();
				Calendar.setStyle('top',(trgt.getAbsoluteTop() - root.getAbsoluteTop() + trgt.getClientHeight())+"px");
				Calendar.setStyle('left',(trgt.getAbsoluteLeft() - root.getAbsoluteLeft() + trgt.getClientWidth())+"px");
			}
			//var dlg = new Dialog();            
            //dlg.showMessage('Message',trgt.getAbsoluteTop()+".."+cDiv.getAbsoluteTop()+"..."+cDiv.getParentNode().getAbsoluteTop());
		}

        Calendar.setDate(new Date(parseInt(document.getElementById('Year_' + Calendar.preid).getValue()), parseInt(document.getElementById('Month_' + Calendar.preid).getValue()) - 1, parseInt(document.getElementById('Day_' + Calendar.preid).getValue())))

		Calendar.setStyle("display","");
		Calendar.visible = true;
	}

	Calendar.hide = function(){
		Calendar.target = null;
		Calendar.setStyle("display","none");
		Calendar.visible = false;
	}

	Calendar.dateSelected = function(evt){
		if(Calendar.target){
			var value = evt.target.getValue();            

			if(Calendar.OnDateSelected){
				Calendar.OnDateSelected(Calendar.target,value);
			}

		}
		Calendar.hide();
	}
	Calendar.onMouseOver = function(evt){
		evt.target.setClassName('fb_calendar_day_hover');
	}
	Calendar.onMouseOut = function(evt){
		evt.target.setClassName(evt.target.className);
	}

	Calendar.setDate = function (someDate){

		var baseDate = new Date(someDate.getFullYear(),someDate.getMonth(),1);
		var date_index = baseDate.getDay();                

		baseDate.setDate( - date_index + 1);
		Calendar.currentDate = new Date(someDate.getFullYear(),someDate.getMonth(),someDate.getDate());

		Calendar.title.setTextValue(Calendar.mNames[Calendar.currentDate.getMonth()] + " - " + Calendar.currentDate.getFullYear());


		var divDay;
		var i = 1;
		for(i;i<43;i++){
			divDay = document.getElementById("day_"+i);            
			if(divDay){
				divDay.setTextValue(baseDate.getDate());
				divDay.setValue(new Date(baseDate.getFullYear(),baseDate.getMonth(),baseDate.getDate()));

				if(baseDate.getMonth() == someDate.getMonth()){
					divDay.className = "fb_calendar_day";
				}else{
					divDay.className = "fb_calendar_day_diff_month";                    
				}
				divDay.setClassName(divDay.className);
			}
			baseDate.setDate(baseDate.getDate() + 1);
		}


	}

    Calendar.OnDateSelected = function(sender,date){    

		var argCount = document.getElementById('Year_' + Calendar.preid).getChildNodes().length;
		var sortedOptions = document.getElementById('Year_' + Calendar.preid).getChildNodes();
		sortedOptions = sortedOptions.sort();
		var debugStr = '';

		var addOption = true;

		/* check current available options in select list */        
		for(a=0;a<argCount;a++) {
			if(sortedOptions[a].getValue() == date.getFullYear()) {
				addOption = false;
				a = argCount;
			}
			// debugStr = debugStr + ',' + sortedOptions[a].getValue() + ' == ' + date.getFullYear();
		}

		//var dlg = new Dialog();            
		//dlg.showMessage('Debug OnDateSelected()', 'Debug: ' + debugStr + ' answer: ' + addOption);

		/* if we need to add the option to the select list */                
		if(addOption == true) {

			var yearSelect = document.getElementById('Year_' + Calendar.preid).getChildNodes().sort();

			var opt = document.createElement('option');
			opt.setId('yr'+date.getFullYear());
			opt.setTextValue(date.getFullYear());
			opt.setValue(date.getFullYear());

			/* if the lowest yr option value is greater than selected year */                    
			if(yearSelect[0].getValue() > date.getFullYear() && yearSelect[1].getValue() > yearSelect[0].getValue()) {

				/* we insertBefore() the missing option so it's at the top of list */      
				document.getElementById('Year_' + Calendar.preid).insertBefore(opt,document.getElementById('Year_' + Calendar.preid).getChildNodes()[0]);

			} else if(yearSelect[0].getValue() < date.getFullYear() && yearSelect[1].getValue() > yearSelect[0].getValue()) {

				/* otherwise we append the missing yr option to the end of the list */                          
				document.getElementById('Year_' + Calendar.preid).appendChild(opt);

			} else if(yearSelect[0].getValue() > date.getFullYear() && yearSelect[1].getValue() < yearSelect[0].getValue()) {

				/* otherwise we append the missing yr option to the end of the list */                          
				document.getElementById('Year_' + Calendar.preid).appendChild(opt);            

			} else {

				/* we insertBefore() the missing option so it's at the top of list */      
				document.getElementById('Year_' + Calendar.preid).insertBefore(opt,document.getElementById('Year_' + Calendar.preid).getChildNodes()[0]);

			}

		}

		/* set the list options to the chosen date */
		document.getElementById('Year_' + Calendar.preid).setValue("" + date.getFullYear());
		document.getElementById('Day_' + Calendar.preid).setValue("" + date.getDate());
		document.getElementById('Month_' + Calendar.preid).setValue("" + (date.getMonth() + 1));

		/** set the hidden field **/
		setDateTime(Calendar.preid);
		/** update days count **/
		setDaysValue(Calendar.preid);
		/*
        var dlg = new Dialog();            
                dlg.showMessage('Message',sender.getId() + " is selected : " + date.getFullYear() + ' / ' + (date.getMonth() + 1) + ' / ' + date.getDate());
		 */

	}

	if(init == true) {
		/* run initialize function */
		Calendar.initialize();
	}

	startCal.Calendar = Calendar;

	/* return calendar object */
	return startCal.Calendar;
}   


function setDateTime(preId)
{
	var year 	= document.getElementById('Year_' + preId).getValue();
	var month 	= document.getElementById('Month_' + preId).getValue();
	var day		= document.getElementById('Day_' + preId).getValue();

	if(document.getElementById('Hour_' + preId)) {
		var hour	= document.getElementById('Hour_' + preId).getValue();
        var ampm    = document.getElementById('Ampm_' + preId).getValue();
        if (ampm == "pm") { 
          hour_int = parseInt(hour) + 12;
          hour = hour_int.toString();
        }
	} else {
		var hour = "00";
	}

	if(document.getElementById('Minute_' + preId)) {
		var minute	= document.getElementById('Minute_' + preId).getValue();
	} else {
		var minute	= "00";
	}
			
	
	
	//format day into 2 stringformat 
	if(day < 10) {
		day = "0"+day;
	}
	if(month < 10) {
		month = "0"+month;
	}
		
	var dateTime = year+"-"+month+"-"+day+" "+hour+":"+minute+":00";

	document.getElementById(preId).setValue(dateTime);
}




/**
 * number of days in the month varies so we have to dynamicaly adjust number of days in select
 */
function setDaysValue(preId)
{
	var year 	= document.getElementById('Year_' + preId).getValue();
	var month 	= document.getElementById('Month_' + preId).getValue();
	var day		= document.getElementById('Day_' + preId).getValue();
	
	var numDays 	= 32 - new Date(year, month-1, 32).getDate();
	var dayField 	= document.getElementById('Day_' + preId);
	var currDays 	= document.getElementById('Day_' + preId).getChildNodes().length;
	
	if(numDays>currDays)
	{
		var diff = numDays-currDays;
		for(i=1; i<diff+1; i++) {
			var newOpt = document.createElement("option");
			newOpt.setValue(currDays+i);
			newOpt.setTextValue(currDays+i);
			document.getElementById('Day_' + preId).appendChild(newOpt);
		} 
	} else if(numDays<currDays)
	{
		var diff = currDays-numDays;
		for(i=0; i<diff; i++)
		{
			var indexToRemove = document.getElementById('Day_' + preId).getChildNodes().length -1;
			var nodeToRemove = document.getElementById('Day_' + preId).getOptions()[indexToRemove];
			document.getElementById('Day_' + preId).removeChild(nodeToRemove);
		}
	}
}

