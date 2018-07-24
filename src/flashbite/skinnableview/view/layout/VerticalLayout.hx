package flashbite.skinnableview.view.layout;

import flashbite.align.HorizontalAlign;
import flashbite.align.VerticalAlign;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import openfl.display.DisplayObject;

/**
 * Positions items from top to bottom in a single column.
 * 
 * Warning: this is a beta version, it can't adjust the internal views dimensions; so make sure you provide enough space on subItems;
 * If any child is removed or added or you change his data (padding, horizontalAlign, etc), you must call redraw() after.
 * 
 * @author Adrian Barbu
 */
@:final
class VerticalLayout extends LayoutBase
{
	// ====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// ====================================================================================================================================
	
	public function new(skinObj:ISkinObject, skinnableData:ISkinnableData)
	{
		super(skinObj, skinnableData);
	}
	
	// ====================================================================================================================================
	// PRIVATE = PROTECTED
	// ====================================================================================================================================
	
	override private function arrangeChildren():Void
	{
		//first check if all the items can enter in
		var itemsTotalWidth:Float = children[0].skinObj.width;
		var itemsTotalHeight:Float = 0;
		for (skinView in children) {
			itemsTotalHeight += skinView.skinObj.height;
		}
		
		var availableWidth:Float = skinObj.width - 2 * layoutData.padding;
		var availableHeight:Float = skinObj.height - ((children.length + 1) * layoutData.padding);
		
		//if not, substract their width and height
		if (availableHeight < itemsTotalHeight || availableWidth < itemsTotalWidth) {
			//TODO: to integrate it
			Logger.warning(this, "Since is a beta version of a layout, he can't adjust the internal views dimensions...");
			Logger.warning(this, "availableHeight = " + availableHeight + ", itemsTotalHeight = " + itemsTotalHeight + ", availableWidth = " + availableWidth + ", itemsTotalWidth = " + itemsTotalWidth);
		}
		
		//now arrange them
			//x
		var paddingX:Float = layoutData.padding;
		var posX:Float = 0;
		switch (layoutData.horizontalAlign) {
			case HorizontalAlign.LEFT:
				posX = paddingX;
			case HorizontalAlign.RIGHT:
				posX = skinObj.width - children[0].skinObj.width - paddingX;
			case HorizontalAlign.CENTER:
				posX = Math.round((skinObj.width - children[0].skinObj.width) / 2);
		}
		
			//y
		var paddingY:Float = layoutData.padding;
		var startPosY:Float = 0;
		if (layoutData.autoSizePadding) {
			paddingY = Math.round((skinObj.height - itemsTotalHeight) / (children.length + 1));
		}
		switch (layoutData.verticalAlign) {
			case VerticalAlign.TOP:
				startPosY = paddingY;
			case VerticalAlign.BOTTOM:
				startPosY = skinObj.height - itemsTotalHeight - children.length * paddingY;
			case VerticalAlign.CENTER:
				startPosY = Math.round((skinObj.height - (itemsTotalHeight + (Math.max(children.length - 1, 0) * paddingY))) / 2);
		}
		for (skinView in children) {
			(cast (skinView, DisplayObject)).x = posX;
			(cast (skinView, DisplayObject)).y = startPosY;
			startPosY += skinView.skinObj.height + paddingY;
		}
	}
}