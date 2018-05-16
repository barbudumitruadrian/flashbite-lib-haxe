package editor.xml;

import editor.xml.data.XmlEditorData;
import editor.xml.event.XmlEditorEvent;

/**
 * XmlEditor will handle the show and edit of the xml to render in preview.
 * Also, it will handle the errors and will show a 
 * 
 * @author Adrian Barbu
 */
@:final
class XmlEditor extends EditorComponentViewBase
{
	private var START_STRING:String = 
	'<?xml version="1.0" encoding="utf-8"?>' +
	'<style>' +
		'<texts/>' +
		'<textFormats/>' +
		'<screens>' +
			'<screen name="main">' +
				'<style/>' +
			'</screen>' +
		'</screens>' +
	'</style>';
	
	private var _data:XmlEditorData = new XmlEditorData();
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new() { super("xml"); }
	
	override public function dispose():Void
	{
		if (_data != null) {
			_data.dispose();
			_data = null;
		}
		
		super.dispose();
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	override public function initializeAndStart():Void
	{
		super.initializeAndStart();
	}
	
	public function realStart():Void
	{
		update(START_STRING);
	}
	
	private function update(string:String):Void
	{
		if (_data.setNewString(string)) {
			EditorConsts.dispatcher.dispatchEvent(new XmlEditorEvent(XmlEditorEvent.PARSE_OK));
		} else {
			//TODO: update the message
			var message:String = _data.lastError.message;
			
			EditorConsts.dispatcher.dispatchEvent(new XmlEditorEvent(XmlEditorEvent.PARSE_NOK, message));
		}
	}
}