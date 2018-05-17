package editor;

import editor.dispatcher.IEditorDispatcher;

/**
 * EditorConsts will hold all global constats
 * 
 * @author Adrian Barbu
 */
@:final
class EditorConsts 
{
	public static var dispatcher:IEditorDispatcher;
	public static inline var language:String = "en";
	
	private function new() {}
}