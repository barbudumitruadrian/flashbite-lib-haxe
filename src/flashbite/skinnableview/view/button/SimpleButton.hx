package flashbite.skinnableview.view.button;

import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;
import openfl.display.DisplayObject;
import openfl.errors.Error;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * SimpleButton is a simple button, with 2 states (up and down).
 * The button must have an internal container with name "contents".
 * On click, the button will dispatch an event with type TRIGGERED
 * 
 * @author Adrian Barbu
 */
@:final
class SimpleButton extends ContainerBase
{
	public static inline var TRIGGERED:String = "SimpleButton__TRIGGERED";
	private static var EVENT_TRIGGERED:Event = new Event(TRIGGERED, true, false);
	
	@:isVar public var defaultScale(get, set):Float = 1;
	
	@:isVar public var enabled(get, set):Bool = false;

	private var _scaleWhenDown:Float = 0.95;
	private var _alphaWhenDisabled:Float = 0.75;
	
	private var _isMouseDown:Bool = false;
	private var _isMouseOnTop:Bool = false;
	
	private var _contents:DisplayObject;
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super(skinObj, skinnableData);
		
		_scaleWhenDown = Std.parseFloat(skinObj.rawObject.getPropertyValue("scaleWhenDown", true, Std.string(_scaleWhenDown)));
		_alphaWhenDisabled = Std.parseFloat(skinObj.rawObject.getPropertyValue("alphaWhenDisabled", true, Std.string(_alphaWhenDisabled)));
	}
	
	override public function dispose():Void
	{
		removeMouseEvents();
		_contents = null;
		
		super.dispose();
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	public function initialize(enabled:Bool = true, defaultScale:Float = 1):Void
	{
		_contents = HelpersGlobal.getChildByName(this, "contents");
		if (_contents == null || this.numChildren != 1) {
			throw new Error("Malformed SimpleButton, it must have a single child with name 'contents'");
		}
		
		this.defaultScale = defaultScale;
		this.enabled = enabled;
	}
	
	// =====================================================================================================================================
	// PRIVATE
	// =====================================================================================================================================
	
	private function removeMouseEvents():Void
	{
		this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent);
		this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
		if (this.stage != null) {
			this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
		}
	}
	private function addMouseEvents():Void
	{
		this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseEvent, false, 0, true);
	}
	
	private function onMouseEvent(e:MouseEvent):Void
	{
		var justTriggered:Bool = false;
		
		switch (e.type) {
			case MouseEvent.MOUSE_DOWN:
				_isMouseDown = true;
				_isMouseOnTop = true;
				this.addEventListener(MouseEvent.MOUSE_OUT, onMouseEvent, false, 0, true);
				if (this.stage != null) {
					this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent, false, 0, true);
				} else {
					this.addEventListener(MouseEvent.MOUSE_UP, onMouseEvent, false, 0, true);
				}
			case MouseEvent.MOUSE_OUT:
				_isMouseOnTop = false;
			case MouseEvent.MOUSE_UP:
				justTriggered = _isMouseDown && _isMouseOnTop;
				_isMouseDown = _isMouseOnTop = false;
				this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseEvent);
				if (this.stage != null) {
					this.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				} else {
					this.removeEventListener(MouseEvent.MOUSE_UP, onMouseEvent);
				}
			default:
				Logger.warning(this, "Unmanaged MouseEvent of type " + e.type);
		}
		
		updateContents();
		
		if (justTriggered) {
			this.dispatchEvent(EVENT_TRIGGERED);
		}
	}
	
	private function updateContents():Void
	{
		if (_isMouseDown) {
			_contents.scaleX = _contents.scaleY = _scaleWhenDown * defaultScale;
			_contents.x = Math.round((1.0 - _scaleWhenDown) / 2.0 * _contents.width);
			_contents.y = Math.round((1.0 - _scaleWhenDown) / 2.0 * _contents.height);
		} else {
			_contents.scaleX = _contents.scaleY = defaultScale;
			_contents.x = _contents.y = 0;
		}
	}
	
	// =====================================================================================================================================
	// GETTERS, SETTERS
	// =====================================================================================================================================
	
	function get_enabled():Bool { return enabled; }
	function set_enabled(value:Bool):Bool
	{
		this.mouseEnabled = value;
		removeMouseEvents();
		if (value) {
			addMouseEvents();
		}
		this.alpha = value ? 1 : _alphaWhenDisabled;
		
		return enabled = value;
	}
	
	function get_defaultScale():Float { return defaultScale; }
	function set_defaultScale(value:Float):Float
	{
		var result = (defaultScale = value);
		updateContents();
		
		return result;
	}
}