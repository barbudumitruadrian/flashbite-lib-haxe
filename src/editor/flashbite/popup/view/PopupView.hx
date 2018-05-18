package editor.flashbite.popup.view;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.text.TextFieldSkinnable;

/**
 * PopupView is the popup that will be shown at center
 * 
 * @author Adrian Barbu
 */
@:final
class PopupView extends ContainerBase
{
	public static inline var SKIN_NAME:String = "PopupView";
	
	private var _textField:TextFieldSkinnable;
	private var _message:String = "";
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) 
	{
		super(skinObj, skinnableData);
	}
	
	override public function dispose():Void 
	{
		_textField = null;
		_message = null;
		
		super.dispose();
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	public function initialize():Void
	{
		_textField = cast HelpersGlobal.getChildByName(this, "textField");
		updateText();
	}
	
	public function show(message:String):Void
	{
		_message = message;
		updateText();
	}
	
	override public function redraw():Void 
	{
		super.redraw();
		
		updateText();
	}
	
	// =====================================================================================================================================
	// PRIVATE
	// =====================================================================================================================================
	
	private function updateText():Void
	{
		if (_textField != null) {
			_textField.setText(_message);
		}
	}
}