package flashbite.skinnableview.view;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import openfl.display.Sprite;

/**
 * ViewBase class; Base class to be used to create any other in ISkinnableViewCreator
 * 
 * @author Adrian Barbu
 */
class ViewBase extends Sprite implements ISkinnableView
{
	public var skinObj(get, null):ISkinObject;
	private var _skinnableData:ISkinnableData;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super();
		
		this.skinObj = skinObj;
		_skinnableData = skinnableData;
		
		redraw();
	}
	
	@:final
	public function removeFromParent(disposeIt:Bool = true):Void
	{
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
		if (disposeIt) {
			dispose();
		}
	}
	
	public function dispose():Void
	{
		skinObj = null;
		_skinnableData = null;
	}
	
	// ====================================================================================================================================
	// Redraw
	// ====================================================================================================================================
	
	public function redraw():Void
	{
		this.x = skinObj.x;
		this.y = skinObj.y;
	}
	
	// ====================================================================================================================================
	// GETTERS
	// ====================================================================================================================================
	
	@:final
	function get_skinObj():ISkinObject { return skinObj; }
}