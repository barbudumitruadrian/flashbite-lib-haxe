package flashbite.skinnableview.model;

import flashbite.skinnableview.model.skinstyle.ISkinObject;
import openfl.text.TextFormat;

/**
 * ISkinnableData interface; used as a model for a class that holds and wraps ITexts and ISkinObject's
 * 
 * @author Adrian Barbu
 */
interface ISkinnableData 
{
	public function initialize(styleXml:Xml, textsXml:Xml, textFormatsXml:Xml, language:String, width:Float, height:Float):Void;
	
	public function getTextByID(messageID:String, content:String = "", upperCase:Bool = false, language:String = null):String;
	public function getSkinObject(screenName:String):ISkinObject;
	public function getTextFormat(textFormatName:String, copy:Bool = true):TextFormat;
	
	public var language(get, set):String;
}