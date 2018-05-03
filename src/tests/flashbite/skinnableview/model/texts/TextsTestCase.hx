package tests.flashbite.skinnableview.model.texts;

import flashbite.helpers.HelpersXml;
import flashbite.skinnableview.model.texts.ITexts;
import flashbite.skinnableview.model.texts.Texts;
import haxe.unit.TestCase;

/**
 * TestCase for Texts
 * 
 * @author Adrian Barbu
 */
@:final
class TextsTestCase extends TestCase
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
	
	public function test_getTextByID():Void
	{
		var textsXmlString = 
		'<texts>' +
			'<text id="textNormal" Def="Initializing" en="Initializing EN" fr="Initializing FR"/>' + 
			'<text id="textBtn" Def="Text Btn" en="Text Btn EN" fr="Text Btn EN"/>' +
		'</texts>';
		
		var textsXml:Xml = Xml.parse(textsXmlString);
		var texts:ITexts = new Texts();
		texts.initialize("", textsXml.firstElement());
		
		//default
		var numTexts:Int = 0;
		textsXml = HelpersXml.getChildrenWithNodeName(textsXml, "texts")[0];
		var textsXmls = HelpersXml.getChildrenWithNodeName(textsXml, "text");
		for (textXml in textsXmls) {
			var idFromXml = textXml.get("id");
			var Def_ValueFromXml = textXml.get("Def");
			var en_ValueFromXml = textXml.get("en");
			var fr_ValueFromXml = textXml.get("fr");
			
			assertTrue(texts.getTextByID(idFromXml) != "");
			
			assertEquals(Def_ValueFromXml, texts.getTextByID(idFromXml, false, null));
			assertEquals(Def_ValueFromXml.toUpperCase(), texts.getTextByID(idFromXml, true, null));
			
			assertEquals(en_ValueFromXml, texts.getTextByID(idFromXml, false, "en"));
			assertEquals(en_ValueFromXml.toUpperCase(), texts.getTextByID(idFromXml, true, "en"));
			
			assertEquals(fr_ValueFromXml, texts.getTextByID(idFromXml, false, "fr"));
			assertEquals(fr_ValueFromXml.toUpperCase(), texts.getTextByID(idFromXml, true, "fr"));
			
			numTexts++;
		}
		assertTrue(numTexts > 0);
		
		//en
		texts.setLanguage("en");
		for (textXml in textsXmls) {
			var idFromXml = textXml.get("id");
			var en_ValueFromXml = textXml.get("en");
			assertEquals(en_ValueFromXml, texts.getTextByID(idFromXml));
		}
	}
}