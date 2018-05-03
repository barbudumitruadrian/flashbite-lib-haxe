package tests.flashbite.helpers;

import flashbite.helpers.HelpersString;
import haxe.unit.TestCase;

/**
 * TestCase for HelpersString
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersStringTestCase extends TestCase
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
	
	public function test_getCaseInsensitivePropName():Void
	{
		var dataValue:String = "dataValue";
		var dataName:String = "dataName";
		
		var obj:Dynamic = {};
		Reflect.setField(obj, dataName, dataValue);
		
		//normal
		assertEquals(dataName, HelpersString.getCaseInsensitivePropName(obj, dataName));
		assertEquals(dataValue, Reflect.getProperty(obj, HelpersString.getCaseInsensitivePropName(obj, dataName)));
		//lower case
		assertEquals(dataName, HelpersString.getCaseInsensitivePropName(obj, dataName.toLowerCase()));
		assertEquals(dataValue, Reflect.getProperty(obj, HelpersString.getCaseInsensitivePropName(obj, dataName.toLowerCase())));
		//upper case
		assertEquals(dataName, HelpersString.getCaseInsensitivePropName(obj, dataName.toUpperCase()));
		assertEquals(dataValue, Reflect.getProperty(obj, HelpersString.getCaseInsensitivePropName(obj, dataName.toUpperCase())));
		//bad name
		var dataNameBad:String = dataName + "_";
		assertEquals(null, HelpersString.getCaseInsensitivePropName(obj, dataNameBad));
		assertFalse(HelpersString.getCaseInsensitivePropName(obj, dataNameBad) == dataName);
	}
	
	public function test_toLowerCase():Void
	{
		var str:String = "abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {}";
		assertEquals(str.toLowerCase(), HelpersString.toLowerCase(str));
	}
	
	public function test_toUpperCase():Void
	{
		var str:String = "abc def ghi jkl mno pqrs tuv wxyz ABC DEF GHI JKL MNO PQRS TUV WXYZ !§ $%& /() =?* '<> #|; ²³~ @`´ ©«» ¤¼× {}";
		assertEquals(str.toUpperCase(), HelpersString.toUpperCase(str));
	}
}