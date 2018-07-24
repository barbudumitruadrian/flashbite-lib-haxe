package tests.flashbite.skinnableview.view.shape;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.shape.ShapeSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for ShapeSkinnable
 * 
 * @author Adrian Barbu
 */
@:final
class ShapeSkinnableTestCase extends TestCase
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
						'<Shape width="10" height="20" color="0x000000" name="bg" x="0" y="0" alpha="1"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var shape:ShapeSkinnable = cast HelpersGlobal.getChildByName(container, "bg");
		
		assertEquals(Std.parseFloat("10"), shape.width);
		assertEquals(Std.parseFloat("20"), shape.height);
		assertEquals(Std.parseFloat("0"), shape.x);
		assertEquals(Std.parseFloat("0"), shape.y);
		assertEquals(0x000000, shape.color);
	}
	
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
						'<Shape width="10" height="20" color="0x000000" name="bg" x="0" y="0" alpha="1"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var shape:ShapeSkinnable = cast HelpersGlobal.getChildByName(container, "bg");
		
		shape.color = 0x666666;
		assertEquals(0x666666, shape.color);
		
		//wrong value on color, it should not change
		shape.color = -1;
		assertEquals(0x666666, shape.color);
	}
}