package tests.flashbite.skinnableview.view.button;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.button.SimpleButton;
import haxe.unit.TestCase;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.MouseEvent;

/**
 * TestCase for SimpleButton
 * 
 * @author Adrian Barbu
 */
@:final
class SimpleButtonTestCase extends TestCase
{
	private var _skinnableViewCreator:ISkinnableViewCreator;
	private var _container:Sprite;
	
	private var _styleXml:Xml;
	private var _styleXmlWrong:Xml;
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
		
		_skinnableViewCreator = new SkinnableViewCreator();
		_container = new Sprite();
		
		// ----------------------------------------------------------
		// _styleXml ok
		var styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container containerType="SimpleButton" name="button" x="center" y="center" alpha="1" width="25%" height="50%" scaleWhenDown="0.95" alphaWhenDisabled="0.75">' +
							'<Container name="contents" x="0" y="0" alpha="1" width="100%" height="100%">' +
								'<Shape width="100%" height="100%" color="0xFFFFFF" name="bg" x="0" y="0" alpha="1"/>' +
								'<Text content="" messageID="button" textFormat="Helvetica_LT_CondensedBlack_Regular_43_center_0x000000_0" width="100%" height="50%" name="txt" x="0" y="center" alpha="1"/>' +
							'</Container>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		_styleXml = Xml.parse(styleXmlString).firstElement();
		// ----------------------------------------------------------
		
		// ----------------------------------------------------------
		// _styleXml wrong
		styleXmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container containerType="SimpleButton" name="button" x="center" y="center" alpha="1" width="25%" height="50%" scaleWhenDown="0.95" alphaWhenDisabled="0.75">' +
							'<Shape width="100%" height="100%" color="0xFFFFFF" name="bg" x="0" y="0" alpha="1"/>' +
							'<Text content="" messageID="button" textFormat="Helvetica_LT_CondensedBlack_Regular_43_center_0x000000_0" width="100%" height="50%" name="txt" x="0" y="center" alpha="1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		_styleXmlWrong = Xml.parse(styleXmlString).firstElement();
		// ----------------------------------------------------------
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
		
		_skinnableViewCreator = null;
		_container = null;
		_styleXml = _styleXmlWrong = null;
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	public function test_creationAndInitialization():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var button:SimpleButton = cast HelpersGlobal.getChildByName(_container, "button");
		assertTrue(button != null);
		
		button.initialize(true, 1);
		assertTrue(button.hasEventListener(MouseEvent.MOUSE_DOWN));
		assertEquals(Std.parseFloat("1"), button.defaultScale);
		assertEquals(true, button.enabled);
	}
	
	public function test_enabling_disabling():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var button:SimpleButton = cast HelpersGlobal.getChildByName(_container, "button");
		assertTrue(button != null);
		
		button.initialize(true, 1);
		assertTrue(button.hasEventListener(MouseEvent.MOUSE_DOWN));
		assertEquals(true, button.enabled);
		
		button.enabled = false;
		assertFalse(button.hasEventListener(MouseEvent.MOUSE_DOWN));
		assertEquals(false, button.enabled);
	}
	
	public function test_creationNOK():Void
	{
		_skinnableViewCreator.initialize(_styleXmlWrong, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var button:SimpleButton = cast HelpersGlobal.getChildByName(_container, "button");
		assertTrue(button != null);
		
		var errorThrown:Bool = false;
		try {
			button.initialize(true, 1);
		} catch (e:Error) {
			errorThrown = true;
		}
		
		assertTrue(errorThrown);
	}
}