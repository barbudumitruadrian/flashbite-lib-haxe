package flashbite.skinnableview.view.shape;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ISkinnableView;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

/**
 * QuadSkinnable class; Extends openfl.display.Shape and draw the skin rectangle
 * 
 * @author Adrian Barbu
 */
@:final
class ShapeSkinnable extends Bitmap implements ISkinnableView
{
	public var skinObj(get, null):ISkinObject;
	
	@:isVar public var color(get, set):Int = -1;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		this.skinObj = skinObj;
		
		super(new BitmapData(1, 1, false, 0xFFFFFF), PixelSnapping.NEVER);
		
		color = skinObj.color;
		
		redraw();
	}
	
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
		this.bitmapData.dispose();
	}
	
	// ====================================================================================================================================
	// Redraw
	// ====================================================================================================================================
	
	public function redraw():Void
	{
		this.x = skinObj.x;
		this.y = skinObj.y;
		this.width = skinObj.width;
		this.height = skinObj.height;
	}
	
	// ====================================================================================================================================
	// GETTERS, SETTERS
	// ====================================================================================================================================
	
	function get_skinObj():ISkinObject { return skinObj; }
	
	function get_color():Int { return color; }
	function set_color(value:Int):Int
	{
		if (color != value && value >= 0) {
			var colorInfo = this.transform.colorTransform;
			colorInfo.color = value;
			this.transform.colorTransform = colorInfo;
			
			color = value;
		}
		
		return color;
	}
}