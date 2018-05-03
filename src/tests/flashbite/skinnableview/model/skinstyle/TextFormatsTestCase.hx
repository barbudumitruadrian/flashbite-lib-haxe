package tests.flashbite.skinnableview.model.skinstyle;

import flashbite.skinnableview.model.skinstyle.ITextFormats;
import flashbite.skinnableview.model.skinstyle.TextFormats;
import haxe.unit.TestCase;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * TestCase for TextFormats
 * 
 * @author Adrian Barbu
 */
@:final
class TextFormatsTestCase extends TestCase
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
	
	public function test_getTextFormat_checkProperties():Void
	{
		var xmlString = 
		'<textFormats>' +
			'<textFormat name="Museo_Slab_900_Regular_50_center_0x064413_0" color="0x064413" ' + 
			'font="Museo Slab 900" size="50" align="center" bold="false" italic="false" letterSpacing="0" underline="false" ' + 
			'kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' + 
		'</textFormats>';
		var xml = Xml.parse(xmlString).firstElement();
		var textFormats:ITextFormats = new TextFormats();
		textFormats.initialize(xml);
		
		var textFormat:TextFormat = textFormats.getTextFormat("Museo_Slab_900_Regular_50_center_0x064413_0");
		assertTrue(textFormat != null);
		assertEquals("Museo Slab 900", textFormat.font);
		assertEquals(50, textFormat.size);
		assertEquals(Std.parseInt("0x064413"), textFormat.color);
		assertEquals(false, textFormat.bold);
		assertEquals(false, textFormat.italic);
		assertEquals(false, textFormat.underline);
		assertTrue(textFormat.url == null);
		assertTrue(textFormat.target == null);
		assertEquals(TextFormatAlign.CENTER, textFormat.align);
		assertEquals(0, textFormat.leftMargin);
		assertEquals(0, textFormat.rightMargin);
		assertEquals(0, textFormat.indent);
		assertEquals(0, textFormat.leading);
		assertEquals(Std.parseFloat("0"), textFormat.letterSpacing);
		assertEquals(true, textFormat.kerning);
		assertEquals(0, textFormat.blockIndent);
		assertEquals(false, textFormat.bullet);
	}
	
	public function test_getTextFormat_clone_or_not():Void
	{
		var xmlString = 
		'<textFormats>' +
			'<textFormat name="Museo_Slab_900_Regular_50_center_0x064413_0" color="0x064413" ' + 
			'font="Museo Slab 900" size="50" align="center" bold="false" italic="false" letterSpacing="0" underline="false" ' + 
			'kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>' + 
		'</textFormats>';
		var xml = Xml.parse(xmlString).firstElement();
		var textFormats:ITextFormats = new TextFormats();
		textFormats.initialize(xml);
		
		//clone
		var textFormat_MuseoSlab1:TextFormat = textFormats.getTextFormat("Museo_Slab_900_Regular_50_center_0x064413_0");
		var textFormat_MuseoSlab2:TextFormat = textFormats.getTextFormat("Museo_Slab_900_Regular_50_center_0x064413_0");
		assertTrue(textFormat_MuseoSlab1 != textFormat_MuseoSlab2);
		
		//no clone
		textFormat_MuseoSlab1 = textFormats.getTextFormat("Museo_Slab_900_Regular_50_center_0x064413_0", false);
		textFormat_MuseoSlab2 = textFormats.getTextFormat("Museo_Slab_900_Regular_50_center_0x064413_0", false);
		assertTrue(textFormat_MuseoSlab1 == textFormat_MuseoSlab2);
	}
	
	public function test_getTextFormat_Fallback():Void
	{
		var xmlString = '<textFormats/>';
		var xml = Xml.parse(xmlString).firstElement();
		var textFormats:ITextFormats = new TextFormats();
		textFormats.initialize(xml);
		
		var textFormat = textFormats.getTextFormat("Museo_Slab_900_50_center_0x064413_0");
		assertTrue(textFormat != null);
		assertEquals("Museo Slab 900", textFormat.font);
		assertEquals(50, textFormat.size);
		assertEquals(Std.parseInt("0x064413"), textFormat.color);
		assertEquals(false, textFormat.bold);
		assertEquals(false, textFormat.italic);
		assertEquals(false, textFormat.underline);
		assertTrue(textFormat.url == null);
		assertTrue(textFormat.target == null);
		assertEquals(TextFormatAlign.CENTER, textFormat.align);
		assertEquals(0, textFormat.leftMargin);
		assertEquals(0, textFormat.rightMargin);
		assertEquals(0, textFormat.indent);
		assertEquals(0, textFormat.leading);
		assertEquals(Std.parseFloat("0"), textFormat.letterSpacing);
		assertEquals(false, textFormat.kerning);
		assertEquals(0, textFormat.blockIndent);
		assertEquals(false, textFormat.bullet);
	}
}