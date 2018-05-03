package flashbite.logger.targets;

import flashbite.logger.LoggerLevels;
import haxe.Log;

/**
 * TraceLoggerTarget is a Logger target that has the same functionality as Log.trace
 * 
 * @author Adrian Barbu
 */
@:final
class TraceLoggerTarget implements ILoggerTarget
{
	private static inline var MAX_LOG_LENGTH:Int = 2500;
	
	private static var _posInfo:Dynamic = {
		fileName : "",
		lineNumber : 0,
		className : "",
		methodName : ""
	};
	
	public function new() {}
	
	public function logMessage(loggerName:String, level:Int, message:String):Void 
	{
		var finalMessage:String = createFormatedHour() + " >> " + createMessage(loggerName, level, message);
		if (finalMessage.length > MAX_LOG_LENGTH) {
			finalMessage = finalMessage.substring(0, MAX_LOG_LENGTH) + "...";
		}
		Log.trace(finalMessage, _posInfo);
	}
	
	private function createMessage(loggerName:String, level:Int, message:String):String
	{
		return ("[" + loggerName + "] " + "[" + LoggerLevels.logLevelToString(level) + "] " + message);
	}
	
	private function createFormatedHour():String
	{
		return DateTools.format(Date.now(), "%T");
	}
}