package tests.flashbite.skinnableview.view.text;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

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
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Text width="100" height="5" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
		tf.setText("super long textttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
		
		assertEquals(4, tf.getTextFormat().size);
	}
	
	public function test_autoScale_deactivated():Void
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
						'<Text width="100" height="5" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" autoScale="false" name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
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
		var skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
		var container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Text width="100" height="50" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" truncate="true" truncationValue="..." name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
		tf.setText("super long textttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
		
		//text must be truncated
		assertTrue(tf.text != "super long textttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttttt");
		//and must contain the truncation value
		assertTrue(tf.text.indexOf("...") != -1);
	}
}