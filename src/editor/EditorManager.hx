package editor;

import editor.dispatcher.EditorDispatcher;
import editor.popup.PopupManager;
import editor.preview.Preview;
import editor.xml.XmlEditor;
import editor.xml.event.XmlEditorEvent;
import flashbite.logger.Logger;
import openfl.display.Sprite;
import openfl.errors.Error;
import openfl.events.Event;

/**
 * Editor is the global class that will handle the editing and previewing of a screen
 * 
 * @author Adrian Barbu
 */
@:final
class EditorManager extends Sprite
{
	private var _xmlEditor:EditorComponentViewBase;
	private var _preview:EditorComponentViewBase;
	private var _popupManager:EditorComponentViewBase;
	
	public function new() { super(); }
	
	public function initializeAndStart():Void
	{
		//constants
		EditorConsts.dispatcher = new EditorDispatcher();
		
		//views
		_xmlEditor = new XmlEditor();
		this.addChild(_xmlEditor);
		_xmlEditor.initializeAndStart();
		
		_preview = new Preview();
		this.addChild(_preview);
		_preview.initializeAndStart();
		
		_popupManager = new PopupManager();
		this.addChild(_popupManager);
		_popupManager.initializeAndStart();
		
		//a resize
		onStageResize(null);
		stage.addEventListener(Event.RESIZE, onStageResize);
		
		//wait for events
		var allEventNames:Array<String> = [];
		allEventNames = allEventNames.concat(XmlEditorEvent.getAll());
		for (eventName in allEventNames) {
			EditorConsts.dispatcher.addEventListener(eventName, onEvent);
		}
		
		//start the xml editor at last
		(cast (_xmlEditor, XmlEditor)).realStart();
	}
	
	private function onStageResize(e:Event):Void
	{
		var newWidth:Float = stage.stageWidth;
		var newHeight:Float = stage.stageHeight;
		
		Logger.debug(this, "onStageResize newWidth = " + newWidth + ", newHeight = " + newHeight);
		
		_xmlEditor.resize(newWidth / 2, newHeight);
		_preview.resize(newWidth / 2, newHeight); _preview.x = newWidth / 2;
		_popupManager.resize(newWidth, newHeight);
	}
	
	private function onEvent(e:Event):Void
	{
		Logger.debug(this, "onEvent " + e.type);
		
		if (Std.is(e, XmlEditorEvent)) {
			var xmlEditorEvent:XmlEditorEvent = cast e;
			
			switch (xmlEditorEvent.type) {
				case XmlEditorEvent.PARSE_OK:
					//redraw 
				case XmlEditorEvent.PARSE_NOK:
					//popup with error
				default:
					throw new Error("unmanaged XmlEditorEvent " + e.type);
			}
		} else {
			throw new Error("unmanaged Event " + e.type);
		}
	}
}