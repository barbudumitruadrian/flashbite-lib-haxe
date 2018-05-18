package editor.dispatcher;

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
}