package flashbite.helpers;

/**
 * Math helpers
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersMath 
{
	private function new() {}
	
	/** Rounds a number to a specific number of decimals */
	public static function roundToDecimals(value:Float, numDecimals:Int):Float
	{
		var p:Float = Math.pow(10, numDecimals);
		return Math.round(value * p) / p;
	}
}