package tests.flashbite.skinnableview.view.image;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.image.ImageSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for ImageSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class ImageSkinnableTestCase extends TestCase
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
	
	public function test_props():Void
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
						'<Image fileName="car_parking_body" width="40" height="60" name="car_parking_body" x="0" y="0" alpha="1" color="0x666666"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var image:ImageSkinnable = cast HelpersGlobal.getChildByName(container, "car_parking_body");
		
		assertEquals(Std.parseFloat("0"), image.x);
		assertEquals(Std.parseFloat("0"), image.y);
		assertEquals(Std.parseFloat("40"), image.width);
		assertEquals(Std.parseFloat("60"), image.height);
		assertEquals(Std.parseInt("0x666666"), image.transform.colorTransform.color);
		
		//fallback bmpData with 1x1 dimension
		assertEquals(1, image.bitmapData.width);
		assertEquals(1, image.bitmapData.height);
	}
}