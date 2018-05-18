package flashbite.skinnableview;

import flashbite.interfaces.IDisposable;
import flashbite.skinnableview.model.ISkinnableData;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

/**
 * Interface for using SkinnableViewCreator
 * 
 * @author Adrian Barbu
 */
interface ISkinnableViewCreator extends IDisposable
{
	public function resize(container:DisplayObjectContainer, screenName:String, width:Float, height:Float):Void;
	
	/** 
	 * initialize
	 * It can be initialized in two ways:
	 * 1. a standard 'big' styleXml which must contain texts, textFormats and screens xml nodes;<br/>
	 *    this approach is ok on small applications, where each screen will contain all data to render;
	 *    in this case, pass null to textFormatsXml and textFormatsXml;
	 * 2. a small styleXml that will contain only screens xml node, and a global textsXml and textFormatsXml.
	 *    this approach is better on medium to big apps, were the internationalization (textsXml) and text formats (textFormatsXml) will be separate files
	 */
	public function initialize(styleXml:Xml, textsXml:Xml, textFormatsXml:Xml, language:String, screenWidth:Float, screenHeight:Float):Void;

	/** construct a screen */
	public function construct(container:DisplayObjectContainer, screenName:String, screenWidth:Float, screenHeight:Float):Void;
	/** 
	 * construct a child from a screen and add it to a container; 
	 * @return the created instance
	 */
	public function constructChild(container:DisplayObjectContainer, screenName:String, childName:String, containerWidth:Float, containerHeight:Float):DisplayObject;
	/** destruct any children added into a container */
	public function destruct(container:DisplayObjectContainer):Void;
	
	/** 
	 * register a custom display object class to be created when in style xml is specified a different object type;
	 * (see flashbite.skinnableview.view.ViewBase)
	 * @return true if registered, false otherwise 
	 */
	public function registerCustomDisplayObject(name:String, clazz:Dynamic, overrideCurrent:Bool = true):Bool;
	/** 
	 * register a custom display object container class to be created when in style xml is specified a different object containerType;
	 * (see flashbite.skinnableview.view.ContainerBase)
	 * @return true if registered, false otherwise */
	public function registerCustomDisplayObjectContainer(name:String, clazz:Dynamic, overrideCurrent:Bool = true):Bool;

	/** make a text reassign with new language */
	public function updateLanguageOn(container:DisplayObjectContainer):Void;

	/** @return the internal ISkinnableData object */
	public var skinnableData(get, null):ISkinnableData;
	
	/** get,set new language on skinnable data */
	public var language(get, set):String;
}