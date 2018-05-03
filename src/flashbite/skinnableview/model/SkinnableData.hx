package flashbite.skinnableview.model;

import flashbite.helpers.HelpersString;
import flashbite.helpers.HelpersXml;
import flashbite.interfaces.IDisposable;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.model.skinstyle.ITextFormats;
import flashbite.skinnableview.model.skinstyle.SkinObject;
import flashbite.skinnableview.model.skinstyle.TextFormats;
import flashbite.skinnableview.model.texts.ITexts;
import flashbite.skinnableview.model.texts.Texts;
import openfl.text.TextFormat;

/**
 * SkinnableData holds a model representation of a style xml
 * style xml example:
 * <style>
 * 		<texts>
 * 			<text id="titleID" Def="Hello"/>
 * 		</texts>
 * 
 * 		<textFormats>
 * 			<textFormat name="Museo_Slab_900_Regular_50_center_0x064413_0" color="0x064413" font="Museo Slab 900" size="50" align="center" bold="false" italic="false" letterSpacing="0" underline="false" kerning="true" leading="0" leftMargin="0" rightMargin="0" blockIndent="0" indent="0" bullet="false"/>
 * 		</textFormats>
 * 
 * 		<screens>
 * 			<screen name="main">
 * 				<style>
 * 					<Shape width="1000" height="1520" color="0xFFFFFF" name="" x="0" y="0" alpha="1"/>
 * 					<Text content="" messageID="titleID" textFormat="Museo_Slab_900_Regular_50_center_0x064413_0" width="780" height="250" name="titleTxt" x="150" y="50" alpha="1"/>
 * 				</style>
 * 			</screen>
 * 		</screens>
 * </style>
 * 
 * @author Adrian Barbu
 */
@:final
class SkinnableData implements ISkinnableData implements IDisposable
{
	@:isVar
	public var language(get, set):String;
	
	private var _texts:ITexts;
	
	private var _textFormats:ITextFormats;
	
	private var _skinObjectsDatabase:Map<String, ISkinObject> = new Map<String, ISkinObject>();
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new() {}
	
	public function dispose():Void 
	{
		if (_texts != null) {
			(cast (_texts, IDisposable)).dispose();
			_texts = null;
		}
		
		if (_textFormats != null) {
			(cast (_textFormats, IDisposable)).dispose();
			_textFormats = null;
		}
		
		if (_skinObjectsDatabase != null) {
			for (skinObj in _skinObjectsDatabase) {
				(cast (skinObj, IDisposable)).dispose();
			}
			_skinObjectsDatabase = null;
		}
	}
	
	// ====================================================================================================================================
	// ISkinnableData
	// ====================================================================================================================================
	
	public function initialize(styleXml:Xml, textsXml:Xml, textFormatsXml:Xml, language:String, width:Float, height:Float):Void 
	{
		this.language = language;
		initTexts(textsXml != null ? textsXml : HelpersXml.getChildrenWithNodeName(styleXml, "texts")[0]);
		initTextFormats(textFormatsXml != null ? textFormatsXml : HelpersXml.getChildrenWithNodeName(styleXml, "textFormats")[0]);
		initSkinDatabase(styleXml, width, height);
		updateWithTemplates();
	}
	
	public function getTextByID(messageID:String, content:String = "", upperCase:Bool = false, language:String = null):String 
	{
		var value:String = content;
		if (messageID != null) {
			value = _texts.getTextByID(messageID, upperCase, language);
			if (value == "") {
				value = content;
			}
		}
		if (upperCase) {
			value = HelpersString.toUpperCase(value);
		}
		
		return value;
	}
	
	public function getSkinObject(screenName:String):ISkinObject 
	{
		screenName = HelpersString.toLowerCase(screenName);
		if (_skinObjectsDatabase.exists(screenName)) {
			var skinObject = _skinObjectsDatabase.get(screenName);
			return skinObject;
		}
		return null;
	}
	
	public function getTextFormat(textFormatName:String, copy:Bool = true):TextFormat 
	{
		return _textFormats.getTextFormat(textFormatName, copy);
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	private function initTexts(textsXml:Xml):Void
	{
		_texts = new Texts();
		_texts.initialize(language, textsXml);
	}
	
	private function initTextFormats(textFormatsXml:Xml):Void
	{
		_textFormats = new TextFormats();
		_textFormats.initialize(textFormatsXml);
	}
	
	private function initSkinDatabase(styleXml:Xml, width:Float, height:Float):Void
	{
		_skinObjectsDatabase = new Map<String, ISkinObject>();
		var screensXml = HelpersXml.getChildrenWithNodeName(styleXml, "screens")[0];
		var screensXmls = HelpersXml.getChildrenWithNodeName(screensXml, "screen");
		for (screenXml in screensXmls) {
			createAndStoreOneSkinObject(screenXml, width, height);
		}
	}
	
	private function updateWithTemplates():Void
	{
		var templateSkinObj = _skinObjectsDatabase.get(HelpersString.toLowerCase("TEMPLATE"));
		if (templateSkinObj != null) {
			for (screenSkinObj in _skinObjectsDatabase) {
				(cast (screenSkinObj, SkinObject)).updateWithTemplate(templateSkinObj);
			}
		}
	}
	
	private function createAndStoreOneSkinObject(screenXml:Xml, width:Float, height:Float):Void
	{
		var screenStyleXml = HelpersXml.getChildrenWithNodeName(screenXml, "style")[0];
		var screenName = HelpersString.toLowerCase(screenXml.get("name"));
		var screenSkinObj:ISkinObject = new SkinObject(screenStyleXml, width, height, true);
		
		_skinObjectsDatabase.set(screenName, screenSkinObj);
	}
	
	// =====================================================================================================================================
	// GETTERS, SETTERS
	// =====================================================================================================================================
	
	function get_language():String { return language; }
	function set_language(value:String):String
	{
		if (value != null && _texts != null) {
			_texts.setLanguage(value);
		}
		
		return language = value;
	}
}