package tests.flashbite.skinnableview;

import flashbite.helpers.HelpersGlobal;
import flashbite.helpers.HelpersXml;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import haxe.unit.TestCase;
import openfl.display.Sprite;

/**
 * TestCase for SkinnableViewCreator, resize zone
 * those tests are to expose the resize and redraw on multiple containers
 * 
 * @author Adrian Barbu
 */
@:final
class SkinnableViewCreator_RESIZE_propagation_TestCase extends TestCase
{
	private var _skinnableViewCreator:ISkinnableViewCreator;
	private var _container:Sprite;
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
		
		_skinnableViewCreator = new SkinnableViewCreator();
		_container = new Sprite();
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
		
		_skinnableViewCreator = null;
		_container = null;
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	private function getMainScreenChildrenXml(styleXml:Xml):Array<Xml>
	{
		var screensXml = HelpersXml.getChildrenWithNodeName(styleXml, "screens")[0];
		var mainScreenXml = screensXml.firstChild(); //main
		var screenStyleXml = HelpersXml.getChildrenWithNodeName(mainScreenXml, "style")[0];
		return HelpersXml.getChildren(screenStyleXml);
	}
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// textField
	/** this is a test case to expose a change in a container his internal textfields that, after a resize will have their text reset */
	public function test_checkText_onResize():Void
	{
		var styleXmlString = 
		'<style>' +
			'<texts>' +
				'<text id="numOrdersTxt" Def="{numOrders} ORDERS"/>' +
			'</texts>' +
			'<textFormats/>' +
			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container containerType="container" name="container" x="0" y="0" alpha="1" width="500" height="80">' +
							'<Text content="" messageID="numOrdersTxt" textFormat="Helvetica_LT_CondensedBlack_Regular_28_center_0xFFFFFF_0" width="161" height="39" name="numOrdersTxt" x="0" y="13" alpha="1"/>' +
							'<Container name="subContainer" x="0" y="0" alpha="1" width="500" height="80">' +
								'<Text content="" messageID="numOrdersTxt" textFormat="Helvetica_LT_CondensedBlack_Regular_28_center_0xFFFFFF_0" width="161" height="39" name="numOrdersTxt" x="0" y="13" alpha="1"/>' +
							'</Container>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		var styleXml = Xml.parse(styleXmlString).firstElement();
		
		_skinnableViewCreator.registerCustomDisplayObjectContainer("Container", Container);
		_skinnableViewCreator.initialize(styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		var textToShow = _skinnableViewCreator.skinnableData.getTextByID("numOrdersTxt").split("{numOrders}").join(Std.string(Container.NUM_ORDERS));
		
		var containerToTest:Container = cast HelpersGlobal.getChildByName(_container, "container");
		containerToTest.initialize();
		
		var textField1:TextFieldSkinnable = containerToTest.textField1;
		var textField2:TextFieldSkinnable = containerToTest.textField2;
		
		assertEquals(textToShow, textField1.text);
		assertEquals(textToShow, textField2.text);
		
		_skinnableViewCreator.resize(_container, "main", 200, 200);
		//check after resize
		assertEquals(textToShow, textField1.text);
		assertEquals(textToShow, textField2.text);
	}
}
class Container extends ContainerBase
{
	public static inline var NUM_ORDERS:Int = 10;
	
	public var textField1:TextFieldSkinnable;
	public var textField2:TextFieldSkinnable;
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) { super(skinObj, skinnableData); }
	
	public function initialize():Void
	{
		textField1 = cast HelpersGlobal.getChildByName(this, "numOrdersTxt");
		textField2 = cast HelpersGlobal.getChildByName(this, "subContainer.numOrdersTxt");
		
		updateTexts();
	}
	
	override public function redraw():Void
	{
		super.redraw();
		
		updateTexts();
	}
	
	private function updateTexts():Void
	{
		if (textField1 != null && textField2 != null) {
			textField1.setText(textField1.getInitialText().split("{numOrders}").join(Std.string(NUM_ORDERS)));
			textField2.setText(textField2.getInitialText().split("{numOrders}").join(Std.string(NUM_ORDERS)));
		}
	}
}