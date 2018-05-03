package flashbite.skinnableview.model.texts;

/**
 * ITexts interface for using tests in an application
 * 
 * @author Adrian Barbu
 */
interface ITexts 
{
	public function initialize(language:String, textsXml:Xml):Void;

	public function setLanguage(lang:String):Void;

	public function getTextByID(id:String, upperCase:Bool = false, lang:String = null):String;
}