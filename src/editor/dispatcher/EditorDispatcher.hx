package editor.dispatcher;

import flashbite.logger.Logger;
import openfl.events.Event;
import openfl.events.EventDispatcher;

/**
 * Manager for event propagation in Editor
 * 
 * @author Adrian Barbu
 */
@:final
class EditorDispatcher extends EventDispatcher implements IEditorDispatcher
{
	public function new() { super(); }
	
	override public function dispatchEvent(event:Event):Bool
	{
		Logger.debug(this, "dispatchEvent " + event.type);
		if (hasEventListener(event.type) == false) {
			Logger.warning(this, "this event isn't listened!!!");
		}
		
		return super.dispatchEvent(event);
	}
}