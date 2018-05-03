package tests.flashbite.helpers;

import flashbite.helpers.HelpersMath;
import haxe.unit.TestCase;

/**
 * TestCase for HelpersMath
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersMathTestCase extends TestCase
{
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	public function test_roundToDecimals():Void
	{
		var input:Array<String>   = ["100", "100.1", "100.4", "100.5", "100.9", "100.01", "100.49", "100.50", "100.99"];
		var output0:Array<String> = ["100",   "100",   "100",   "101",   "101",   "100",     "100",    "101",    "101"];
		var output1:Array<String> = ["100", "100.1", "100.4", "100.5", "100.9",   "100",   "100.5",  "100.5",    "101"];
		var output2:Array<String> = ["100", "100.1", "100.4", "100.5", "100.9", "100.01", "100.49",  "100.5", "100.99"];
		
		for (i in 0...input.length) {
			var input_i = Std.parseFloat(input[i]);
			var output0_i = Std.parseFloat(output0[i]);
			var output1_i = Std.parseFloat(output1[i]);
			var output2_i = Std.parseFloat(output2[i]);
			
			assertEquals(output0_i, HelpersMath.roundToDecimals(input_i, 0));
			assertEquals(output1_i, HelpersMath.roundToDecimals(input_i, 1));
			assertEquals(output2_i, HelpersMath.roundToDecimals(input_i, 2));
		}
	}
}