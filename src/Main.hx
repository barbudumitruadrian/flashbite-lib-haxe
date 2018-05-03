package;

import flashbite.console.Console;
import flashbite.logger.Logger;
import flashbite.logger.LoggerLevels;
import flashbite.logger.targets.TraceLoggerTarget;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import tests.FlashbiteTestRunner;

/**
 * ...
 * @author Adrian Barbu
 */
class Main extends Sprite
{
	public function new()
	{
		super();
		
		initLoggers();
		addConsole();
		runTestCases();
	}

	private function initLoggers():Void
	{	
		Logger.addLoggerTarget(new TraceLoggerTarget());
		Logger.setMaxOutputLevel(LoggerLevels.ALL);
	}
	
	private function addConsole():Void
	{
		var console = new Console(this);
		Logger.addLoggerTarget(console);
		console.addEventListener(Console.REMOVED, function onRemoved(e:Event):Void {
			Logger.removeLoggerTarget(console);
		});
	}
	
	private function runTestCases():Void
	{
		var timeStart = Lib.getTimer();
		
		var runner = new FlashbiteTestRunner();
		runner.run();
		var totalTimeMs = Lib.getTimer() - timeStart;
		
		Logger.debug(this, "Running test done in " + totalTimeMs + " ms. Result is : " + runner.result.toString());
	}
}