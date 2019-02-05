package flashbite.console;

import flashbite.interfaces.IDisposable;
import flashbite.logger.LoggerLevels;
import flashbite.logger.targets.ILoggerTarget;
import haxe.Timer;
import openfl.display.DisplayObject;
import openfl.display.LineScaleMode;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.system.System;
import openfl.text.TextField;

/**
 * Console class to show fps, memory and to display output
 * 
 * @author Adrian Barbu
 */
@:final
class Console extends Sprite implements ILoggerTarget implements IDisposable
{
	private static inline var MAX_LOG_LENGTH:Int = 100;
	
	public static inline var REMOVED:String = "Console__REMOVED";
	
	private static inline var DIMENSION_PX:Float = 30;
	
	private static inline var BUTTON_NAME_MINIMIZE	:String = "MINIMIZE";
	private static inline var BUTTON_NAME_MAXIMIZE	:String = "MAXIMIZE";
	private static inline var BUTTON_NAME_CLOSE		:String = "CLOSE";
	
	private var _bg:Sprite;
	private var _infoTxt:TextField;
	private var _minimize:Sprite;
	private var _maximize:Sprite;
	private var _close:Sprite;
	private var _outputTxt:TextField;
	
	private static var MAX_NUM_LINES:Int = 30;
	private var _outputLines:Array<String> = [];
	
	// ====================================================================================================================================
	// CONSTRUCTOR-DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(rootView:DisplayObject)
	{
		super();
		
		rootView.stage.addChild(this);
		
		init();
		resize();
		minimize();
		start();
	}
	private function init():Void
	{
		//bg
		_bg = new Sprite();
		_bg.graphics.beginFill(0xCCCCCC, 0.75);
		_bg.graphics.drawRect(0, 0, 1, DIMENSION_PX);
		_bg.graphics.endFill();
		this.addChild(_bg);
		
		//frame-rate
		_infoTxt = new TextField();
		_infoTxt.width = 400;
		_infoTxt.height = DIMENSION_PX - 1;
		_infoTxt.border = true;
		this.addChild(_infoTxt);
		_infoTxt.text = "";
		
		//buttons
		_close = new Sprite();
		drawButton(_close, BUTTON_NAME_CLOSE, DIMENSION_PX);
		this.addChild(_close);
		
		_minimize = new Sprite();
		drawButton(_minimize, BUTTON_NAME_MINIMIZE, DIMENSION_PX);
		this.addChild(_minimize);
		
		_maximize = new Sprite();
		drawButton(_maximize, BUTTON_NAME_MAXIMIZE, DIMENSION_PX);
		this.addChild(_maximize);
		
		//output
		_outputTxt = new TextField();
		_outputTxt.width = 100;
		_outputTxt.height = 200;
		_outputTxt.background = true;
		_outputTxt.backgroundColor = 0xFFFFFF;
		_outputTxt.y = DIMENSION_PX;
		this.addChild(_outputTxt);
	}
	private function drawButton(button:Sprite, type:String, dimension:Float):Void
	{
		button.graphics.clear();
		button.graphics.lineStyle(0, 0xFFFFFF, 1, true, LineScaleMode.NORMAL);
		button.graphics.beginFill(0xFFFFFF);
		var offset:Float = 1;
		button.graphics.drawRoundRect(offset, offset, dimension - offset * 2, dimension - offset * 2, 2.5, 2.5);
		button.graphics.endFill();
		
		button.graphics.lineStyle(4, 0x000000, 1, true, LineScaleMode.NORMAL);
		
		var margin_px:Float = 4;
		var pX:Float = dimension - margin_px;
		
		switch (type) {
			case BUTTON_NAME_MINIMIZE:
				button.graphics.moveTo(margin_px, pX);
				button.graphics.lineTo(pX, pX);
			case BUTTON_NAME_MAXIMIZE:
				button.graphics.drawRect(margin_px, margin_px, pX - margin_px, pX - margin_px);
			case BUTTON_NAME_CLOSE:
				button.graphics.moveTo(margin_px, pX);
				button.graphics.lineTo(pX, margin_px);
				button.graphics.moveTo(margin_px, margin_px);
				button.graphics.lineTo(pX, pX);
		}
		
		button.name = type;
	}
	
	public function dispose():Void
	{
		this.dispatchEvent(new Event(REMOVED));
		
		stop();
		
		_outputLines = [];
		
		if (this.parent != null) {
			this.parent.removeChild(this);
		}
	}
	
	// ====================================================================================================================================
	// ILoggerTarget
	// ====================================================================================================================================
	
	public function logMessage(loggerName:String, level:Int, message:String):Void 
	{
		var finalMessage:String = createFormatedHour() + " >> " + createMessage(loggerName, level, message);
		if (finalMessage.length > MAX_LOG_LENGTH) {
			finalMessage = finalMessage.substring(0, MAX_LOG_LENGTH) + "...";
		}
		finalMessage += "\n";
		
		_outputLines.push(finalMessage);
		while (_outputLines.length > MAX_NUM_LINES) {
			_outputLines.shift();
		}
		_outputTxt.text = _outputLines.join("");
	}
	
	private function createMessage(loggerName:String, level:Int, message:String):String
	{
		return ("[" + loggerName + "] " + "[" + LoggerLevels.logLevelToString(level) + "] " + message);
	}
	
	private function createFormatedHour():String
	{
		return DateTools.format(Date.now(), "%T");
	}
	
	// ====================================================================================================================================
	// START-STOP
	// ====================================================================================================================================
	
	private function start():Void
	{
		stage.addEventListener(Event.RESIZE, onStageEvent, false, 0, true);
		stage.addEventListener(Event.ENTER_FRAME, onStageEvent, false, 0, true);
		
		_minimize.addEventListener(MouseEvent.CLICK, onButtonClick, false, 0, true);
		_maximize.addEventListener(MouseEvent.CLICK, onButtonClick, false, 0, true);
		_close.addEventListener(MouseEvent.CLICK, onButtonClick, false, 0, true);
	}
	private function stop():Void
	{
		stage.removeEventListener(Event.RESIZE, onStageEvent, false);
		stage.removeEventListener(Event.ENTER_FRAME, onStageEvent, false);
		
		_minimize.removeEventListener(MouseEvent.CLICK, onButtonClick, false);
		_maximize.removeEventListener(MouseEvent.CLICK, onButtonClick, false);
		_close.removeEventListener(MouseEvent.CLICK, onButtonClick, false);
	}
	
	// ====================================================================================================================================
	// MINIMIZE-MAXIMIZE
	// ====================================================================================================================================
	
	private function minimize():Void
	{
		_outputTxt.visible = false;
		_maximize.visible = true;
		_minimize.visible = false;
	}
	private function maximize():Void
	{
		_outputTxt.visible = true;
		_maximize.visible = false;
		_minimize.visible = true;
	}
	
	// ====================================================================================================================================
	// BUTTONS EVENTS
	// ====================================================================================================================================
	
	private function onButtonClick(e:MouseEvent):Void
	{
		var target = cast (e.currentTarget, Sprite);
		if (target != null) {
			switch (target.name) {
				case BUTTON_NAME_MINIMIZE:
					minimize();
				case BUTTON_NAME_MAXIMIZE:
					maximize();
				case BUTTON_NAME_CLOSE:
					dispose();
			}
		}
	}
	
	// ====================================================================================================================================
	// STAGE EVENTS
	// ====================================================================================================================================
	
	private function onStageEvent(e:Event):Void
	{
		switch (e.type) {
			case Event.RESIZE:
				resize();
			case Event.ENTER_FRAME:
				onEf();
		}
	}
	
	private function resize():Void
	{
		_bg.width = stage.stageWidth;
		_outputTxt.width = stage.stageWidth;
		_close.x = stage.stageWidth - _close.width;
		_maximize.x = _close.x - _maximize.width;
		_minimize.x = _close.x - _minimize.width;
	}
	
	// ------------------------------------------------------------------------------------------------------------------------------------
	// ENTER FRAME
	private var _lastTime:Float = Timer.stamp();
	private var _fpsTime:Float = 0;
	private var _fpsFrames:Int = 0;
	private var _memPeak:Int = 0;
	private var _rendererName:String;
	private function onEf():Void
	{
		var dt:Float = Timer.stamp() - _lastTime;
		
		 ++_fpsFrames;
        _fpsTime += dt;
		if (_fpsTime > 0.5) {
			var fps:Int = Math.round(_fpsFrames / _fpsTime);
			
			var mem:Int = Math.round(System.totalMemory / 1024 / 1024);
			if (mem > _memPeak) _memPeak = mem;
			
			if (_rendererName == null) {
				try {
					_rendererName = stage.window.context.type;
				} catch (e:Dynamic) {
					_rendererName = "--UNKNOWN--";
				}
			}
			
			_infoTxt.text = "RENDERER: " + _rendererName + "  ||FPS: " + fps + "  ||MEM: " + mem + " MB  ||MEM peak: " + _memPeak + " MB";
			
			_fpsFrames = 0;
			_fpsTime = 0;
		}
		
		_lastTime = Timer.stamp();
	}
	// ------------------------------------------------------------------------------------------------------------------------------------
}