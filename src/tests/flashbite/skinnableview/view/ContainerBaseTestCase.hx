package tests.flashbite.skinnableview.view;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.ViewBase;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for ContainerBase
 * 
 * @author Adrian Barbu
 */
@:final
class ContainerBaseTestCase extends TestCase
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
	
	public function test_has_skinObj():Void
	{
		var skinObj:ISkinObject = new SkinObject(Xml.parse('<Container/>').firstElement(), 100, 100, false);
		var container = new ContainerBase(skinObj, null);
		
		assertEquals(skinObj, container.skinObj);
	}
	
	public function test_rotation():Void
	{
		var skinObj:ISkinObject = new SkinObject(Xml.parse('<Container rotation="90"/>').firstElement(), 100, 100, false);
		var container = new ContainerBase(skinObj, null);
		
		assertEquals(Std.parseFloat("90"), container.rotation);
	}
	
	public function test_removeFromParent_true():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container name="container">' +
							'<Shape1 color="0xFFFFFF" name="shape1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		var skinnableViewCreator = new SkinnableViewCreator();
		var root = new Sprite();
		
		skinnableViewCreator.registerCustomDisplayObject("Shape1", Shape1);
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(root, "main", 100, 100);
		
		var container:ContainerBase = cast HelpersGlobal.getChildByName(root, "container");
		var shape1:Shape1 = cast cast HelpersGlobal.getChildByName(root, "container.shape1");
		
		//removeFromParent(true) must remove it from his parent + call removeFromParent(true) on children.
		container.removeFromParent(true);
		assertTrue(container.parent == null);
		assertEquals(0, container.numChildren);
		
		assertTrue(shape1.parent == null);
		assertTrue(shape1.disposeWasCalled);
	}
	
	public function test_removeFromParent_false():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container name="container">' +
							'<Shape1 color="0xFFFFFF" name="shape1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		var skinnableViewCreator = new SkinnableViewCreator();
		var root = new Sprite();
		
		skinnableViewCreator.registerCustomDisplayObject("Shape1", Shape1);
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(root, "main", 100, 100);
		
		var container:ContainerBase = cast HelpersGlobal.getChildByName(root, "container");
		var shape1:Shape1 = cast HelpersGlobal.getChildByName(root, "container.shape1");
		
		//removeFromParent(false) must remove it from his parent
		container.removeFromParent(false);
		assertTrue(container.parent == null);
		assertEquals(1, container.numChildren);
		
		assertFalse(shape1.parent == null);
		assertFalse(shape1.disposeWasCalled);
	}
	
	public function test_dispose():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container name="container">' +
							'<Shape1 color="0xFFFFFF" name="shape1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		var skinnableViewCreator = new SkinnableViewCreator();
		var root = new Sprite();
		
		skinnableViewCreator.registerCustomDisplayObject("Shape1", Shape1);
		skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		skinnableViewCreator.construct(root, "main", 100, 100);
		
		var container:ContainerBase = cast HelpersGlobal.getChildByName(root, "container");
		var shape1:Shape1 = cast cast HelpersGlobal.getChildByName(root, "container.shape1");
		
		//dispose must call removeFromParent(true) on children.
		container.dispose();
		assertFalse(container.parent == null);
		assertEquals(0, container.numChildren);
		
		assertTrue(shape1.parent == null);
		assertTrue(shape1.disposeWasCalled);
	}
}

class Shape1 extends ViewBase
{
	public var disposeWasCalled:Bool = false;
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) { super(skinObj, skinnableData); }
	
	override public function dispose():Void
	{
		disposeWasCalled = true;
		
		super.dispose();
	}
}