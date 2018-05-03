package tests.flashbite.skinnableview.view.image;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.SkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import flashbite.skinnableview.view.image.ImageSkinnable;
import haxe.unit.TestCase;

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
		var skinXmlString:String = '<Image fileName="car_parking_body" width="40" height="60" name="car_parking_body" x="0" y="0" alpha="1" color="0x666666"/>';
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
		var image = new ImageSkinnable(skinObj, skinnableData);
		
		assertEquals(Std.parseFloat("0"), image.x);
		assertEquals(Std.parseFloat("0"), image.y);
		assertEquals(Std.parseFloat("40"), image.width);
		assertEquals(Std.parseFloat("60"), image.height);
		assertEquals(Std.parseInt("0x666666"), image.transform.colorTransform.color);
	}
}