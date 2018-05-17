package editor.preview;

import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.ContainerBase;
import flashbite.skinnableview.view.ISkinnableView;

/**
 * Preview is view that will show the contents from Xml
 * 
 * @author Adrian Barbu
 */
@:final
class Preview extends EditorComponentViewBase
{
	private var _container:ContainerBase;
	
	private var _previewCreator:ISkinnableViewCreator;
	
	// =====================================================================================================================================
	// CONSTRUCTOR, DESTRUCTOR
	// =====================================================================================================================================
	
	public function new() { super(EditorComponentViewNames.PREVIEW); }
	
	override public function dispose():Void
	{
		destructCreatedObjects();
		_container = null;
		
		super.dispose();
	}
	
	// =====================================================================================================================================
	// PUBLIC
	// =====================================================================================================================================
	
	override public function initialize():Void
	{
		super.initialize();
		
		_container = cast HelpersGlobal.getChildByName(this, "container");
	}
	
	public function render(styleXml:Xml):Void
	{
		destructCreatedObjects();
		
		_previewCreator = new SkinnableViewCreator();
		_previewCreator.initialize(styleXml, null, null, EditorConsts.language, _container.skinObj.width, _container.skinObj.height);
		_previewCreator.construct(_container, EditorComponentViewBase.SCREEN_NAME, _container.skinObj.width, _container.skinObj.height);
	}
	
	override public function resize(newWidth:Float, newHeight:Float):Void 
	{
		super.resize(newWidth, newHeight);
		
		if (_previewCreator != null && _container != null) {
			_previewCreator.resize(_container, EditorComponentViewBase.SCREEN_NAME, _container.skinObj.width, _container.skinObj.height);
		}
	}
	
	// =====================================================================================================================================
	// PRIVATE
	// =====================================================================================================================================
	
	private function destructCreatedObjects():Void
	{
		if (_container != null) {
			//dispose any added skinnableView children
			var skinnableViewChildren:Array<ISkinnableView> = [];
			for (childIndex in 0..._container.numChildren) {
				var child = _container.getChildAt(childIndex);
				if (Std.is(child, ISkinnableView)) {
					skinnableViewChildren.push(cast child);
				}
			}
			for (child in skinnableViewChildren) {
				child.removeFromParent(true);
			}
			//remove any left child
			_container.removeChildren();
		}
		
		if (_previewCreator != null) {
			_previewCreator.dispose();
			_previewCreator = null;
		}
	}
}