package tests.flashbite.helpers;

import flashbite.helpers.HelpersGlobal;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for HelpersGlobal
 * 
 * @author Adrian Barbu
 */
@:final
class HelpersGlobalTestCase extends TestCase
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
	
	public function test_getClassName():Void
	{
		var currentClassName:String = "HelpersGlobalTestCase";
		var currentFullClassName:String = "tests.flashbite.helpers.HelpersGlobalTestCase";
		
		assertEquals(currentClassName, HelpersGlobal.getClassName(this, false));
		assertEquals(currentFullClassName, HelpersGlobal.getClassName(this, true));
	}
	
	public function test_getCaseInsensitivePropValuePercent():Void
	{
		var obj:Dynamic = {
			value0:"0%",
			valueFull:"100%",
			valueHalf:"50%",
			valueNoPercent:"50"
		};
		
		assertEquals(Std.parseFloat("0"), HelpersGlobal.getCaseInsensitivePropValuePercent(obj, "value0"));
		assertEquals(Std.parseFloat("1"), HelpersGlobal.getCaseInsensitivePropValuePercent(obj, "valueFull"));
		assertEquals(Std.parseFloat("0.5"), HelpersGlobal.getCaseInsensitivePropValuePercent(obj, "valueHalf"));
		//if no percent is provided, value must be 1
		assertEquals(Std.parseFloat("1"), HelpersGlobal.getCaseInsensitivePropValuePercent(obj, "valueNoPercent"));
	}
	
	public function test_getCaseInsensitivePropValue():Void
	{
		var dataValue:String = "dataValue";
		var dataName:String = "dataName";
			
		var obj:Dynamic = {};
		Reflect.setField(obj, dataName, dataValue);
		
		//without defaultValue and without restrictValuesList
		//normal
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName));
		//lower case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toLowerCase()));
		//upper case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toUpperCase()));
		//bad name
		var dataNameBad:String = dataName + "_";
		assertEquals(null, HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad));
		assertFalse(HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad) == dataValue);
		
		//with defaultValue and without restrictValuesList
		//normal
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName, dataValue));
		//lower case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toLowerCase()));
		//upper case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toUpperCase(), dataValue));
		//bad name
		dataNameBad = dataName + "_";
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad, dataValue));
		
		//without defaultValue and with restrictValuesList
		//normal
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName, null, [dataValue]));
		//lower case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toLowerCase(), null, [dataValue]));
		//lower case - also in restrict values(restrict values are also case insensitive)
		assertEquals(dataValue.toLowerCase(), HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toLowerCase(), null, [dataValue.toLowerCase()]));
		//upper case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toUpperCase(), null, [dataValue]));
		//upper case - also in restrict values(restrict values are also case insensitive)
		assertEquals(dataValue.toUpperCase(), HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toUpperCase(), null, [dataValue.toUpperCase()]));
		//bad name
		dataNameBad = dataName + "_";
		assertEquals(null, HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad, null, [dataValue]));
		assertFalse(HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad, null, [dataValue]) == dataValue);
		assertFalse(HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad, null, []) == dataValue);
		
		//with defaultValue and with restrictValuesList
		//normal
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName, dataValue, [dataValue]));
		//lower case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toLowerCase(), dataValue, [dataValue]));
		//lower case - also in restrict values(restrict values are also case insensitive)
		assertEquals(dataValue.toLowerCase(), HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toLowerCase(), dataValue, [dataValue.toLowerCase()]));
		//upper case
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toUpperCase(), dataValue, [dataValue]));
		//upper case - also in restrict values(restrict values are also case insensitive)
		assertEquals(dataValue.toUpperCase(), HelpersGlobal.getCaseInsensitivePropValue(obj, dataName.toUpperCase(), dataValue, [dataValue.toUpperCase()]));
		//bad name
		dataNameBad = dataName + "_";
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad, dataValue, [dataValue]));
		assertEquals(dataValue, HelpersGlobal.getCaseInsensitivePropValue(obj, dataNameBad, dataValue, []));
	}
	
	public function test_hasProperty():Void
	{
		var dataValue:String = "dataValue";
		var dataName:String = "dataName";
			
		var obj:Dynamic = {};
		Reflect.setField(obj, dataName, dataValue);
		
		//normal
		assertTrue(HelpersGlobal.hasProperty(obj, dataName));
		//lower case
		assertTrue(HelpersGlobal.hasProperty(obj, dataName.toLowerCase()));
		//upper case
		assertTrue(HelpersGlobal.hasProperty(obj, dataName.toUpperCase()));
		//bad name
		var dataNameBad:String = dataName + "_";
		assertFalse(HelpersGlobal.hasProperty(obj, dataNameBad));
	}
	
	public function test_hasOneOfProperty():Void
	{
		var obj:Dynamic = {};
		obj.data1 = "value1";
		obj.data2 = "value2";
		obj.data3 = "value3";
		
		//FOUND
		//no item
		assertTrue(HelpersGlobal.hasOneOfProperty(obj, []));
		//single item
		assertTrue(HelpersGlobal.hasOneOfProperty(obj, ["data1"]));
		//all items
		assertTrue(HelpersGlobal.hasOneOfProperty(obj, ["data1", "data2", "data3"]));
		//all items plus another
		assertTrue(HelpersGlobal.hasOneOfProperty(obj, ["someOtherProperty", "data1", "data2", "data3"]));
		
		//FOUND-case insensitive
		//single item
		assertTrue(HelpersGlobal.hasOneOfProperty(obj, ["Data1"]));
		//all items
		assertTrue(HelpersGlobal.hasOneOfProperty(obj, ["DATA1", "datA2", "DatA3"]));
		//all items plus another
		assertTrue(HelpersGlobal.hasOneOfProperty(obj, ["someOtherProperty", "DATA1", "datA2", "DatA3"]));
		
		//NOT-FOUND
		//single item
		assertFalse(HelpersGlobal.hasOneOfProperty(obj, ["someOtherProperty1"]));
		//multiple items
		assertFalse(HelpersGlobal.hasOneOfProperty(obj, ["someOtherProperty1", "someOtherProperty2"]));
	}
	
	public function test_hasAllProperties():Void
	{
		var obj:Dynamic = {};
		obj.data1 = "value1";
		obj.data2 = "value2";
		obj.data3 = "value3";
		
		//FOUND
		//no item
		assertTrue(HelpersGlobal.hasAllProperties(obj, []));
		//single item
		assertTrue(HelpersGlobal.hasAllProperties(obj, ["data1"]));
		//all items
		assertTrue(HelpersGlobal.hasAllProperties(obj, ["data1", "data2", "data3"]));
		//all items plus another
		assertFalse(HelpersGlobal.hasAllProperties(obj, ["someOtherProperty", "data1", "data2", "data3"]));
		
		//FOUND-case insensitive
		//single item
		assertTrue(HelpersGlobal.hasAllProperties(obj, ["Data1"]));
		//all items
		assertTrue(HelpersGlobal.hasAllProperties(obj, ["DATA1", "datA2", "DatA3"]));
		//all items plus another
		assertFalse(HelpersGlobal.hasAllProperties(obj, ["someOtherProperty", "DATA1", "datA2", "DatA3"]));
		
		//NOT-FOUND
		//single item
		assertFalse(HelpersGlobal.hasAllProperties(obj, ["someOtherProperty1"]));
		//multiple items
		assertFalse(HelpersGlobal.hasAllProperties(obj, ["someOtherProperty1", "someOtherProperty2"]));
	}
	
	public function test_translateToBoolean():Void
	{
		//standard
		assertFalse(HelpersGlobal.translateToBoolean(null));
		
		//false
		assertFalse(HelpersGlobal.translateToBoolean(false));
		assertFalse(HelpersGlobal.translateToBoolean("false"));
		assertFalse(HelpersGlobal.translateToBoolean("FALSE"));
		assertFalse(HelpersGlobal.translateToBoolean("inactive"));
		assertFalse(HelpersGlobal.translateToBoolean("INACTIVE"));
		assertFalse(HelpersGlobal.translateToBoolean("no"));
		assertFalse(HelpersGlobal.translateToBoolean("NO"));
		assertFalse(HelpersGlobal.translateToBoolean("0"));
		
		//true
		assertTrue(HelpersGlobal.translateToBoolean(true));
		assertTrue(HelpersGlobal.translateToBoolean("true"));
		assertTrue(HelpersGlobal.translateToBoolean("TRUE"));
		assertTrue(HelpersGlobal.translateToBoolean("active"));
		assertTrue(HelpersGlobal.translateToBoolean("ACTIVE"));
		assertTrue(HelpersGlobal.translateToBoolean("yes"));
		assertTrue(HelpersGlobal.translateToBoolean("YES"));
		assertTrue(HelpersGlobal.translateToBoolean("1"));
		
		//any other value must return true
		assertTrue(HelpersGlobal.translateToBoolean(" "));
		assertTrue(HelpersGlobal.translateToBoolean("data"));
		assertTrue(HelpersGlobal.translateToBoolean(" 0 "));
		assertTrue(HelpersGlobal.translateToBoolean(" 1 "));
		assertTrue(HelpersGlobal.translateToBoolean("!!"));
		assertTrue(HelpersGlobal.translateToBoolean({}));
	}
	
	public function test_getChildByName():Void
	{
		var root = new Sprite();
			
		var item:Sprite = new Sprite();
		item.name = "name";
		item.x = 21.04;
		item.y = 312321.2132;
		root.addChild(item);
		
		assertTrue(HelpersGlobal.getChildByName(root, "name") != null);
		assertEquals(item, cast HelpersGlobal.getChildByName(root, "name"));
		
		var item2:Sprite = new Sprite();
		item2.name = "name2";
		item.addChild(item2);
		
		assertTrue(HelpersGlobal.getChildByName(root, "name.name2") != null);
		assertEquals(item2, cast HelpersGlobal.getChildByName(root, item.name + "." + item2.name));
		
		//this will not work ;)
		item2.name = "name2.failure";
		assertTrue(HelpersGlobal.getChildByName(root, "name.name2.failure") == null);
		assertFalse(item2 == HelpersGlobal.getChildByName(root, item.name + "." + item2.name));
	}
	
	public function test_addLeadingZeroes():Void
	{
		var nmb:Int = 10;
		assertEquals("10", HelpersGlobal.addLeadingZeroes(nmb, 0));
		assertEquals("10", HelpersGlobal.addLeadingZeroes(nmb, 1));
		
		assertEquals("10", HelpersGlobal.addLeadingZeroes(nmb, 2));
		assertEquals("010", HelpersGlobal.addLeadingZeroes(nmb, 3));
		assertEquals("0010", HelpersGlobal.addLeadingZeroes(nmb, 4));
	}
	
	public function test_parseToPoint():Void
	{
		//incorrect
		var outPoint_incorrect_null = HelpersGlobal.parseToPoint(null);
		assertTrue(outPoint_incorrect_null != null);
		assertEquals(Std.parseFloat("0"), outPoint_incorrect_null.x);
		assertEquals(Std.parseFloat("0"), outPoint_incorrect_null.y);
		
		var outPoint_incorrect_empty = HelpersGlobal.parseToPoint("");
		assertTrue(outPoint_incorrect_empty != null);
		assertEquals(Std.parseFloat("0"), outPoint_incorrect_empty.x);
		assertEquals(Std.parseFloat("0"), outPoint_incorrect_empty.y);
		
		var outPoint_incorrect_wrongFormat1 = HelpersGlobal.parseToPoint("no_comma");
		assertTrue(outPoint_incorrect_wrongFormat1 != null);
		assertEquals(Std.parseFloat("0"), outPoint_incorrect_wrongFormat1.x);
		assertEquals(Std.parseFloat("0"), outPoint_incorrect_wrongFormat1.y);
		
		//correct
		var outPoint_correct_parse1 = HelpersGlobal.parseToPoint("100,200");
		assertTrue(outPoint_correct_parse1 != null);
		assertEquals(Std.parseFloat("100"), outPoint_correct_parse1.x);
		assertEquals(Std.parseFloat("200"), outPoint_correct_parse1.y);
	}
}