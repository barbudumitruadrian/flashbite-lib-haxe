package tests;

import haxe.unit.TestRunner;
import tests.flashbite.helpers.HelpersDateTestCase;
import tests.flashbite.helpers.HelpersGlobalTestCase;
import tests.flashbite.helpers.HelpersMathTestCase;
import tests.flashbite.helpers.HelpersStringTestCase;
import tests.flashbite.helpers.HelpersXmlTestCase;
import tests.flashbite.skinnableview.SkinnableViewCreatorTestCase;
import tests.flashbite.skinnableview.SkinnableViewCreator_RESIZE_TestCase;
import tests.flashbite.skinnableview.SkinnableViewCreator_RESIZE_propagation_TestCase;
import tests.flashbite.skinnableview.model.SkinnableDataTestCase;
import tests.flashbite.skinnableview.model.skinstyle.RawObjectTestCase;
import tests.flashbite.skinnableview.model.skinstyle.SkinObjectTestCase;
import tests.flashbite.skinnableview.model.skinstyle.TextFormatsTestCase;
import tests.flashbite.skinnableview.model.texts.TextsTestCase;
import tests.flashbite.skinnableview.view.ContainerBaseTestCase;
import tests.flashbite.skinnableview.view.button.SimpleButtonTestCase;
import tests.flashbite.skinnableview.view.image.Image9SliceSkinnableTestCase;
import tests.flashbite.skinnableview.view.image.ImageSkinnableTestCase;
import tests.flashbite.skinnableview.view.movieclip.MovieClipSkinnableTestCase;
import tests.flashbite.skinnableview.view.text.TextFieldSkinnableTestCase;
import tests.flashbite.skinnableview.view.text.TextFieldWithColorSkinnableTestCase;
import tests.flashbite.skinnableview.view.text.TextFieldWithValueSkinnableTestCase;

/**
 * FlashbiteTestRunner is the runner for all test cases on flashbite-lib-haxe
 * 
 * @author Adrian Barbu
 */
@:final
class FlashbiteTestRunner extends TestRunner
{
	public function new() { super(); }
	
	override public function run():Bool
	{
		addTests();
		
		return super.run();
	}
	
	private function addTests():Void
	{
		//flashbite.helpers
		add(new HelpersDateTestCase());
		add(new HelpersGlobalTestCase());
		add(new HelpersMathTestCase());
		add(new HelpersStringTestCase());
		add(new HelpersXmlTestCase());
		
		//flashbite.skinnableview
		add(new SkinnableViewCreatorTestCase());
		add(new SkinnableViewCreator_RESIZE_TestCase());
		add(new SkinnableViewCreator_RESIZE_propagation_TestCase());
		
		//flashbite.skinnableview.model
		add(new SkinnableDataTestCase());
		add(new RawObjectTestCase());
		add(new SkinObjectTestCase());
		add(new TextFormatsTestCase());
		add(new TextsTestCase());
		
		//flashbite.skinnableview.view
		add(new ContainerBaseTestCase());
		add(new SimpleButtonTestCase());
		add(new ContainerBaseTestCase());
		add(new Image9SliceSkinnableTestCase());
		add(new ImageSkinnableTestCase());
		add(new MovieClipSkinnableTestCase());
		add(new TextFieldSkinnableTestCase());
		add(new TextFieldWithColorSkinnableTestCase());
		add(new TextFieldWithValueSkinnableTestCase());
	}
}