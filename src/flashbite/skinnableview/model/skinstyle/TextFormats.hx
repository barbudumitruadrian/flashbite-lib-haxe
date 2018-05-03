package flashbite.skinnableview.model.skinstyle;

import flashbite.helpers.HelpersGlobal;
import flashbite.helpers.HelpersXml;
import flashbite.interfaces.IDisposable;
import flashbite.logger.Logger;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * TextFormats class; used to hold all text formats
 * xml example:
 * <textFormats>
 * 		<textFormat name="Museo_Slab_900_Regular_50_center_0x064413_0" color="0x064413" font="Museo Slab 900" size="50" align="center" bold="false" italic="false" letterSpacing="0" underline="false" kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>
 * </textFormats>
 * 
 * @author Adrian Barbu
 */
@:final
class TextFormats implements ITextFormats implements IDisposable
{
	private var _database:Map<String, TextFormat> = new Map<String, TextFormat>();
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new() {}
	
	public function dispose():Void
	{
		_database = null;
	}
	
	// =====================================================================================================================================
	// ITextFormats
	// =====================================================================================================================================
	
	public function initialize(xml:Xml):Void 
	{
		var textFormatsXmlList = HelpersXml.getChildrenWithNodeName(xml, "textFormat");
		for (textFormatXml in textFormatsXmlList) {
			readAndStoreTextFormat(textFormatXml);
		}
	}
	
	public function getTextFormat(textFormatName:String, copy:Bool = true):TextFormat 
	{
		if (_database.exists(textFormatName) == false) {
			createAndStoreFallbackTextFormat(textFormatName);
			Logger.warning(this, "created FallbackTextFormat = " + textFormatName);
		}
		
		var textFormat = _database.get(textFormatName);
		
		return copy ? textFormatClone(textFormat) : textFormat;
	}
	
	// =====================================================================================================================================
	// PRIVATE
	// =====================================================================================================================================
	
	private function readAndStoreTextFormat(xml:Xml):TextFormat
	{
		var obj = HelpersXml.toObject(xml);
		var textFormatName:String = HelpersGlobal.getCaseInsensitivePropValue(obj, "name", "_DEFAULT_");
		
		var font:String = cast HelpersGlobal.getCaseInsensitivePropValue(obj, "font", "Arial");
		var size:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "size", "30"));
		var color:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "color", "0xFFFFFF"));
		var bold:Bool = HelpersGlobal.translateToBoolean(HelpersGlobal.getCaseInsensitivePropValue(obj, "bold", false));
		var italic:Bool = HelpersGlobal.translateToBoolean(HelpersGlobal.getCaseInsensitivePropValue(obj, "italic", false));
		var align:String = HelpersGlobal.getCaseInsensitivePropValue(obj, "align", "left", ["left", "right", "center"]);
		var leading:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "leading", "0"));
		var letterSpacing:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "letterSpacing", "0"));
		var kerning:Bool = HelpersGlobal.translateToBoolean(HelpersGlobal.getCaseInsensitivePropValue(obj, "kerning", false));
		var blockIndent:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "blockIndent", "0"));
		var bullet:Bool = HelpersGlobal.translateToBoolean(HelpersGlobal.getCaseInsensitivePropValue(obj, "bullet", false));
		var underline:Bool = HelpersGlobal.translateToBoolean(HelpersGlobal.getCaseInsensitivePropValue(obj, "underline", false));
		var url:String = HelpersGlobal.getCaseInsensitivePropValue(obj, "url");
		var target:String = HelpersGlobal.getCaseInsensitivePropValue(obj, "target");
		var leftMargin:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "leftMargin", "0"));
		var rightMargin:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "rightMargin", "0"));
		var indent:Int = Std.parseInt(HelpersGlobal.getCaseInsensitivePropValue(obj, "indent", "0"));
		
		var textFormat = new TextFormat(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);
		textFormat.letterSpacing = letterSpacing;
		textFormat.kerning = kerning;
		textFormat.blockIndent = blockIndent;
		textFormat.bullet = bullet;
		
		_database.set(textFormatName, textFormat);
		
		return textFormat;
	}
	
	private function textFormatClone(textFormat:TextFormat):TextFormat
	{
		var cloneTextFormat = new TextFormat(textFormat.font, textFormat.size, textFormat.color, textFormat.bold, textFormat.italic, 
											textFormat.underline, textFormat.url, textFormat.target, 
											textFormat.align, textFormat.leftMargin, textFormat.rightMargin, textFormat.indent, textFormat.leading);
		cloneTextFormat.letterSpacing = textFormat.letterSpacing;
		cloneTextFormat.kerning = textFormat.kerning;
		cloneTextFormat.blockIndent = textFormat.blockIndent;
		cloneTextFormat.bullet = textFormat.bullet;
		
		return cloneTextFormat;
	}
	
	private function createAndStoreFallbackTextFormat(textFormatName:String):Void
	{
		var font:String = "Arial";
		var size:Int = 30;
		var color:Int = 0xFFFFFF;
		var bold:Bool = false;
		var italic:Bool = false;
		var align:String = TextFormatAlign.LEFT;
		var leading:Int = 0;
		var letterSpacing:Int = 0;
		var kerning:Bool = false;
		var blockIndent:Int = 0;
		var bullet:Bool = false;
		var underline:Bool = false;
		var url:String = null;
		var target:String = null;
		var leftMargin:Int = 0;
		var rightMargin:Int = 0;
		var indent:Int = 0;
		
		//intelligent creation for an example like this : "Museo_Slab_900_50_center_0x064413_0"
		var nameSplit = textFormatName.split("_");
		if (nameSplit.length >= 3) {
			//letter spacing
			var letterSpacingFromArray:String = nameSplit[nameSplit.length - 1];
			if (letterSpacingFromArray != "") { //ok
				letterSpacing = Std.parseInt(nameSplit.pop());
			}
			//color
			var colorFromArray:String = nameSplit[nameSplit.length - 1];
			colorFromArray = colorFromArray.indexOf("0x") == 0 ? colorFromArray : "0x" + colorFromArray;
			if (colorFromArray != "") { //ok
				color = Std.parseInt(colorFromArray);
				nameSplit.pop();
			}
			//align
			var alignFromArray:String = nameSplit[nameSplit.length - 1];
			if (alignFromArray == TextFormatAlign.LEFT || alignFromArray == TextFormatAlign.RIGHT || alignFromArray == TextFormatAlign.CENTER) { //ok
				align = nameSplit.pop();
			}
			//size
			var sizeFromArray = nameSplit[nameSplit.length - 1];
			if (sizeFromArray != "") { //ok
				size = Std.parseInt(nameSplit.pop());
			}
			//bold-italic
			if (nameSplit.length >= 2) {
				//bold-italic
				var propBoldItalic:String = nameSplit[nameSplit.length-1];
				if (propBoldItalic == "Bold") {
					bold = true;
					nameSplit.pop();
				}
				else if (propBoldItalic == "Oblique") {
					italic = true;
					nameSplit.pop();
				}
			}

			//name
			if (nameSplit.length != 0) {
				if (nameSplit.length > 1) {
					font = nameSplit.join(" ");
				}
				else if (nameSplit.length == 1) {
					font = nameSplit[0];
				}
			}
		}

		var fallbackTextFormat = new TextFormat(font, size, color, bold, italic, underline, url, target, align, leftMargin, rightMargin, indent, leading);
		fallbackTextFormat.letterSpacing = letterSpacing;
		fallbackTextFormat.kerning = kerning;
		fallbackTextFormat.blockIndent = blockIndent;
		fallbackTextFormat.bullet = bullet;
		
		_database.set(textFormatName, fallbackTextFormat);
	}
}