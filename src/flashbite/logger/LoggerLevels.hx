package flashbite.logger;

/**
 * LoggerLevels contains all the log levels that Logger can write
 * Has also helper functions.
 * 
 * @author Adrian Barbu
 */
@:final
class LoggerLevels 
{
	private function new() {}
	
	/**
	 * use this variable if you want none of the outputs to be send
	 */		
	public static inline var NO_OUTPUT	:	Int = 0;
	/**
	 * Default level; the color will be black
	 */		
	public static inline var ALL		:	Int = 1000;
	/**
	 * Debug level; the color will be blue 
	 */		
	public static inline var DEBUG		:	Int = 4;
	/**
	* Info level; the color will be brown 
	*/		
	public static inline var INFO		:	Int = 3;
	/**
	 * Warning level; the color will be orange 
	 */		
	public static inline var WARNING	:	Int = 2;
	/**
	 * Error level; the color will be red 
	 */		
	public static inline var ERROR		:	Int = 1;
	
	private static var _all:Array<Int> = [NO_OUTPUT, ALL, DEBUG, INFO, WARNING, ERROR];
	
	public static function isKnown(value:Int):Bool { return _all.indexOf(value) != -1; }
	
	/**
	 * Function to return a String representation of the log level 
	 * 
	 * @param level: (int) defined in this class consts
	 * @return: (String) representation of a level id
	 */		
	public static function logLevelToString(logLevel:Int):String
	{
		switch (logLevel) {
			case DEBUG:		return "DEBUG";
			case INFO:		return "INFO";
			case WARNING:	return "WARNING";
			case ERROR:		return "ERROR";
			default: 		return "ALL";
		}
	}
	
	/**
	 * Function to return a Color representation of the log level 
	 * 
	 * @param level: (int) defined in this class consts
	 * @return: (int) color representation of a level id
	 */	
	public static function logLevelToColor(logLevel:Int):Int
	{
		switch (logLevel) {
			case DEBUG:		return 0x0000FF;
			case INFO:		return 0x993300;
			case WARNING:	return 0xFF9900;
			case ERROR:		return 0xFF0000;
			default: 		return 0x000000;
		}
	}
}