package flashbite.skinnableview.view;

import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;

/**
 * ContainerBase class; Base class to be used to create a container in ISkinnableViewCreator
 * 
 * @author Adrian Barbu
 */
class ContainerBase extends ViewBase
{
	public var children(get, null):Array<ISkinnableView> = [];
	
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super(skinObj, skinnableData);
	}
	
	override public function dispose():Void
	{
		//recursive dispose
		if (children != null) {
			var childrenClone = children.copy();
			for (child in childrenClone) {
				child.removeFromParent(true);
			}
			children = null;
		}
		//this isn't necessary since all the children added will be disposed and they will be of type ISkinnableView
		this.removeChildren();
		
		super.dispose();
	}
	
	// ====================================================================================================================================
	// Redraw
	// ====================================================================================================================================
	
	override public function redraw():Void
	{
		super.redraw();
		
		this.rotation = skinObj.rotation;
	}
	
	// ====================================================================================================================================
	// PRIVATE
	// ====================================================================================================================================
	
	@:final
	private function updateChildren():Void
	{
		var childrenNow:Array<ISkinnableView> = [];
		for (childIndex in 0...this.numChildren) {
			var child = this.getChildAt(childIndex);
			if (Std.is(child, ISkinnableView)) {
				childrenNow.push(cast child);
			}
		}
		
		children = childrenNow;
	}
	
	// ====================================================================================================================================
	// GETTERS
	// ====================================================================================================================================
	
	@:final
	function get_children():Array<ISkinnableView>
	{
		//realtime update of children
		updateChildren();
		
		return children;
	}
}