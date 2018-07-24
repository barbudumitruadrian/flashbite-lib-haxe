package flashbite.skinnableview.view.layout;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.layout.data.ILayoutData;
import flashbite.skinnableview.view.layout.data.LayoutData;
import openfl.display.DisplayObject;
import openfl.errors.Error;

/**
 * Base class for any layout
 * 
 * @author Adrian Barbu
 */
class LayoutBase extends ContainerBase
{
	public var layoutData(get, null):ILayoutData = new LayoutData();
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	private function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super(skinObj, skinnableData);
		
		(cast (layoutData, LayoutData)).readFromRawObject(skinObj.rawObject);
	}
	
	override public function dispose():Void
	{
		super.dispose();
		
		layoutData = null;
	}
	
	// ====================================================================================================================================
	// PUBLIC OVERRIDE
	// ====================================================================================================================================
	
	@:final
	override public function addChild(child:DisplayObject):DisplayObject
	{
		var result = super.addChild(child);
		updateChildren();
		return result;
	}
	@:final
	override public function addChildAt(child:DisplayObject, index:Int):DisplayObject
	{
		var result = super.addChildAt(child, index);
		updateChildren();
		return result;
	}
	@:final
	override public function removeChild(child:DisplayObject):DisplayObject
	{
		var result = super.removeChild(child);
		updateChildren();
		return result;
	}
	@:final
	override public function removeChildAt(index:Int):DisplayObject
	{
		var result = super.removeChildAt(index);
		updateChildren();
		return result;
	}
	
	// ====================================================================================================================================
	// REDRAW
	// ====================================================================================================================================
	
	override public function redraw():Void
	{
		super.redraw();
		
		if (children.length > 0) {
			arrangeChildren();
		}
	}
	
	// ====================================================================================================================================
	// PRIVATE = PROTECTED
	// ====================================================================================================================================
	
	private function arrangeChildren():Void
	{
		throw new Error("Abstract function, override it!");
	}
	
	// ====================================================================================================================================
	// GETTERS, SETTERS
	// ====================================================================================================================================
	
	@:final
	function get_layoutData():ILayoutData { return layoutData; }
}