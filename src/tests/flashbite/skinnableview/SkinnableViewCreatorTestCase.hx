package tests.flashbite.skinnableview;

import flashbite.helpers.HelpersXml;
import flashbite.logger.Logger;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.ElementType;
import flashbite.skinnableview.view.ViewBase;
import haxe.unit.TestCase;
import openfl.display.Sprite;
import openfl.text.TextField;

/**
 * TestCase for SkinnableViewCreator
 * 
 * @author Adrian Barbu
 */
@:final
class SkinnableViewCreatorTestCase extends TestCase
{
	private var _skinnableViewCreator:ISkinnableViewCreator;
	private var _container:Sprite;
	
	private var _styleXml:Xml;
	private var _styleXmlWithCustomDisplayObject:Xml;
	private var _styleXmlWithCustomDisplayObjectContainer:Xml;
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	public function new() { super(); }
	
	override public function setup():Void
	{
		super.setup();
		
		_skinnableViewCreator = new SkinnableViewCreator();
		_container = new Sprite();
		
		// ----------------------------------------------------------
		// _styleXml
		var styleXmlString = 
		'<style>' +
			'<texts>' +
				'/n' +
				'<text id="textNormal" Def="Initializing" en="Initializing EN" fr="Initializing FR"/>' +
				'<text id="textBtn" Def="Text Btn" en="Text Btn EN" fr="Text Btn EN"/>' +
				'/n' +
			'</texts>' +
			
			'<textFormats>' +
				'/n' +
				'<textFormat name="Museo_Slab_700_Regular_50_center_0x339933_5" color="0x339933" font="Museo Slab 700" size="50" align="center" bold="false" italic="false" letterSpacing="5" underline="false" kerning="true" leading="10" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' +
				'<textFormat name="Museo_Slab_700_Regular_55_center_0x000000_0" color="0x000000" font="Museo Slab 700" size="55" align="center" bold="false" italic="false" letterSpacing="0" underline="false" kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' +
				'/n' +
			'</textFormats>' +

			'<screens>' +
				'<screen name="main">' +
					'/n' +
					'<style>' +
						'<Image fileName="bg" width="1024" height="329" name="bg" x="0" y="0" alpha="1"/>' +
						'<Text content="" messageID="textNormal" textFormat="Museo_Slab_700_Regular_50_center_0x339933_5" width="420" height="160" name="txt" x="563" y="410" alpha="1"/>' +
						'<Text content="textNormal" messageID="" textFormat="Museo_Slab_700_Regular_50_center_0x339933_5" width="420" height="160" name="txt2" x="563" y="410" alpha="1"/>' +
						'<Text content="" messageID="textNormal" textFormat="Museo_Slab_700_Regular_50_center_0x339933_5" width="50" height="10" name="txt3" x="563" y="410" alpha="1" truncate="true"/>' +
						'<Text content="" messageID="textNormal" textFormat="Museo_Slab_700_Regular_50_center_0x339933_5" width="50" height="10" name="txt4" x="563" y="410" alpha="1" truncate="false"/>' +
						'<Text content="textNormal" messageID="textNormalUnavailable" textFormat="Museo_Slab_700_Regular_50_center_0x339933_5" width="10" height="10" name="txt5" x="563" y="410" alpha="1" truncate="false"/>' +
						'<Container containerType="" name="btnWithText" x="50" y="363" alpha="1">' +
							'<Image fileName="border" width="324" height="323" name="border" x="0" y="0" alpha="1"/>' +
							'<Text content="" messageID="" textFormat="Museo_Slab_700_Regular_55_center_0x000000_0" width="324" height="160" name="txt" x="0" y="100" alpha="1"/>' +
						'</Container>' +
						'<Container containerType="" name="btnWithFilter" x="890.25" y="616.4" alpha="1" filter="starling_drop_shadow_8_0.7853851318359375_0x000000_1_5_1">' +
							'<Image fileName="btn" width="95" height="95" name="btn" x="0" y="0" alpha="1"/>' +
						'</Container>' +
						'<Image fileName="btnnnnnnnn" width="95" height="95" name="btn" x="550.05" y="631.1" alpha="1"/>' +
					'</style>' +
					'/n' +
				'</screen>' +
			'</screens>' +
		'</style>';
		_styleXml = Xml.parse(styleXmlString).firstElement();
		// ----------------------------------------------------------
		
		// ----------------------------------------------------------
		// _styleXmlWithCustomDisplayObject
		var styleXmlWithCustomDisplayObjectString = 
		'<style>' +
			'<texts>' +
				'<text id="textNormal" Def="Initializing" en="Initializing EN" fr="Initializing FR"/>' +
				'<text id="textBtn" Def="Text Btn" en="Text Btn EN" fr="Text Btn EN"/>' +
			'</texts>' +
			
			'<textFormats>' +
				'<textFormat name="Museo_Slab_700_Regular_50_center_3381555_5" color="0x339933" font="Museo Slab 700" size="50" align="center" bold="false" italic="false" letterSpacing="5" underline="false" kerning="true" leading="10" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' +
				'<textFormat name="Museo_Slab_700_Regular_55_center_0_0" color="0x000000" font="Museo Slab 700" size="55" align="center" bold="false" italic="false" letterSpacing="0" underline="false" kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' +
			'</textFormats>' +

			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<ImageNew fileName="btnnnnnnnn" width="95" height="95" name="btn" x="550.05" y="631.1" alpha="1"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		_styleXmlWithCustomDisplayObject = Xml.parse(styleXmlWithCustomDisplayObjectString).firstElement();
		// ----------------------------------------------------------
		
		// ----------------------------------------------------------
		// _styleXmlWithCustomDisplayObjectContainer
		var styleXmlWithCustomDisplayObjectContainerString = 
		'<style>' +
			'<texts>' +
				'<text id="textNormal" Def="Initializing" en="Initializing EN" fr="Initializing FR"/>' +
				'<text id="textBtn" Def="Text Btn" en="Text Btn EN" fr="Text Btn EN"/>' +
			'</texts>' +
			
			'<textFormats>' +
				'<textFormat name="Museo_Slab_700_Regular_50_center_3381555_5" color="0x339933" font="Museo Slab 700" size="50" align="center" bold="false" italic="false" letterSpacing="5" underline="false" kerning="true" leading="10" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' +
				'<textFormat name="Museo_Slab_700_Regular_55_center_0_0" color="0x000000" font="Museo Slab 700" size="55" align="center" bold="false" italic="false" letterSpacing="0" underline="false" kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' +
			'</textFormats>' +

			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container containerType="ImageNew" name="btnWithFilter" x="890.25" y="616.4" alpha="1">' +
							'<Image fileName="btn" width="95" height="95" name="btn" x="0" y="0" alpha="1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		_styleXmlWithCustomDisplayObjectContainer = Xml.parse(styleXmlWithCustomDisplayObjectContainerString).firstElement();
		// ----------------------------------------------------------
	}
	
	override public function tearDown():Void
	{
		super.tearDown();
		
		_skinnableViewCreator = null;
		_container = null;
		_styleXml = _styleXmlWithCustomDisplayObject = _styleXmlWithCustomDisplayObjectContainer = null;
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// construct
	public function test_construct():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		//make sure all children are created
		var screensXml = HelpersXml.getChildrenWithNodeName(_styleXml, "screens")[0];
		var mainScreenXml = screensXml.firstChild(); //main
		var screenStyleXml = HelpersXml.getChildrenWithNodeName(mainScreenXml, "style")[0];
		var styleChildren = HelpersXml.getChildren(screenStyleXml);
		
		assertEquals(styleChildren.length, _container.numChildren);
		
		var numChildrenPassed:Int = 0;
		//now check if each child has the correct type
		for (childXml in styleChildren) {
			var childXmlName = childXml.get("name");
			var childNodeName = childXml.nodeName;
			var childView = _container.getChildByName(childXmlName);
			
			//make sure we create the child
			assertTrue(childView != null);
			
			var clazz:Dynamic = ElementType.getClass(childNodeName);
			
			//make sure we create the child correctly
			if (childNodeName == ElementType.CONTAINER) {
				var containerType:String = childXml.get("containerType");
				
				if (containerType != "") { //here we don't have a custom container
					assertTrue(false);
				} else {
					assertTrue(Std.is(childView, clazz));
				}
			} else {
				assertTrue(Std.is(childView, clazz));
			}
				
			numChildrenPassed++;
		}
		
		assertEquals(styleChildren.length, numChildrenPassed);
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// constructChild
	public function test_constructChild():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		
		var screensXml = HelpersXml.getChildrenWithNodeName(_styleXml, "screens")[0];
		var mainScreenXml = screensXml.firstChild(); //main
		var screenStyleXml = HelpersXml.getChildrenWithNodeName(mainScreenXml, "style")[0];
		var childXml = HelpersXml.getChildren(screenStyleXml)[0];
		
		_skinnableViewCreator.constructChild(_container, "main", childXml.get("name"), 100, 100);
		
		//make sure we created 1 child on container
		assertEquals(1, _container.numChildren);
		
		var childXmlName = childXml.get("name");
		var childNodeName = childXml.nodeName;
		var childView = _container.getChildByName(childXmlName);
		
		//make sure we create the child
		assertTrue(childView != null);
		
		var clazz:Dynamic = ElementType.getClass(childNodeName);
			
		//make sure we create the child correctly
		if (childNodeName == ElementType.CONTAINER) {
			var containerType:String = childXml.get("containerType");
			
			if (containerType != "") { //here we don't have a custom container
				assertTrue(false);
			} else {
				assertTrue(Std.is(childView, clazz));
			}
		} else {
			assertTrue(Std.is(childView, clazz));
		}
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// register
	public function test_registerCustomDisplayObject():Void
	{
		//make sure we registered ok
		var registeredOk = _skinnableViewCreator.registerCustomDisplayObject("ImageNew", SkinnableCustomDisplayObjectFail);
		assertTrue(registeredOk);
		
		//make sure override is working
		registeredOk = _skinnableViewCreator.registerCustomDisplayObject("ImageNew", SkinnableCustomDisplayObjectFail, true);
		assertTrue(registeredOk);
	}
	
	public function test_registerCustomDisplayObjectFailNoRegistration():Void
	{
		_skinnableViewCreator.initialize(_styleXmlWithCustomDisplayObject, null, null, "", 100, 100);
		
		//make sure we fail the construct
		var error = false;
		try {
			_skinnableViewCreator.construct(_container, "main", 100, 100);
		} catch (e:Dynamic) {
			Logger.error(this, e);
			error = true;
		}
		assertTrue(error);
	}
	
	public function test_registerCustomDisplayObjectFail():Void
	{
		_skinnableViewCreator.initialize(_styleXmlWithCustomDisplayObject, null, null, "", 100, 100);
		
		var registeredOk = _skinnableViewCreator.registerCustomDisplayObject("ImageNew", SkinnableCustomDisplayObjectFail);
		assertTrue(registeredOk);
		
		//make sure we fail the construct
		var error = false;
		try {
			_skinnableViewCreator.construct(_container, "main", 100, 100);
		} catch (e:Dynamic) {
			Logger.error(this, e);
			error = true;
		}
		assertTrue(error);
	}
	
	public function test_registerCustomDisplayObjectCorrect():Void
	{
		_skinnableViewCreator.initialize(_styleXmlWithCustomDisplayObject, null, null, "", 100, 100);
		var registeredOk = _skinnableViewCreator.registerCustomDisplayObject("ImageNew", SkinnableCustomDisplayObjectCorrect);
		assertTrue(registeredOk);
		
		//make sure we don't fail the construct
		var error = false;
		try {
			_skinnableViewCreator.construct(_container, "main", 100, 100);
		} catch (e:Dynamic) {
			Logger.error(this, e);
			error = true;
		}
		assertFalse(error);
	}
	
	public function test_registerCustomDisplayObjectContainer():Void
	{
		//make sure we registered ok
		var registeredOk = _skinnableViewCreator.registerCustomDisplayObjectContainer("ImageNew", SkinnableCustomDisplayObjectContainerFail);
		assertTrue(registeredOk);
		
		//make sure override is working
		registeredOk = _skinnableViewCreator.registerCustomDisplayObjectContainer("ImageNew", SkinnableCustomDisplayObjectContainerFail, true);
		assertTrue(registeredOk);
	}
	
	public function test_registerCustomDisplayObjectContainerNoRegistration():Void
	{
		_skinnableViewCreator.initialize(_styleXmlWithCustomDisplayObjectContainer, null, null, "", 100, 100);
		
		//make sure we fail the construct
		var error = false;
		try {
			_skinnableViewCreator.construct(_container, "main", 100, 100);
		} catch (e:Dynamic) {
			Logger.error(this, e);
			error = true;
		}
		assertTrue(error);
	}
	
	public function test_registerCustomDisplayObjectContainerFail():Void
	{
		_skinnableViewCreator.initialize(_styleXmlWithCustomDisplayObjectContainer, null, null, "", 100, 100);
		
		var registeredOk = _skinnableViewCreator.registerCustomDisplayObjectContainer("ImageNew", SkinnableCustomDisplayObjectContainerFail);
		assertTrue(registeredOk);
		
		//make sure we fail the construct
		var error = false;
		try {
			_skinnableViewCreator.construct(_container, "main", 100, 100);
		} catch (e:Dynamic) {
			Logger.error(this, e);
			error = true;
		}
		assertTrue(error);
	}
	
	public function test_registerCustomDisplayObjectContainerCorrect():Void
	{
		_skinnableViewCreator.initialize(_styleXmlWithCustomDisplayObjectContainer, null, null, "", 100, 100);
		
		var registeredOk = _skinnableViewCreator.registerCustomDisplayObjectContainer("ImageNew", SkinnableCustomDisplayObjectContainerCorrect);
		assertTrue(registeredOk);
		
		//make sure we don't fail the construct
		var error = false;
		try {
			_skinnableViewCreator.construct(_container, "main", 100, 100);
		} catch (e:Dynamic) {
			Logger.error(this, e);
			error = true;
		}
		assertFalse(error);
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
	
	public function test_getSkinnableData():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		
		assertTrue(_skinnableViewCreator.skinnableData != null);
	}
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// language
	public function test_getSet_Language():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "en", 100, 100);
		
		assertEquals("en", _skinnableViewCreator.language);
		
		_skinnableViewCreator.language = "fr";
		assertEquals("fr", _skinnableViewCreator.language);
	}
	
	public function test_updateLanguageOn():Void
	{
		_skinnableViewCreator.initialize(_styleXml, null, null, "", 100, 100);
		_skinnableViewCreator.construct(_container, "main", 100, 100);
		
		//styleXml : <Text content="" messageID="textNormal" textFormat="Museo_Slab_700_Regular_50_center_0x339933_5" width="420" height="160" name="txt" x="563" y="410" alpha="1"/>
		//textsXml : <text id="textNormal" Def="Initializing" en="Initializing EN" fr="Initializing FR"/>
		
		var tf = cast (_container.getChildByName("txt"), TextField);
		//make sure if we don't set language, we use "Def"
		assertEquals("Initializing", tf.text);
		
		_skinnableViewCreator.language = "fr";
		_skinnableViewCreator.updateLanguageOn(_container);
		//check if text is the same as in textsXml
		assertEquals("Initializing FR", tf.text);
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
}

class SkinnableCustomDisplayObjectFail extends Sprite
{
	public function new() { super(); }
}

class SkinnableCustomDisplayObjectCorrect extends ViewBase
{
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) { super(skinObj, skinnableData); }
}

class SkinnableCustomDisplayObjectContainerFail extends Sprite
{
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) { super(); }
}

class SkinnableCustomDisplayObjectContainerCorrect extends ContainerBase
{
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) { super(skinObj, skinnableData); }
}