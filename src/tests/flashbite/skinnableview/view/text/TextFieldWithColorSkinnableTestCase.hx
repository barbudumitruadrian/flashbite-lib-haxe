package tests.flashbite.skinnableview.view.text;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.text.TextFieldWithColorSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for TextFieldWithColorSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class TextFieldWithColorSkinnableTestCase extends TestCase
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
	
	public function test_setColor():Void
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
						'<TextWithColor width="100" height="5" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" name="tf"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var tf:TextFieldWithColorSkinnable = cast HelpersGlobal.getChildByName(container, "tf");
		
		tf.setText("100");
		tf.color = 0xFF0000;
		
		assertEquals("100", tf.text);
	}
}