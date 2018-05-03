package flashbite.logger;

import flashbite.helpers.HelpersGlobal;
import flashbite.logger.targets.ILoggerTarget;

/**
 * Logger class to write logs; can be used instead of trace() call
 * ex:
 * Logger.setMaxOutputLevel(LoggerLevels.ALL);
 * Logger.addLoggerTarget(new TraceLoggerTarget());
 * Logger.debug("ClassName", "output") will trace(timestamp >> [ClassName] [DEBUG] output);
 * or 
 * Logger.debug(this, "output") will trace(timestamp >> [ClassName] [DEBUG] output);
 * 
 * @author Adrian Barbu
 */
@:final
class Logger 
{
	private function new() {}
	
	// ====================================================================================================================================
	// OUTPUT LEVEL
	// ====================================================================================================================================
	
	private static var _maxOutputLevel:Int = LoggerLevels.ALL;
	/** Sets the new max output level; if any log call is smaller than this level, they will be written */
	public static function setMaxOutputLevel(value:Int):Void
	{
		if (LoggerLevels.isKnown(value) == false) {
			value = LoggerLevels.ALL;
		}
		_maxOutputLevel = value;
	}
	
	// ====================================================================================================================================
	// OUTPUT TARGET
	// ====================================================================================================================================
	
	private static var _outputTargets:Array<ILoggerTarget> = new Array<ILoggerTarget>();
	
	/** Add a new logTarget to write */
	public static function addLoggerTarget(loggerTarget:ILoggerTarget):Void
	{
		_outputTargets.push(loggerTarget);
	}
	/** Removes a registered logTarget */
	public static function removeLoggerTarget(loggerTarget:ILoggerTarget):Void
	{
		_outputTargets.remove(loggerTarget);
	}
	
	// ====================================================================================================================================
	// WRITE
	// ====================================================================================================================================
	
	/** Writes a message with "DEBUG" */
	public static function debug(nameOrClassInstance:Dynamic, message:String):Void
	{
		sendMessage(nameOrClassInstance, LoggerLevels.DEBUG, message);
	}
	/** Writes a message with "INFO" */
	public static function info(nameOrClassInstance:Dynamic, message:String):Void
	{
		sendMessage(nameOrClassInstance, LoggerLevels.INFO, message);
	}
	/** Writes a message with "WARNING" */
	public static function warning(nameOrClassInstance:Dynamic, message:String):Void
	{
		sendMessage(nameOrClassInstance, LoggerLevels.WARNING, message);
	}
	/** Writes a message with "ERROR" */
	public static function error(nameOrClassInstance:Dynamic, message:String):Void
	{
		sendMessage(nameOrClassInstance, LoggerLevels.ERROR, message);
	}
	
	private static function sendMessage(nameOrClassInstance:Dynamic, logLevel:Int, message:String):Void
	{
		if (requirementsAreMetToLog(logLevel)) {
			var name = getName(nameOrClassInstance);
			for (target in _outputTargets) {
				target.logMessage(name, logLevel, message);
			}
		}
	}
	
	private static function getName(nameOrClassInstance:Dynamic):String
	{
		if (Std.is(nameOrClassInstance, String)) {
			return cast nameOrClassInstance;
		} else {
			return HelpersGlobal.getClassName(nameOrClassInstance);
		}
	}
	
	private static function requirementsAreMetToLog(logLevel:Int):Bool 
	{
		return ((logLevel <= _maxOutputLevel) && (_outputTargets.length != 0)); 
	}
}