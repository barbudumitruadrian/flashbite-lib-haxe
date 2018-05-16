package editor.popup.view;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import flashbite.skinnableview.view.ContainerBase;

/**
 * ...
 * @author Adrian Barbu
 */
@:final
class PopupView extends ContainerBase 
{

	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData) 
	{
		super(skinObj, skinnableData);
	}
	
	override public function dispose():Void 
	{
		//internals
		
		super.dispose();
	}
}