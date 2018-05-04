package examples.flashbite;

import flashbite.interfaces.IDisposable;
import flashbite.logger.Logger;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.ISkinnableView;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;

/**
 * Base class for an example view
 * 
 * @author Adrian Barbu
 */
class ExampleBase extends Sprite implements IDisposable
{
	private static inline var MAIN_SCREEN_NAME		:String = "main";
	private static inline var TEMPLATE_SCREEN_NAME	:String = "TEMPLATE";
	
	private var _skinnableViewCreator:ISkinnableViewCreator;
	
	private var _styleXml:Xml;
	private var _textsXml:Xml;
	private var _textFormatsXml:Xml;
	
	private var _language:String;
	private var _width:Float;
	private var _height:Float;
	
	private var _name:String;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	private function new(name:String)
	{
		super();
		_name = name;
	}
	
	public function dispose():Void
	{
		var skinnableViewChildren:Array<ISkinnableView> = [];
		for (childIndex in 0...this.numChildren) {
			var child = this.getChildAt(childIndex);
			if (Std.is(child, ISkinnableView)) {
				skinnableViewChildren.push(cast child);
			}
		}
		for (child in skinnableViewChildren) {
			child.removeFromParent(true);
		}
		//remove any left child
		this.removeChildren();
		
		if (_skinnableViewCreator != null) {
			_skinnableViewCreator.dispose();
			_skinnableViewCreator = null;
		}
		_styleXml = _textsXml = _textFormatsXml = null;
		_language = null;
		_name = null;
	}
	
	// ====================================================================================================================================
	// PUBLIC
	// ====================================================================================================================================
	
	@:final
	public function initAndStart():Void
	{
		_skinnableViewCreator = new SkinnableViewCreator();
		registerCustoms();
		createProperties();
		
		_skinnableViewCreator.initialize(_styleXml, _textsXml, _textFormatsXml, _language, _width, _height);
		_skinnableViewCreator.construct(this, MAIN_SCREEN_NAME, _width, _height);
		
		stage.addEventListener(Event.RESIZE, onStageResize, false, 0, true);
		onStageResize(null);
		
		internalInitialize();
		internalStart();
	}
	
	// ====================================================================================================================================
	// PRIVATE (but they are PROTECTED ;) )
	// ====================================================================================================================================
	
	private function registerCustoms():Void
	{
		throw new Error("override this to registerCustomDisplayObject + registerCustomDisplayObjectContainer");
	}
	private function createProperties():Void
	{
		throw new Error("override this to initialize styleXml, textsXml, textFormatsXml + language + dimensions (width, height)");
	}
	
	private function internalInitialize():Void
	{
		throw new Error("override this to internalInitialize");
	}
	private function internalStart():Void
	{
		throw new Error("override this to internalStart");
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	@:final
	private function onStageResize(e:Event):Void
	{
		if (_skinnableViewCreator != null) {
			_skinnableViewCreator.resize(this, MAIN_SCREEN_NAME, stage.stageWidth, stage.stageHeight);
		}
	}
	
	@:final
	private function getDefaultStyleXml():Xml
	{
		var styleXml:Xml = null;
		
		try {
			var styleXmlString = Assets.getText("assets/examples/" + _name + "/" + "style.xml");
			styleXml = Xml.parse(styleXmlString).firstElement();
		} catch (e:Dynamic) {
			Logger.warning(this, e);
			styleXml = Xml.parse('<style><texts/><textFormats/><screens><screen name="main"><style></style></screen></screens></style>').firstElement();
		}
		
		return styleXml;
	}
	@:final
	private function getDefaultTextsXml():Xml
	{
		if (_textsXml == null) {
			try {
				var textsXmlString = Assets.getText("assets/examples/texts.xml");
				_textsXml = Xml.parse(textsXmlString).firstElement();
			} catch (e:Dynamic) {
				Logger.warning(this, e);
				_textsXml = Xml.parse('<texts/>').firstElement();
			}
		}
		
		return _textsXml;
	}
	@:final
	private function getDefaultTextFormatsXml():Xml
	{
		if (_textFormatsXml == null) {
			try {
				var textFormatsXmlString = Assets.getText("assets/examples/textFormats.xml");
				_textFormatsXml = Xml.parse(textFormatsXmlString).firstElement();
			} catch (e:Dynamic) {
				Logger.warning(this, e);
				_textFormatsXml = Xml.parse('<textFormats/>').firstElement();
			}
		}
		
		return _textFormatsXml;
	}
}