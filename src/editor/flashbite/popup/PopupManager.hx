package editor.flashbite.popup;

import editor.flashbite.EditorComponentViewNames;
import editor.flashbite.EditorConsts;
import editor.flashbite.popup.event.PopupManagerEvent;
import editor.flashbite.popup.view.PopupView;
import flashbite.helpers.HelpersGlobal;
import openfl.events.MouseEvent;

/**
 * PopupManager manage the show of a popup
 * 
 * @author Adrian Barbu
 */
@:final
class PopupManager extends EditorComponentViewBase
{
	private var _view:PopupView;
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new() { super(EditorComponentViewNames.POPUP); }
	
	override public function dispose():Void
	{
		_view = null;
		this.removeEventListener(MouseEvent.CLICK, onClick);
		
		super.dispose();
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	override public function initialize():Void
	{
		super.initialize();
		
		_view = cast HelpersGlobal.getChildByName(this, "view");
		_view.initialize();
	}
	
	public function open(message:String = ""):Void
	{
		this.visible = true;
		_view.show(message);
		
		this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
	}
	
	public function close():Void
	{
		this.visible = false;
		this.removeEventListener(MouseEvent.CLICK, onClick);
	}
	
	// =====================================================================================================================================
	// PRIVATE (PROTECTED)
	// =====================================================================================================================================
	
	override function registerCustomObjectsInSkinnable():Void 
	{
		super.registerCustomObjectsInSkinnable();
		
		_skinnableViewCreator.registerCustomDisplayObjectContainer(PopupView.SKIN_NAME, PopupView);
	}
	
	// =====================================================================================================================================
	// PRIVATE
	// =====================================================================================================================================
	
	private function onClick(e:MouseEvent):Void 
	{
		EditorConsts.dispatcher.dispatchEvent(new PopupManagerEvent(PopupManagerEvent.CLOSE));
	}
}