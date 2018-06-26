package tests.flashbite.skinnableview.view.text;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.SkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import flashbite.skinnableview.view.text.TextFieldWithValueSkinnable;
import haxe.unit.TestCase;

/**
 * TestCase for TextFieldWithValueSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class TextFieldWithValueSkinnableTestCase extends TestCase
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
	
	public function test_setValue():Void
	{
		var skinXmlString:String = '<Text content="{value} data" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0"/>';
		var skinnableDataXmlString:String = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style/>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 300, 300, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 300, 300);
		var tf = new TextFieldWithValueSkinnable(skinObj, skinnableData);
		tf.setValue("100");
		
		assertEquals("100 data", tf.text);
		//unfortunately, getTextFormat doesn't work...., so we are unable to test this properly
		var allTextFormat = tf.getTextFormat();
		assertEquals(50, allTextFormat.size);
		
		var valueTextFormat = tf.getTextFormat(0, 3);
		var lastPartTextFormat = tf.getTextFormat(4, tf.text.length);
		
		assertEquals(Std.parseInt("0xFFFFFF"), valueTextFormat.color);
		assertEquals(Std.parseInt("0x064413"), lastPartTextFormat.color);
		assertFalse(valueTextFormat.color == lastPartTextFormat.color);
		
		assertEquals(valueTextFormat.font, lastPartTextFormat.font);
		assertEquals(valueTextFormat.size, lastPartTextFormat.size);
	}
	
	public function test_setValue_empty_inLeft():Void
	{
		var skinXmlString:String = '<Text content="{value} data" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0"/>';
		var skinnableDataXmlString:String = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style/>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 300, 300, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 300, 300);
		var tf = new TextFieldWithValueSkinnable(skinObj, skinnableData);
		tf.setValue("");
		
		assertEquals(" data", tf.text);
	}
	public function test_setValue_empty_inRight():Void
	{
		var skinXmlString:String = '<Text content="data {value}" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0"/>';
		var skinnableDataXmlString:String = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style/>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 300, 300, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 300, 300);
		var tf = new TextFieldWithValueSkinnable(skinObj, skinnableData);
		tf.setValue("");
		
		assertEquals("data ", tf.text);
	}
	
	public function test_setValue_WithTruncationEnabled():Void
	{
		var skinXmlString:String = '<Text content="data {value}" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0" truncate="true" truncationValue="..."/>';
		var skinnableDataXmlString:String = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style/>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 40, 40, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 40, 40);
		var tf = new TextFieldWithValueSkinnable(skinObj, skinnableData);
		
		//with truncation enabled and text not fitting, setValue will crash due to 
		var hasError:Bool = false;
		try {
			tf.setValue("data");
		} catch (e:Dynamic) {
			hasError = true;
		}
		assertFalse(hasError);
		
		//since we use truncate, the text will not be as default, it will contain truncationValue ("...")
		assertFalse(tf.text == "data data");
		//and must contain the truncation value
		assertTrue(tf.text.indexOf("...") != -1);
	}
}