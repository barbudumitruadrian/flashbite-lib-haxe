package tests.flashbite.skinnableview.model;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.SkinnableData;
import haxe.unit.TestCase;

/**
 * TestCase for SkinnableData
 * 
 * @author Adrian Barbu
 */
@:final
class SkinnableDataTestCase extends TestCase
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
	
	public function test_functions():Void
	{
		var xmlString = 
		'<style>' +
			'<texts>' +
				'<text id="titleID" Def="HelloDef" en="Hello" fr="Salut"/>' +
			'</texts>' +
			
			'<textFormats>' +
				'<textFormat name="Museo_Slab_900_Regular_50_center_0x064413_0" color="0x064413" font="Museo Slab 900" size="50" align="center" bold="false" italic="false" letterSpacing="0" underline="false" kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' +
			'</textFormats>' +

			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Shape width="1000" height="1520" color="0xFFFFFF" name="" x="0" y="0" alpha="1"/>' +
						'<Text content="" messageID="titleID" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" width="780" height="250" name="titleTxt" x="150" y="50" alpha="1"/>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var styleXml = Xml.parse(xmlString).firstElement();
		
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(styleXml, null, null, "en", 100, 100);
		
		assertEquals("en", skinnableData.language);
		//getTextByID
		assertEquals("Hello", skinnableData.getTextByID("titleID"));
		skinnableData.language = "fr";
		assertEquals("Salut", skinnableData.getTextByID("titleID"));
		skinnableData.language = "";
		assertEquals("HelloDef", skinnableData.getTextByID("titleID"));
		
		//textFormat
		var textFormat = skinnableData.getTextFormat("Museo_Slab_900_Regular_50_center_0x064413_0");
		assertTrue(textFormat != null);
		assertEquals("Museo Slab 900", textFormat.font);
		
		//screen skin obj
		var screenSkinObj = skinnableData.getSkinObject("main");
		assertTrue(screenSkinObj != null);
		assertEquals(2, screenSkinObj.children.length);
		assertEquals("Shape", screenSkinObj.children[0].type);
		assertEquals("Text", screenSkinObj.children[1].type);
		
		//null skin obj
		var screenSkinObjNull = skinnableData.getSkinObject("not_a_valid_screen_name");
		assertTrue(screenSkinObjNull == null);
	}
	
	public function test_template_OK():Void
	{
		var xmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +

			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container containerType="" name="goal0" x="center" y="top" alpha="1" width="100%" height="32%" template="goalViewTemplate"/>' +
					'</style>' +
				'</screen>' +
				
				'<screen name="TEMPLATE">' +
					'<style>' +
						'<Container containerType="" name="goalViewTemplate" x="0" y="0" alpha="0" width="100%" height="100%">' +
							'<Shape width="500" height="80" color="0xFFFFFF" name="" x="0" y="0" alpha="1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var styleXml = Xml.parse(xmlString).firstElement();
		
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(styleXml, null, null, "en", 100, 100);
		
		var mainSkinObj = skinnableData.getSkinObject("main");
		assertEquals(1, mainSkinObj.children.length);
		var container = mainSkinObj.children[0];
		assertEquals(1, container.children.length);
	}
	
	public function test_template_notFound_1():Void
	{
		var xmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +

			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container containerType="" name="goal0" x="center" y="top" alpha="1" width="100%" height="32%" template="wrongTemplateName"/>' +
					'</style>' +
				'</screen>' +
				
				'<screen name="TEMPLATE">' +
					'<style>' +
						'<Container containerType="" name="goalViewTemplate" x="0" y="0" alpha="0" width="100%" height="100%">' +
							'<Shape width="500" height="80" color="0xFFFFFF" name="" x="0" y="0" alpha="1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var styleXml = Xml.parse(xmlString).firstElement();
		
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(styleXml, null, null, "en", 100, 100);
		
		var mainSkinObj = skinnableData.getSkinObject("main");
		assertEquals(1, mainSkinObj.children.length);
		var container = mainSkinObj.children[0];
		assertEquals(0, container.children.length);
	}
	
	public function test_template_notFound_2():Void
	{
		var xmlString = 
		'<style>' +
			'<texts/>' +
			'<textFormats/>' +

			'<screens>' +
				'<screen name="main">' +
					'<style>' +
						'<Container containerType="" name="goal0" x="center" y="top" alpha="1" width="100%" height="32%" template="goalViewTemplate"/>' +
					'</style>' +
				'</screen>' +
				
				'<screen name="TEMPLATE">' +
					'<style>' +
						'<Container containerType="" name="goalViewTemplate_renamed" x="0" y="0" alpha="0" width="100%" height="100%">' +
							'<Shape width="500" height="80" color="0xFFFFFF" name="" x="0" y="0" alpha="1"/>' +
						'</Container>' +
					'</style>' +
				'</screen>' +
			'</screens>' +
		'</style>';
		
		var styleXml = Xml.parse(xmlString).firstElement();
		
		var skinnableData:ISkinnableData = new SkinnableData();
		skinnableData.initialize(styleXml, null, null, "en", 100, 100);
		
		var mainSkinObj = skinnableData.getSkinObject("main");
		assertEquals(1, mainSkinObj.children.length);
		var container = mainSkinObj.children[0];
		assertEquals(0, container.children.length);
	}
}