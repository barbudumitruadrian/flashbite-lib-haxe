package flashbite.skinnableview.view.layout;

import flashbite.align.HorizontalAlign;
import flashbite.align.VerticalAlign;
import flashbite.logger.Logger;
import flashbite.skinnableview.model.ISkinnableData;
import flashbite.skinnableview.model.skinstyle.ISkinObject;
import openfl.display.DisplayObject;

/**
 * Positions items from left to right in a single row.
 * 
 * Warning: this is a beta version, it can't adjust the internal views dimensions; so make sure you provide enough space on subItems;
 * If any child is removed or added or you change his data (padding, horizontalAlign, etc), you must call redraw() after.
 * 
 * @author Adrian Barbu
 */
@:final
class HorizontalLayout extends LayoutBase
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
		var itemsTotalWidth:Float = 0;
		var itemsTotalHeight:Float = children[0].skinObj.height;
		for (skinView in children) {
			itemsTotalWidth += skinView.skinObj.width;
		}
		
		var availableWidth:Float = skinObj.width - ((children.length + 1) * layoutData.padding);
		var availableHeight:Float = skinObj.height - 2 * layoutData.padding;
		
		//if not, substract their width and height
		if (availableHeight < itemsTotalHeight || availableWidth < itemsTotalWidth) {
			//TODO: to integrate it
			Logger.warning(this, "Since is a beta version of a layout, he can't adjust the internal views dimensions...");
			Logger.warning(this, "availableHeight = " + availableHeight + ", itemsTotalHeight = " + itemsTotalHeight + ", availableWidth = " + availableWidth + ", itemsTotalWidth = " + itemsTotalWidth);
		}
		
		//now arrange them
			//y
		var paddingY:Float = layoutData.padding;
		var posY:Float = 0;
		switch (layoutData.verticalAlign) {
			case VerticalAlign.TOP:
				posY = paddingY;
			case VerticalAlign.BOTTOM:
				posY = skinObj.height - children[0].skinObj.height - paddingY;
			case VerticalAlign.CENTER:
				posY = Math.round((skinObj.height - children[0].skinObj.height) / 2);
		}
		
			//x
		var paddingX:Float = layoutData.padding;
		var startPosX:Float = 0;
		if (layoutData.autoSizePadding) {
			paddingX = Math.round((skinObj.width - itemsTotalWidth) / (children.length + 1));
		}
		switch (layoutData.horizontalAlign) {
			case HorizontalAlign.LEFT:
				startPosX = paddingX;
			case HorizontalAlign.RIGHT:
				startPosX = skinObj.width - itemsTotalWidth - children.length * paddingX;
			case HorizontalAlign.CENTER:
				startPosX = Math.round((skinObj.width - (itemsTotalWidth + (Math.max(children.length - 1, 0) * paddingX))) / 2);
		}
		for (skinView in children) {
			(cast (skinView, DisplayObject)).x = startPosX;
			(cast (skinView, DisplayObject)).y = posY;
			startPosX += skinView.skinObj.width + paddingX;
		}
	}
}