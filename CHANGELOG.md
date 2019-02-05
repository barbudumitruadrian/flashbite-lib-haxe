1.5.1 (05/02/2019)
------------------
* TextFieldSkinnable - removing warning log for non-embed Font if the text is empty;
* SkinnableViewCreator - adding global value for the number of elements created;
* ISkinObject - added posibility to change internal values with updateProperty function.

1.5.0 (22/01/2019)
------------------
* update to OpenFL 8.8.0 and Lime 7.2.1


1.4.1 (05/10/2018)
------------------
* ShapeSkinnable - now is using a Bitmap in order be visible when a BitmapData.draw is performed on it.


1.4.0 (23/07/2018)
------------------
* added beta versions of HorizontalLayout and VerticalLayout in order to show items into a simple layout + test cases + examples.
* fixing setter of color in ShapeSkinnable, Image9SliceSkinnable, ImageSkinnable, MovieClipSkinnable and TextFieldWithColorSkinnable + adding test cases.


1.3.3 (06/07/2018)
------------------
* SkinnableViewCreator - updated constructChild to calculate itself the dimensions of the child to create.


1.3.2 (02/07/2018)
------------------
* SkinnableViewCreator - updated elementConstruct to accept also an ISkinnableView as a constructed view;
* TextFieldWithValueSkinnable - updated setValue function to accept also newText as a parameter.


1.3.1 (02/07/2018)
------------------
* Image9SliceSkinnable - added possibility to change his dimensions by code (setWidthAndHeight function) + test case + updated example.


1.3.0 (29/06/2018)
------------------
* added Image9SliceSkinnable - a 9 slice image that scales without distortion;
* updated TextFieldWithColorSkinnableTestCase to test also on cpp and html5;
* added also example with Image9SliceSkinnable + test case.


1.2.0 (12/06/2018)
------------------
* added TextFieldWithColorSkinnable for changing realtime the color of a textField.


1.1.1 (25/05/2018)
------------------
* cpp target : fixing HelpersGlobal.getCaseInsensitivePropValue function + updating some test cases.


1.1.0 (18/05/2018)
------------------
* added SimpleButton for showing a simple button that will dispatch a TRIGGERED event when he was clicked;
* updated SkinnableViewCreator destruct function to accept a container and to dispose any created ISkinnableView child;
* updated SkinnableViewCreator elementConstruct function to create correctly any other ContainerBase extended class (such as SimpleButton);
* TextFieldSkinnable - deactivate mouse interaction by default;
* updated some functions to be real private (with @:final tag).
* added editor.


1.0.1 (11/05/2018)
------------------
* improved centering of text contents using centerOnY in TextFieldSkinnable;


1.0.0 (04/05/2018)
------------------
* Initial release.