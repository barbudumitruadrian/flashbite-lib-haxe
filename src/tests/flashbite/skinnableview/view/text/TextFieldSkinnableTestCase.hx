package tests.flashbite.skinnableview.view.text;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.SkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import haxe.unit.TestCase;

/**
 * TestCase for TextFieldSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class TextFieldSkinnableTestCase extends TestCase
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
	
	public function test_autoScale_active():Void
	{
		var skinXmlString:String = '<Text width="100" height="5" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0"/>';
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
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 100, 100, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 100, 100);
		var tf = new TextFieldSkinnable(skinObj, skinnableData);
		tf.setText("super long textttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
		
		assertEquals(4, tf.getTextFormat().size);
	}
	
	public function test_autoScale_deactivated():Void
	{
		var skinXmlString:String = '<Text width="100" height="5" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" autoScale="false"/>';
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
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 100, 100, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 100, 100);
		var tf = new TextFieldSkinnable(skinObj, skinnableData);
		tf.setText("super long textttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
		
		var initialTextFormat = tf.getTextFormat();
		
		assertEquals(50, initialTextFormat.size);
		#if (html5 || cpp)
		assertEquals("Museo Slab 900 Regular", initialTextFormat.font); //in html5 the font is set to default...(also in cpp)
		#else
		assertEquals("Helvetica", initialTextFormat.font); //since we don't have the text embeded...
		#end
		assertEquals(Std.parseInt("0x064413"), initialTextFormat.color);
	}
	
	public function test_truncation():Void
	{
		var skinXmlString:String = '<Text width="100" height="50" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" truncate="true" truncationValue="..."/>';
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
		
		var skinObj:ISkinObject = new SkinObject(Xml.parse(skinXmlString).firstElement(), 100, 100, false);
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(Xml.parse(skinnableDataXmlString).firstElement(), null, null, "en", 100, 100);
		var tf = new TextFieldSkinnable(skinObj, skinnableData);
		tf.setText("super long textttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
		
		//text must be truncated
		assertTrue(tf.text != "super long textttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
		//and must contain the truncation value
		assertTrue(tf.text.indexOf("...") != -1);
	}
}