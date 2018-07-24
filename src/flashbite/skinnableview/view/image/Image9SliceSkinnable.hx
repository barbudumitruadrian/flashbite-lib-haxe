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
import openfl.geom.Matrix;
import openfl.geom.Rectangle;

/**
 * Image9SliceSkinnable class; Extends openfl.display.Bitmap and get his bitmapData from Assets + update his dimensions based on a 9 slice grid
 * Warning: If the expected visual isn't correct, try to create a scale9Grid rectangle that is in center and occupy 1/3 of width and height
 * ex: image is 60x30, scale9Grid should be 20x10, so "20,10,20,10".
 * 
 * @author Adrian Barbu
 */
@:final
class Image9SliceSkinnable extends Bitmap implements ISkinnableView
{
	private static var RECTANGLE_HELPER(default, never):Rectangle = new Rectangle();
	private static var MATRIX_HELPER(default, never):Matrix = new Matrix();
	
	public var skinObj(get, null):ISkinObject;
	
	@:isVar public var color(get, set):Int = -1;
	
	private var _rootBmpData:BitmapData;
	private var _isFallbackBmpData:Bool = false;
	private var _smoothing:Bool = true;
	
	private var _scale9Grid:Rectangle;
	private var _currentBmpData:BitmapData;
	
	//flag variable to reset the dimension of item when redraw is called
	private var _isDefaultRedraw:Bool = true;
	private var _standardWidth:Float = -1;
	private var _standardHeight:Float = -1;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		this.skinObj = skinObj;
		
		_rootBmpData = null;
		try {
			_rootBmpData = Assets.getBitmapData(skinObj.fileName);
		} catch (e:Dynamic) {
			Logger.warning(this, "Unable to get bmpData for image " + e);
			
			_rootBmpData = new BitmapData(3, 3, false, 0xFF0000);
			_isFallbackBmpData = true;
		}
		
		_smoothing = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("smoothing", true, Std.string(_smoothing)));
		
		var defaultScale9Grid:String = "" + _rootBmpData.width / 3 + "," + _rootBmpData.height / 3 + "," +  _rootBmpData.width / 3 + "," + _rootBmpData.height / 3;
		var scale9GridArr = skinObj.rawObject.getPropertyValue("scale9Grid", true, defaultScale9Grid).split(",");
		_scale9Grid = new Rectangle(Std.parseInt(scale9GridArr[0]), Std.parseInt(scale9GridArr[1]), Std.parseInt(scale9GridArr[2]), Std.parseInt(scale9GridArr[3]));
		
		super(_rootBmpData, PixelSnapping.NEVER, _smoothing);
		
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
		if (_isFallbackBmpData && _rootBmpData != null) {
			_rootBmpData.dispose();
		}
		_rootBmpData = null;
		_scale9Grid = null;
		
		disposeCurrentBmpData();
	}
	
	// ====================================================================================================================================
	// PUBLIC
	// ====================================================================================================================================
	
	public function setWidthAndHeight(newWidth:Float = -1, newHeight:Float = -1):Void
	{
		_standardWidth = newWidth;
		_standardHeight = newHeight;
		_isDefaultRedraw = false;
		redraw();
		_isDefaultRedraw = true;
	}
	
	// ====================================================================================================================================
	// Redraw
	// ====================================================================================================================================
	
	public function redraw():Void
	{
		if (_isDefaultRedraw) {
			_standardWidth = _standardHeight = -1;
		}
		
		var useDefaultWidth:Bool = (_standardWidth == -1);
		if (useDefaultWidth) {
			_standardWidth = skinObj.width;
		}
		
		var useDefaultHeight:Bool = (_standardHeight == -1);
		if (useDefaultHeight) {
			_standardHeight = skinObj.height;
		}
		
		disposeCurrentBmpData();
		_currentBmpData = new BitmapData(Std.int(_standardWidth), Std.int(_standardHeight), true, 0x00FFFFFF);
		draw9SliceParts();
		this.bitmapData = _currentBmpData;
		
		this.x = skinObj.x;
		this.y = skinObj.y;
		this.width = _standardWidth;
		this.height = _standardHeight;
		
		if (useDefaultWidth) {
			_standardWidth = -1;
		}
		if (useDefaultHeight) {
			_standardHeight = -1;
		}
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	private function disposeCurrentBmpData():Void
	{
		if (_currentBmpData != null) {
			_currentBmpData.dispose();
			_currentBmpData = null;
		}
	}
	
	private function draw9SliceParts():Void
	{
		var modX:Float = 0;
		var modY:Float = 0;
		var modScaleX:Float = 1;
		var modScaleY:Float = 1;
		var newWidth:Float = 0;
		var newHeight:Float = 0;
		
		//top.left
		RECTANGLE_HELPER.setTo(0, 0, _scale9Grid.x, _scale9Grid.y);
		MATRIX_HELPER.identity();
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		//top.center
		RECTANGLE_HELPER.setTo(_scale9Grid.x, 0, _scale9Grid.width, _scale9Grid.y);
		MATRIX_HELPER.identity();
		newWidth = _standardWidth - (_scale9Grid.x + (_rootBmpData.width - _scale9Grid.right));
		modScaleX = newWidth / _scale9Grid.width;
		MATRIX_HELPER.scale(modScaleX, 1);
		MATRIX_HELPER.tx -= _scale9Grid.width * (modScaleX - 1);
		RECTANGLE_HELPER.width = newWidth;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		//top.right
		RECTANGLE_HELPER.setTo(_scale9Grid.x + _scale9Grid.width, 0, _rootBmpData.width - (_scale9Grid.x + _scale9Grid.width), _scale9Grid.y);
		MATRIX_HELPER.identity();
		modX = _standardWidth - _rootBmpData.width;
		RECTANGLE_HELPER.x += modX;
		MATRIX_HELPER.tx += modX;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		
		//center.left
		RECTANGLE_HELPER.setTo(0, _scale9Grid.y, _scale9Grid.x, _scale9Grid.height);
		MATRIX_HELPER.identity();
		newHeight = _standardHeight - (_scale9Grid.y + (_rootBmpData.height - _scale9Grid.bottom));
		modScaleY = newHeight / _scale9Grid.height;
		MATRIX_HELPER.scale(1, modScaleY);
		MATRIX_HELPER.ty -= _scale9Grid.height * (modScaleY-1);
		RECTANGLE_HELPER.height = newHeight;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		//center.center
		RECTANGLE_HELPER.setTo(_scale9Grid.x, _scale9Grid.y, _scale9Grid.width, _scale9Grid.height);
		MATRIX_HELPER.identity();
		newWidth = _standardWidth - (_scale9Grid.x + (_rootBmpData.width - _scale9Grid.right));
		modScaleX = newWidth / _scale9Grid.width;
		newHeight = _standardHeight - (_scale9Grid.y + (_rootBmpData.height - _scale9Grid.bottom));
		modScaleY = newHeight / _scale9Grid.height;
		MATRIX_HELPER.scale(modScaleX, modScaleY);
		MATRIX_HELPER.tx -= _scale9Grid.width * (modScaleX - 1);
		MATRIX_HELPER.ty -= _scale9Grid.height * (modScaleY - 1);
		RECTANGLE_HELPER.width = newWidth;
		RECTANGLE_HELPER.height = newHeight;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		//center.right
		RECTANGLE_HELPER.setTo(_scale9Grid.x + _scale9Grid.width, _scale9Grid.y, _rootBmpData.width - (_scale9Grid.x + _scale9Grid.width), _scale9Grid.height);
		MATRIX_HELPER.identity();
		modX = _standardWidth - _rootBmpData.width;
		RECTANGLE_HELPER.x += modX;
		MATRIX_HELPER.tx += modX;
		newHeight = _standardHeight - (_scale9Grid.y + (_rootBmpData.height - _scale9Grid.bottom));
		modScaleY = newHeight / _scale9Grid.height;
		MATRIX_HELPER.scale(1, modScaleY);
		MATRIX_HELPER.ty -= _scale9Grid.height * (modScaleY-1);
		RECTANGLE_HELPER.height = newHeight;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		
		//bottom.left
		RECTANGLE_HELPER.setTo(0, _scale9Grid.height + _scale9Grid.y, _scale9Grid.x, _rootBmpData.height - (_scale9Grid.height + _scale9Grid.y));
		MATRIX_HELPER.identity();
		modY = _standardHeight - _rootBmpData.height;
		RECTANGLE_HELPER.y += modY;
		MATRIX_HELPER.ty += modY;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		//bottom.center
		RECTANGLE_HELPER.setTo(_scale9Grid.x, _scale9Grid.height + _scale9Grid.y, _scale9Grid.width, _rootBmpData.height - (_scale9Grid.height + _scale9Grid.y));
		MATRIX_HELPER.identity();
		newWidth = _standardWidth - (_scale9Grid.x + (_rootBmpData.width - _scale9Grid.right));
		modScaleX = newWidth / _scale9Grid.width;
		MATRIX_HELPER.scale(modScaleX, 1);
		MATRIX_HELPER.tx -= _scale9Grid.width * (modScaleX - 1);
		RECTANGLE_HELPER.width = newWidth;
		modY = _standardHeight - _rootBmpData.height;
		MATRIX_HELPER.ty += modY;
		RECTANGLE_HELPER.y += modY;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
		//bottom.right
		RECTANGLE_HELPER.setTo(_scale9Grid.x + _scale9Grid.width, _scale9Grid.height + _scale9Grid.y, _rootBmpData.width - (_scale9Grid.x + _scale9Grid.width), _rootBmpData.height - (_scale9Grid.height + _scale9Grid.y));
		MATRIX_HELPER.identity();
		modX = _standardWidth - _rootBmpData.width;
		modY = _standardHeight - _rootBmpData.height;
		RECTANGLE_HELPER.x += modX;
		RECTANGLE_HELPER.y += modY;
		MATRIX_HELPER.tx += modX;
		MATRIX_HELPER.ty += modY;
		_currentBmpData.draw(_rootBmpData, MATRIX_HELPER, null, null, RECTANGLE_HELPER, true);
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