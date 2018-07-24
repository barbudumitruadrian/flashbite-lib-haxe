package tests.flashbite.skinnableview.view.layout;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.layout.VerticalLayout;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for VerticalLayout
 * 
 * @author Adrian Barbu
 */
@:final
class VerticalLayoutTestCase extends TestCase
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
						'<Container containerType="VerticalLayout" name="layout" x="center" y="center" alpha="1" width="100%" height="100%" padding="10" autoSizePadding="false" horizontalAlign="left" verticalAlign="top">' +
							'<Shape width="20%" height="50%" color="0xFFFFFF" name="one" x="0" y="0" alpha="1"/>' +
							'<Shape width="20%" height="50%" color="0xFFFFFF" name="second" x="0" y="0" alpha="1"/>' +
							'<Shape width="20%" height="50%" color="0xFFFFFF" name="third" x="0" y="0" alpha="1"/>' +
							'<Shape width="20%" height="50%" color="0xFFFFFF" name="fourth" x="0" y="0" alpha="1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(container, "main", 100, 100);
		
		var layout:VerticalLayout = cast HelpersGlobal.getChildByName(container, "layout");
		
		assertEquals(4, layout.children.length);
		assertEquals(layout.numChildren, layout.children.length);
		
		layout.removeChild(layout.getChildByName("one"));
		assertEquals(3, layout.children.length);
		assertEquals(layout.numChildren, layout.children.length);
		
		layout.redraw();
		
		//we are at top/left, so first item should stay at padding
		var padding:Float = 10;
		var second = HelpersGlobal.getChildByName(layout, "second");
		assertEquals(padding, second.x);
		assertEquals(padding, second.y);
		
		//make sure the y is ascending on children (since we are in vertical alignement)
		var previousY:Float = Math.NEGATIVE_INFINITY;
		for (i in 0...layout.numChildren) {
			var child = layout.getChildAt(i);
			var currentY = child.y;
			assertTrue(currentY > previousY);
			previousY = currentY;
		}
	}
}