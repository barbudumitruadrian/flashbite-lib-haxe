package editor.flashbite;

import editor.flashbite.EditorConsts;
import editor.flashbite.dispatcher.EditorDispatcher;
import editor.flashbite.popup.PopupManager;
import editor.flashbite.popup.event.PopupManagerEvent;
import editor.flashbite.preview.Preview;
import editor.flashbite.preview.event.PreviewEvent;
import editor.flashbite.xml.XmlEditor;
import editor.flashbite.xml.event.XmlEditorEvent;
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
	private var _xmlEditor:XmlEditor;
	private var _preview:Preview;
	private var _popupManager:PopupManager;
	
	public function new() { super(); }
	
	public function initializeAndStart():Void
	{
		//constants
		EditorConsts.dispatcher = new EditorDispatcher();
		
		//views
		_xmlEditor = new XmlEditor();
		this.addChild(_xmlEditor);
		_xmlEditor.initialize();
		
		_preview = new Preview();
		this.addChild(_preview);
		_preview.initialize();
		
		_popupManager = new PopupManager();
		this.addChild(_popupManager);
		_popupManager.initialize();
		
		//a resize
		onStageResize(null);
		stage.addEventListener(Event.RESIZE, onStageResize);
		
		//wait for events
		var allEventNames:Array<String> = [];
		allEventNames = allEventNames.concat(XmlEditorEvent.getAll());
		allEventNames = allEventNames.concat(PreviewEvent.getAll());
		allEventNames = allEventNames.concat(PopupManagerEvent.getAll());
		for (eventName in allEventNames) {
			EditorConsts.dispatcher.addEventListener(eventName, onEvent);
		}
		
		//start the xml editor at last
		_xmlEditor.startUpdating();
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
					//hide popup
					EditorConsts.dispatcher.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.CLOSE));
					//redraw
					EditorConsts.dispatcher.dispatchEvent(new PreviewEvent(PreviewEvent.RENDER, xmlEditorEvent.xml));
				case XmlEditorEvent.PARSE_NOK:
					//popup with error
					EditorConsts.dispatcher.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.OPEN, xmlEditorEvent.message));
				default:
					throw new Error("unmanaged XmlEditorEvent " + e.type);
			}
		} else if (Std.is(e, PreviewEvent)) {
			var previewEvent:PreviewEvent = cast e;
			
			switch (previewEvent.type) {
				case PreviewEvent.RENDER:
					_preview.render(previewEvent.styleXml);
				case PreviewEvent.RENDER_ERROR:
					EditorConsts.dispatcher.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.OPEN, previewEvent.message));
				default:
					throw new Error("unmanaged PreviewEvent " + e.type);
			}
		} else if (Std.is(e, PopupManagerEvent)) {
			var popupManagerEvent:PopupManagerEvent = cast e;
			
			switch (popupManagerEvent.type) {
				case PopupManagerEvent.OPEN:
					_popupManager.open(popupManagerEvent.message);
				case PopupManagerEvent.CLOSE:
					_popupManager.close();
				default:
					throw new Error("unmanaged PopupManagerEvent " + e.type);
			}
		} else {
			throw new Error("unmanaged Event " + e.type);
		}
	}
}