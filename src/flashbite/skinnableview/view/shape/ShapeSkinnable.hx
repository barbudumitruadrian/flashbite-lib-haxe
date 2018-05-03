package flashbite.skinnableview.view.shape;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ISkinnableView;
import openfl.display.Shape;

/**
 * QuadSkinnable class; Extends openfl.display.Shape and draw the skin rectangle
 * 
 * @author Adrian Barbu
 */
@:final
class ShapeSkinnable extends Shape implements ISkinnableView
{
	public var skinObj(get, null):ISkinObject;
	
	@:isVar public var color(get, set):Int = -1;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super();
		
		this.skinObj = skinObj;
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
	}
	
	// ====================================================================================================================================
	// Redraw
	// ====================================================================================================================================
	
	public function redraw():Void
	{
		this.x = skinObj.x;
		this.y = skinObj.y;
		
		//draw
		draw();
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	private function draw():Void
	{
		this.graphics.clear();
		this.graphics.beginFill(Std.int(Math.max(0, color)), skinObj.alpha);
		this.graphics.drawRect(0, 0, skinObj.width, skinObj.height);
		this.graphics.endFill();
	}
	
	// ====================================================================================================================================
	// GETTERS
	// ====================================================================================================================================
	
	function get_skinObj():ISkinObject { return skinObj; }
	
	function get_color():Int { return color; }
	function set_color(value:Int):Int
	{
		if (color != value && value >= 0) {
			color = value;
			draw();
		}
		
		return color = value;
	}
}