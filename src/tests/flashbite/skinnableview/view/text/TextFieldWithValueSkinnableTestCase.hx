package tests.flashbite.skinnableview.view.text;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.text.TextFieldWithValueSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

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
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<TextWithValue content="{value} data" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0" name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 300, 300);
		skinnableViewCreator.construct(container, "main", 300, 300);
		
		var tf:TextFieldWithValueSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
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
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<TextWithValue content="{value} data" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0" name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldWithValueSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
		tf.setValue("");
		
		assertEquals(" data", tf.text);
	}
	public function test_setValue_empty_inRight():Void
	{
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<TextWithValue content="data {value}" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0" name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldWithValueSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
		tf.setValue("");
		
		assertEquals("data ", tf.text);
	}
	
	public function test_setValue_WithTruncationEnabled():Void
	{
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<TextWithValue content="data {value}" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0" truncate="true" truncationValue="..." name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldWithValueSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
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
	public function test_setValue_withNewText():Void
	{
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<TextWithValue content="{value} data" width="100%" height="100%" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" valueTextFormat="Museo_Slab_900_Regular_50_center_0xFFFFFF_0" name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldWithValueSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
		//new text doesn't contain replacement, so we will use initialText
		tf.setValue("", "test");
		assertEquals(" data", tf.text);
		
		tf.setValue("", "{value} someNewData");
		assertEquals(" someNewData", tf.text);
		
		tf.setValue("10", "{value} someNewData");
		assertEquals("10 someNewData", tf.text);
	}
}