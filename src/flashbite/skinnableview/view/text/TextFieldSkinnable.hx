package flashbite.skinnableview.view.text;

import flashbite.helpers.HelpersGlobal;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ISkinnableView;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.text.AntiAliasType;
import openfl.text.TextField;
import openfl.text.TextFormat;

/**
 * TextFieldSkinable class; extended openfl.text.TextField class with the capability to format a text based on a text format
 * Make sure to call setText(value) instead of tf.text = value
 * 
 * @author Adrian Barbu
 */
class TextFieldSkinnable extends TextField implements ISkinnableView
{
	public static inline var FALLBACK_TEXTFORMAT_NAME:String = "Helvetica";
	public static var FALLBACK_LANGUAGES:Array<String> = [];
	
	private static inline var FONT_OFFSET:Float = 4;
	
	public var skinObj(get, null):ISkinObject;
	private var _skinnableData:ISkinnableData;
	
	private var _initialTextFormat:TextFormat;
	private var _initialFontSize:Int;
	private var _initialFontName:String;
	
	private var _autoScale:Bool = true;
	private var _truncate:Bool = false;
	private var _truncationValue:String = "...";
	private var _centerOnY:Bool = false;
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		this.skinObj = skinObj;
		_skinnableData = skinnableData;
		
		super();
		
		_initialTextFormat = _skinnableData.getTextFormat(skinObj.textFormat, true);
		this.defaultTextFormat = _initialTextFormat;
		_initialFontSize = _initialTextFormat.size;
		_initialFontName = _initialTextFormat.font;
		
		_autoScale = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("autoScale", true, "true"));
		_truncate = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("truncate", true, "false"));
		_truncationValue = skinObj.rawObject.getPropertyValue("truncationValue", true, _truncationValue);
		if (_truncationValue == "") {
			_truncationValue = "...";
		}
		if (_truncate) {
			_autoScale = false;
			this.multiline = false;
		} else {
			this.multiline = true;
		}
		this.wordWrap = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("wordWrap"));
		this.border = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("border"));
		this.antiAliasType = AntiAliasType.ADVANCED;
		_centerOnY = HelpersGlobal.translateToBoolean(skinObj.rawObject.getPropertyValue("centerOnY", true, "true"));
		
		redraw();
		
		this.mouseEnabled = false;
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
		_initialTextFormat = null;
		_initialFontName = null;
		_truncationValue = null;
	}
	
	// ====================================================================================================================================
	// Redraw
	// ====================================================================================================================================
	
	public function redraw():Void
	{
		var initialText:String = getInitialText();
		var redrawText:Bool = initialText != this.text || this.width != skinObj.width || this.height != skinObj.height || (_centerOnY && this.y != skinObj.y);
		
		this.x = skinObj.x;
		this.y = skinObj.y;
		this.width = skinObj.width;
		this.height = skinObj.height;
		
		if (redrawText) {
			setText(initialText);
		}
	}
	
	// ====================================================================================================================================
	// PUBLIC
	// ====================================================================================================================================
	
	/** returns the initial text from texts xml */
	@:final
	public function getInitialText():String
	{
		var currentText:String = _skinnableData.getTextByID(skinObj.messageID, skinObj.content, skinObj.isUpperCase);

		return replaceSpecialCharacters(currentText);
	}
	
	/** call this instead of tf.text = value in order to treat special management on text : ex: autoScale, truncate, colors, etc */
	@:final
	public function setText(value:String):Void
	{
		this.text = value;
		
		if (value != "") {
			//defaults
			this.embedFonts = true;
			_initialTextFormat.font = _initialFontName;
			_initialTextFormat.size = _initialFontSize;
			this.text = value;
			this.setTextFormat(_initialTextFormat);
			
			//fallback to default text format and non-embed
			var textIsntRendered:Bool = this.textWidth == 0 || this.textHeight == 0;
			var languageIsInFallback = FALLBACK_LANGUAGES.indexOf(_skinnableData.language) != -1;
			if (textIsntRendered || languageIsInFallback) {
				this.embedFonts = false;
				_initialTextFormat.font = FALLBACK_TEXTFORMAT_NAME;
				this.text = value;
				this.setTextFormat(_initialTextFormat);
			}
			
			if (_autoScale) {
				var maxTextWidth:Int = Std.int(this.width - FONT_OFFSET);
				var maxTextHeight:Int = Std.int(this.height - FONT_OFFSET);

				while (this.textWidth > maxTextWidth || this.textHeight > maxTextHeight) {
					if (_initialTextFormat.size <= 4) {
						break;
					}
					_initialTextFormat.size--;
					this.text = value;
					this.setTextFormat(_initialTextFormat);
				}
			} else if (_truncate) {
				//decrease text length and add truncationValue at end
				//make sure we don't reach an infinite loop by limiting the while to a fixed amount of iterations, for now 1000
				var maxNumIterations:Int = 1000;
				var currentIterationCount:Int = 0;
				var finalText:String = value;
				var maxTextWidth:Int = Std.int(this.width - 4);
				//    //no space                          //still having under max count              //still having text to remove
				while ((this.textWidth > maxTextWidth) && currentIterationCount < maxNumIterations && finalText != "") {
					if (currentIterationCount == 0) {
						finalText = finalText.substr(0, Std.int(Math.max(0, finalText.length - _truncationValue.length)));
					} else {
						finalText = finalText.substr(0, Std.int(Math.max(0, finalText.length - 1)));
					}
					this.text = finalText + _truncationValue;
					this.setTextFormat(_initialTextFormat);

					currentIterationCount++;
				}
			}
			
			if (this.embedFonts == false) {
				Logger.warning(this, "Unable to use embedFonts for fontName '" + _initialFontName + "', skinObj.textFormat = " + skinObj.textFormat);
			}
		}
		
		centerContentsOnY();
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	/** reposition this.y in order to be centered */
	@:final
	private function centerContentsOnY():Void
	{
		if (_centerOnY && this.textHeight > 0) {
			this.y = Math.round(skinObj.y + (skinObj.height - this.textHeight) / 2 - FONT_OFFSET / 2);
		}
	}
	
	@:final
	private function replaceSpecialCharacters(text:String):String
	{
		if (text != null && text.indexOf("|") != -1) {
			text = text.split("|").join("\n");
		}

		return text;
	}
	
	// ====================================================================================================================================
	// STATIC
	// ====================================================================================================================================
	
	/** Make an update on textfields from container with the standard text based on skinnableData current language */
	@:final
	public static function recursiveUpdateLanguageTexts(container:DisplayObject):Void
	{
		if (Std.is(container, TextFieldSkinnable)) {
			var tf:TextFieldSkinnable = cast container;
			tf.setText(tf.getInitialText());
		}

		if (Std.is(container, DisplayObjectContainer)) {
			var dObjCont:DisplayObjectContainer = cast container;
			var numChildren:Int = dObjCont.numChildren;
			for (i in 0...numChildren) {
				recursiveUpdateLanguageTexts(dObjCont.getChildAt(i));
			}
		}
	}
	
	// ====================================================================================================================================
	// GETTERS, SETTERS
	// ====================================================================================================================================
	
	@:final
	function get_skinObj():ISkinObject { return skinObj; }
}