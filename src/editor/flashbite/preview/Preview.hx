package editor.flashbite.preview;

import editor.flashbite.preview.event.PreviewEvent;
import flashbite.helpers.HelpersGlobal;
import flashbite.skinnableview.ISkinnableViewCreator;
import flashbite.skinnableview.SkinnableViewCreator;
import flashbite.skinnableview.view.ContainerBase;
import openfl.errors.Error;

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
		
		try {
			_previewCreator = new SkinnableViewCreator();
			_previewCreator.initialize(styleXml, null, null, EditorConsts.language, _container.skinObj.width, _container.skinObj.height);
			_previewCreator.construct(_container, EditorComponentViewBase.SCREEN_NAME, _container.skinObj.width, _container.skinObj.height);
		} catch (e:Error) {
			destructCreatedObjects();
			
			var message:String = "Error while creating views \n" + e.message;
			
			EditorConsts.dispatcher.dispatchEvent(new PreviewEvent(PreviewEvent.RENDER_ERROR, message));
		}
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
		if (_container != null && _previewCreator != null) {
			_previewCreator.destruct(_container);
			_previewCreator.dispose();
			_previewCreator = null;
			
			_container.removeChildren();
		}
	}
}