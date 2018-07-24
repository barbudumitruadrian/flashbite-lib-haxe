package flashbite.skinnableview.view.movieclip;

import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ISkinnableView;
import motion.Actuate;
import motion.actuators.IGenericActuator;
import motion.easing.Linear;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display.PixelSnapping;

/**
 * MovieclipSkinnable class; Extends openfl.display.Bitmap and get his bitmapData from Assets + adding animation
 * Warning1 : images must have suffix with 3 zeroes : ex: image_000.png, image_001.png;
 * Warning2 : if set from external currentFrame, make sure to not animate it.
 * 
 * @author Adrian Barbu
 */
@:final
class MovieClipSkinnable extends Bitmap implements ISkinnableView implements IPlayable
{
	public var skinObj(get, null):ISkinObject;
	
	@:isVar public var color(get, set):Int = -1;
	
	private var _fallbackBmpData:BitmapData;
	
	private var _numFrames:Int = 1;
	/** zero based frame; ex: first frame is 0, second is 1, etc. */
	@:isVar public var currentFrame(get, set):Int = 0;
	private var _frames:Array<BitmapData> = [];
	
	private var _smoothing:Bool = true;
	
	private var _animation:IGenericActuator;
	private var _animationDuration:Float;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		this.skinObj = skinObj;
		
		//read frames
		for (frameIndex in 0...skinObj.numFrames) {
			//try with only png files
			var frameName = skinObj.filePrefix + HelpersGlobal.addLeadingZeroes(frameIndex, 3) + ".png";
			var bmpData:BitmapData = null;
			try {
				bmpData = Assets.getBitmapData(frameName);
			} catch (e:Dynamic) {
				Logger.warning(this, "Unable to get bmpData for frameName " + e);
				if (_fallbackBmpData == null) {
					_fallbackBmpData = new BitmapData(1, 1, false, 0xFF0000);
				}
				bmpData = _fallbackBmpData;
			}
			_frames.push(bmpData);
		}
		if (_frames.length == 0) {
			if (_fallbackBmpData == null) {
				_fallbackBmpData = new BitmapData(1, 1, false, 0xFF0000);
			}
			_frames.push(_fallbackBmpData);
		}
		
		_numFrames = _frames.length;
		_animationDuration = _numFrames / skinObj.frameRate;
		
		_smoothing = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("smoothing", true, Std.string(_smoothing)));
		
		super(_frames[0], PixelSnapping.NEVER, _smoothing);
		currentFrame = 0;
		
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
		stop();
		
		skinObj = null;
		if (_fallbackBmpData != null) {
			_fallbackBmpData.dispose();
			_fallbackBmpData = null;
		}
		_frames = null;
	}
	
	// ====================================================================================================================================
	// IPlayable
	// ====================================================================================================================================
	
	/** play the item from the last frame */
	public function play():Void
	{
		if (_animation == null) {
			_animation = Actuate.tween(this, _animationDuration, {currentFrame:_numFrames - 1}).repeat(-1).snapping(true).ease(Linear.easeNone);
		} else {
			Actuate.resume(_animation);
		}
	}
	
	/** pauses the playing */
	public function pause():Void
	{
		if (_animation != null) {
			Actuate.pause(_animation);
		}
	}
	
	/** stops the playing and reset to frame one */
	public function stop():Void
	{
		currentFrame = 0;
		if (_animation != null) {
			Actuate.stop(_animation, null, false, false);
			_animation = null;
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
			
			color = value;
		}
		
		return color;
	}
	
	function get_currentFrame():Int { return currentFrame; }
	function set_currentFrame(value:Int):Int
	{
		var realCurrentFrameRate = Std.int(Math.min(Math.max(0, value), _numFrames - 1));
		this.bitmapData = _frames[realCurrentFrameRate];
		
		return currentFrame = realCurrentFrameRate;
	}
}