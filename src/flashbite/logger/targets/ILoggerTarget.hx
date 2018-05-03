package flashbite.logger.targets;

/**
 * Interface for any logTarget that can be registered to Logger
 * 
 * @author Adrian Barbu
 */
interface ILoggerTarget 
{
	public function logMessage(loggerName:String, level:Int, message:String):Void;
}