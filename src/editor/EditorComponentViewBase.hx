package editor;

import flashbite.interfaces.IDisposable;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import openfl.Assets;
import openfl.display.Sprite;

/**
 * Base class for any editor view
 * 
 * @author Adrian Barbu
 */
class EditorComponentViewBase extends Sprite implements IDisposable
{
	private static inline var SCREEN_NAME:String = "main";
	
	private var _skinnableViewCreator:ISkinnableViewCreator = new SkinnableViewCreator();
	private var _name:String = "";
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	private function new(name:String)
	{
		super();
		_name = name;
	}
	
	public function dispose():Void 
	{
		if (_skinnableViewCreator != null) {
			_skinnableViewCreator.dispose();
			_skinnableViewCreator = null;
		}
		_name = null;
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	public function initialize():Void
	{
		_skinnableViewCreator.initialize(Xml.parse(Assets.getText("assets/editor/" + _name + "/style.xml")).firstElement(), null, null, EditorConsts.language, 100, 100);
		registerCustomObjectsInSkinnable();
		_skinnableViewCreator.construct(this, SCREEN_NAME, 100, 100);
	}
	
	public function resize(newWidth:Float, newHeight:Float):Void
	{
		if (_skinnableViewCreator != null) {
			_skinnableViewCreator.resize(this, SCREEN_NAME, newWidth, newHeight);
		}
	}
	
	// =====================================================================================================================================
	// PRIVATE (PROTECTED)
	// =====================================================================================================================================
	
	private function registerCustomObjectsInSkinnable():Void
	{
		//register here the custom displayObjects or displayObjectContainers
	}
}