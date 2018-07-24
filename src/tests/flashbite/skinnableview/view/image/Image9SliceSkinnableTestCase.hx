package tests.flashbite.skinnableview.view.image;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.image.Image9SliceSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for ImageSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class Image9SliceSkinnableTestCase extends TestCase
{
	private var _skinnableViewCreator:ISkinnableViewCreator;
	private var _container:Sprite;
	private var _styleXml:Xml;
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
		
		_skinnableViewCreator = new SkinnableViewCreator();
		_container = new Sprite();
		
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Image9Slice fileName="alert_border_full2" width="40" height="60" name="alert_border_full2" x="0" y="0" alpha="1" color="0x666666"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		_styleXml = Xml.parse(styleXmlString).firstElement();
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
		
		_skinnableViewCreator = null;
		_container = null;
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	public function test_props():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		var image:Image9SliceSkinnable = cast HelpersGlobal.getChildByName(_container, "alert_border_full2");
		
		assertEquals(Std.parseFloat("0"), image.x);
		assertEquals(Std.parseFloat("0"), image.y);
		assertEquals(Std.parseFloat("40"), image.width);
		assertEquals(Std.parseFloat("60"), image.height);
		assertEquals(Std.parseInt("0x666666"), image.transform.colorTransform.color);
		
		//bmpData must have the specified dimension in skinObj
		assertEquals(40, image.bitmapData.width);
		assertEquals(60, image.bitmapData.height);
	}
	
	public function test_set_dimension():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		var image:Image9SliceSkinnable = cast HelpersGlobal.getChildByName(_container, "alert_border_full2");
		
		//bmpData must have the specified dimension in skinObj
		assertEquals(40, image.bitmapData.width);
		assertEquals(60, image.bitmapData.height);
		
		image.setWidthAndHeight(-1, -1);
		assertEquals(Std.parseFloat("40"), image.width);
		assertEquals(Std.parseFloat("60"), image.height);
		
		image.setWidthAndHeight(1000, 1000);
		assertEquals(Std.parseFloat("1000"), image.width);
		assertEquals(Std.parseFloat("1000"), image.height);
		
		image.setWidthAndHeight(1000, -1);
		assertEquals(Std.parseFloat("1000"), image.width);
		assertEquals(Std.parseFloat("60"), image.height);
		
		image.setWidthAndHeight(-1, 1000);
		assertEquals(Std.parseFloat("40"), image.width);
		assertEquals(Std.parseFloat("1000"), image.height);
		
		//now a redraw will reset
		image.redraw();
		assertEquals(Std.parseFloat("40"), image.width);
		assertEquals(Std.parseFloat("60"), image.height);
	}
}