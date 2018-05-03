package flashbite.skinnableview.model.skinstyle;

import openfl.text.TextFormat;

/**
 * ITextFormats interface
 * 
 * @author Adrian Barbu
 */
interface ITextFormats 
{
	public function initialize(xml:Xml):Void;
	
	public function getTextFormat(textFormatName:String, copy:Bool = true):TextFormat;
}