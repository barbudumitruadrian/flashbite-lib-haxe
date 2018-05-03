package flashbite.helpers;

/**
 * Date helpers
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersDate 
{
	private function new() {}
	
	/**
	 * Parse a string to a date;
	 * is using Date.fromString for simple parsing
	 * and can also format a date in format "yyyy-mm-ddThh:mm:ss.fffZ" - ISO 8601
	 * it can return null if the format is incorrect
	 */
	public static function parseToDate(str:String):Date
	{
		if (str == null || str == "") {
			return null;
		} else {
			var date:Date = null;
			//check format "yyyy-mm-ddThh:mm:ss.fffZ" or "yyyy-mm-ddThh:mm:ss"- ISO 8601
			var isISOFormat = (str.indexOf("T") != -1 && (str.length == 24 || str.length == 19));
			if (isISOFormat) {
				var year_hour_Split = str.split("T");
				var yearsDataString = year_hour_Split[0];
				var hoursDataString = year_hour_Split[1];
				hoursDataString = hoursDataString.split(".")[0];
				
				var yearsDataSplit = yearsDataString.split("-");
				var yearString:String = yearsDataSplit[0];
				var monthString:String = yearsDataSplit[1];
				var dayString:String = yearsDataSplit[2];
				
				var hoursDataSplit = hoursDataString.split(":");
				var hoursString:String = hoursDataSplit[0];
				var minutesString:String = hoursDataSplit[1];
				var secondsString:String = hoursDataSplit[2];
				//var milisecondsString:String = hourString.substr(6, 4);
				
				var year:Int = Std.parseInt(yearString) != null ? Std.parseInt(yearString) : 0;
				var month:Int = Std.parseInt(monthString) != null ? Std.parseInt(monthString) - 1 : 0; //months are 0-11
				var day:Int = Std.parseInt(dayString) != null ? Std.parseInt(dayString) : 0;
				var hours:Int = Std.parseInt(hoursString) != null ? Std.parseInt(hoursString) : 0;
				var minutes:Int = Std.parseInt(minutesString) != null ? Std.parseInt(minutesString) : 0;
				var seconds:Int = Std.parseInt(secondsString) != null ? Std.parseInt(secondsString) : 0;
				//var miliseconds:Int = Std.parseInt(milisecondsString) != null ? Std.parseInt(milisecondsString) : 0;
				
				date = new Date(year, month, day, hours, minutes, seconds);	
			} else {
				//try normal Date.fromString
				try {
					date = Date.fromString(str);
				} catch (e:Dynamic) {}
			}
			
			return date;
		}
	}
	
	/**
	 * Get a difference in seconds between two dates
	 * 
	 * @param	first = from this date the second will be substracted
	 * @param	second = value to substract from first
	 * @param	returnSubZero = true tells that if the differece is sub zero, it will be returned as so; if false, and the difference is sub zero, it will return 0
	 * @return : an integer value rounded
	 */
	public static function getDifferenceInSecondsBetween(first:Date, second:Date, returnSubZero:Bool = false):Int
	{
		var diffInMilliseconds = first.getTime() - second.getTime();
		if (diffInMilliseconds != 0) {
			var diffInSeconds = Math.round(diffInMilliseconds / 1000);
			if (diffInSeconds < 0 && returnSubZero == false) {
				diffInSeconds = 0;
			}
			
			return diffInSeconds;
		} else {
			return 0;
		}
	}
}