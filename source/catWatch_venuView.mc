import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using Toybox.ActivityMonitor as Mon;
using Toybox.Time.Gregorian as Date;

class catWatch_venuView extends WatchUi.WatchFace {


    function initialize() {
        WatchFace.initialize();
        

    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
    

    
   // dc.drawBitmap(240,240, cat100);
    	//cat50.draw(dc);
        // Get the current time and format it correctly
        var percentage = getStepsPercent();
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);
		var view;
        // Update the view
  //      if (percentage >= 25){
  //      dc.clear();
        	view = View.findDrawableById("TimeLabel") as Text;
     //s   }
 //       else { 
   //     	view = View.findDrawableById("TimeLabelMiddle") as Text;
  //      }
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(timeString);
        
        
          if (getApp().getProperty("ShowSteps")) {
        	setStepDisplay(percentage);
        	}
         if (getApp().getProperty("WhatElse") != 0) {
        	showInfo(getApp().getProperty("WhatElse"));	
        }

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
 //       clearLayers();
        
    //    var percentage = getStepsPercent();
        



       	if (percentage >= 100) {
             var cat100 = WatchUi.loadResource(Rez.Drawables.cat100);
        	 dc.drawBitmap(10,0,cat100);
        		 }
      else{ 	if (percentage >= 75 and percentage < 100) {
    				 var cat75 = WatchUi.loadResource(Rez.Drawables.cat75);
       				dc.drawBitmap(10,0,cat75);
       				}
       			if (percentage >= 50 and percentage < 75) {
   				   var cat50 = WatchUi.loadResource(Rez.Drawables.cat50);
      		 		dc.drawBitmap(10,0,cat50);
      		 		}
     		  if (percentage <50 and percentage>=25) {
      			 	var cat25 = WatchUi.loadResource(Rez.Drawables.cat25);
      		 		dc.drawBitmap(10,0,cat25);
      		 		}
      			 if (percentage <25 ){
      		 	var catEmpty = WatchUi.loadResource(Rez.Drawables.catEmpty);
      		 	dc.drawBitmap(10,0,catEmpty);
      		 	}
       		}
        

   		
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }
	
	private function getStepsPercent() {
		var percentage = (Mon.getInfo().steps*100/Mon.getInfo().stepGoal);
		return percentage;
	
	}
	
	private function setStepDisplay(percentage) {
		  var stepsFormat = "$1$";
 	      var stepNum= Mon.getInfo().steps.toString();
 	      var stepView;
 	//      if (percentage >= 25){
  	      	stepView = View.findDrawableById("StepCountDisplay");
  	////      }
  	//      else {
  	 //     	stepView = View.findDrawableById("StepCountDisplayMiddle");
  	  //    }
  	      var stepString= Lang.format(stepsFormat, [stepNum]);
  	      stepView.setColor(Application.getApp().getProperty("ForegroundColor"));
  	      stepView.setText(stepString);
	
	}
	
		private function showInfo(option) {
		var info = "";
		if (option == 1) {
			info = Lang.format("$1$ $2$", [Date.info(Time.now(), Time.FORMAT_LONG).month, Date.info(Time.now(), Time.FORMAT_SHORT).day]);
		} else if (option == 2) {
			if (Mon.getInfo() has :calories){
				info =Lang.format("$1$", [Mon.getInfo().calories.toString()]);
			} else {
				info = "--";
				}
		} else if (option == 3) {
			if (Mon has :getHeartRateHistory){
				var activity = Mon.getHeartRateHistory(null, true);
   				info = Lang.format("$1$", [activity.next().heartRate.toString()]);
			} else {
				info = "--";
				}
		} else if (option == 4) {
				if(Mon.getInfo() has :floorsClimbed) {
					info = Lang.format("$1$", [Mon.getInfo().floorsClimbed.toString()]);
				} else {
					info = "--";
				}

		}
		var infoView = View.findDrawableById("WhateverDisplay");
		infoView.setColor(Application.getApp().getProperty("ForegroundColor"));
		infoView.setText(info);
	}
	
	


}
