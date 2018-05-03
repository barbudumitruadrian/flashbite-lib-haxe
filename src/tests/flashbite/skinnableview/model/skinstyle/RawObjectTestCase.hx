package tests.flashbite.skinnableview.model.skinstyle;

import flashbite.skinnableview.model.skinstyle.IRawObject;
import flashbite.skinnableview.model.skinstyle.RawObject;
import haxe.unit.TestCase;

/**
 * TestCase for RawObject
 * 
 * @author Adrian Barbu
 */
@:final
class RawObjectTestCase extends TestCase
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
	
	public function test_getPropertyValue():Void
	{
		var rawObj:IRawObject = new RawObject();
		Reflect.setProperty(rawObj, "data", "value");
		
		assertEquals("value", rawObj.getPropertyValue("data")); //caseInsensitive
		assertEquals("value", rawObj.getPropertyValue("DATA")); //caseInsensitive
		assertEquals(null, rawObj.getPropertyValue("DATA", false)); //caseSensitive
		assertEquals("value", rawObj.getPropertyValue("DATAA", true, "value")); //caseInsensitive with default value
		assertEquals("value", rawObj.getPropertyValue("DATAA", false, "value")); //caseSensitive with default value
	}
	
	public function test_hasProperty():Void
	{
		var rawObj:IRawObject = new RawObject();
		Reflect.setProperty(rawObj, "data", "value");
		
		assertTrue(rawObj.hasProperty("data")); //caseInsensitive
		assertTrue(rawObj.hasProperty("DATA")); //caseInsensitive
		assertFalse(rawObj.hasProperty("DATA", false)); //caseSensitive
	}
	
	public function test_copyFrom():Void
	{
		var rawObj:IRawObject = new RawObject();
		Reflect.setProperty(rawObj, "data", "value");
		
		var newRawObj:IRawObject = new RawObject();
		Reflect.setProperty(rawObj, "data2", "value2");
		
		rawObj.copyFrom(newRawObj);
		
		assertTrue(rawObj.hasProperty("data2"));
		assertEquals("value2", rawObj.getPropertyValue("data2"));
	}
}