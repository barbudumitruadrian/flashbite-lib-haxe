package editor.xml;

import editor.xml.data.XmlEditorData;
import editor.xml.event.XmlEditorEvent;
import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.text.TextFieldSkinnable;
import openfl.Assets;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextFieldType;

/**
 * XmlEditor will handle the show and edit of the xml to render in preview.
 * Also, it will handle the errors and propagate them.
 * 
 * @author Adrian Barbu
 */
@:final
class XmlEditor extends EditorComponentViewBase
{
	private var _data:XmlEditorData = new XmlEditorData();
	
	private var _textField:TextFieldSkinnable;
	private var _button:ContainerBase;
	
	private var _forceCheckText:Bool = true;
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new() { super(EditorComponentViewNames.XML); }
	
	override public function dispose():Void
	{
		if (_data != null) {
			_data.dispose();
			_data = null;
		}
		if (_textField != null) {
			_textField.removeEventListener(Event.CHANGE, onTextChanged);
			_textField = null;
		}
		if (_button != null) {
			_button.removeEventListener(MouseEvent.CLICK, onButtonClick);
			_button = null;
		}
		
		super.dispose();
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	override public function initialize():Void
	{
		super.initialize();
		
		_textField = cast HelpersGlobal.getChildByName(this, "up.textField");
		_textField.type = TextFieldType.INPUT;
		_textField.setText("");
		
		_button = cast HelpersGlobal.getChildByName(this, "bottom.button");
		_button.addEventListener(MouseEvent.CLICK, onButtonClick, false, 0, true);
	}
	
	public function startUpdating():Void
	{
		var initialText:String = Assets.getText("assets/editor/" + _name + "/startupValue.xml");
		initialText = initialText.split("\n").join("");
		_textField.setText(initialText);
		
		update();
		
		_textField.addEventListener(Event.CHANGE, onTextChanged, false, 0, true);
	}
	
	override public function resize(newWidth:Float, newHeight:Float):Void
	{
		_forceCheckText = false;
		_textField.removeEventListener(Event.CHANGE, onTextChanged);
		
		var textValue = _textField.text;
		super.resize(newWidth, newHeight);
		_textField.setText(textValue);
		
		_textField.addEventListener(Event.CHANGE, onTextChanged, false, 0, true);
		_forceCheckText = true;
	}
	
	// =====================================================================================================================================
	// PRIVATE
	// =====================================================================================================================================
	
	private function update():Void
	{
		var textIsOk = _data.setNewString(_textField.text);
		
		//this is the case when we check the textField when text changes
		//in this case, if the text is wrong but we don't force the check, we do nothing
		if (_forceCheckText == false && textIsOk == false) {
			return;
		}
		
		if (textIsOk) {
			EditorConsts.dispatcher.dispatchEvent(new XmlEditorEvent(XmlEditorEvent.PARSE_OK, _data.xml));
		} else {
			var message:String = _data.lastError.message;
			
			EditorConsts.dispatcher.dispatchEvent(new XmlEditorEvent(XmlEditorEvent.PARSE_NOK, message));
		}
	}
	
	private function onButtonClick(e:MouseEvent):Void
	{
		_forceCheckText = true;
		update();
	}
	
	private function onTextChanged(e:Event):Void
	{
		_forceCheckText = false;
		update();
		_forceCheckText = true;
		
		//this must be done to update the the auto-size of text
		_textField.removeEventListener(Event.CHANGE, onTextChanged);
		_textField.setText(_textField.text);
		_textField.addEventListener(Event.CHANGE, onTextChanged, false, 0, true);
	}
}