package flashbite.skinnableview.model.texts;

import flashbite.helpers.HelpersGlobal;
import flashbite.helpers.HelpersString;
import flashbite.helpers.HelpersXml;
import flashbite.interfaces.IDisposable;
import flashbite.logger.Logger;

/**
 * Texts class; Data class that holds the texts, based on language
 * 
 * @author Adrian Barbu
 */
@:final
class Texts implements ITexts implements IDisposable 
{
	private static var DEFAULT_LANG:String = HelpersString.toLowerCase("Def");

	private var _database:Map<String, Dynamic> = new Map<String, Dynamic>();
	private var _currentLang:String = "";
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new() {}
	
	public function dispose():Void 
	{
		_database = null;
	}
	
	// ====================================================================================================================================
	// ITexts
	// ====================================================================================================================================
	
	public function initialize(language:String, textsXml:Xml):Void 
	{
		setLanguage(language);

		//read xml
		var textsXmls = getTextsXmls(textsXml);
		for (textXml in textsXmls) {
			add(HelpersXml.toObject(textXml));
		}
	}
	
	public function setLanguage(lang:String):Void 
	{
		_currentLang = HelpersString.toLowerCase(lang);
	}
	
	public function getTextByID(id:String, upperCase:Bool = false, lang:String = null):String 
	{
		if (id != "") {
			if (lang == null) {
				lang = _currentLang;

				if (lang == null || lang == "") {
					lang = DEFAULT_LANG;
				}
			}

			lang = HelpersString.toLowerCase(lang);

			if (lang != null) {
				var textObj:Dynamic = _database.get(HelpersString.toLowerCase(id));

				var text:String = null;
				if (textObj != null) {
					text = HelpersGlobal.getCaseInsensitivePropValue(textObj, lang);

					if (text == null) {
						text = HelpersGlobal.getCaseInsensitivePropValue(textObj, DEFAULT_LANG);
					}
				}

				if (text != null) {
					return (upperCase == false) ? (text) : (HelpersString.toUpperCase(text));
				}
			}

			Logger.warning(this, "Unable to getTextByID(id = '" + id + "', lang = '" + lang + "')");
		}

		return "";
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	private function add(obj:Dynamic):Void
	{
		var id:String = HelpersGlobal.getCaseInsensitivePropValue(obj, "id");
		if (id != null) {
			_database.set(HelpersString.toLowerCase(id), obj);
		}
	}
	
	private function getTextsXmls(textsXml:Xml):Array<Xml>
	{
		var rootNodes = HelpersXml.getChildrenWithNodeName(textsXml, "texts");
		var rootNode = rootNodes.length > 0 ? rootNodes[0] : null;
		if (rootNode != null) {
			return HelpersXml.getChildrenWithNodeName(rootNode, "text");	
		} else {
			//that means that it is correctly received...
			return HelpersXml.getChildrenWithNodeName(textsXml, "text");
		}
	}
}