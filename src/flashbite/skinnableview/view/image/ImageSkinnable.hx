package flashbite.skinnableview.view.image;

import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ISkinnableView;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

/**
 * ImageSkinnable class; Extends openfl.display.Bitmap and get his bitmapData from Assets
 * 
 * @author Adrian Barbu
 */
@:final
class ImageSkinnable extends Bitmap implements ISkinnableView
{
	public var skinObj(get, null):ISkinObject;
	
	@:isVar public var color(get, set):Int = -1;
	
	private var _isFallbackBmpData:Bool = false;
	private var _smoothing:Bool = true;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		this.skinObj = skinObj;
		
		var bmpData = null;
		try {
			bmpData = Assets.getBitmapData(skinObj.fileName);
		} catch (e:Dynamic) {
			Logger.warning(this, "Unable to get bmpData for image " + e);
			
			bmpData = new BitmapData(1, 1, false, 0xFF0000);
			_isFallbackBmpData = true;
		}
		
		_smoothing = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("smoothing", true, Std.string(_smoothing)));
		
		super(bmpData, PixelSnapping.NEVER, _smoothing);
		
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
		if (_isFallbackBmpData) {
			this.bitmapData.dispose();
		}
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
		}
		
		return color = value;
	}
}