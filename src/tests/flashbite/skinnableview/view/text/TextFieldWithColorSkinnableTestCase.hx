package tests.flashbite.skinnableview.view.text;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.SkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import flashbite.skinnableview.view.text.TextFieldWithColorSkinnable;
import haxe.unit.TestCase;

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
		var skinXmlString:String = '<TextWithColor width="100" height="5" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0"/>';
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
		var tf = new TextFieldWithColorSkinnable(skinObj, skinnableData);
		tf.setText("100");
		tf.color = 0xFF0000;
		
		assertEquals("100", tf.text);
	}
}