package editor.dispatcher;

import openfl.events.Event;

/**
 * This is the interface for event propagation in EditorManager
 * 
 * @author Adrian Barbu
 */
interface IEditorDispatcher
{
	public function addEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false, priority:Int = 0, useWeakReference:Bool = false):Void;
	public function dispatchEvent(event:Event):Bool;
	public function removeEventListener(type:String, listener:Dynamic->Void, useCapture:Bool = false):Void;
}