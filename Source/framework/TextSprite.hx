package framework;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Nickan
 */
class TextSprite extends Sprite
{
	var _textField :TextField;
	var _size :Float;
	var _color :Int;
	
	public function new(size :Float = 30, color :Int = 0xFFFFFF) 
	{
		super();
		_size = size;
		_color = color;
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.ENTER_FRAME, onUpdate);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupTextField();
	}
	
	function setupTextField() 
	{
		var textFormat = new TextFormat("Verdana", _size, _color, true);
		//textFormat.align = TextFormatAlign.LEFT;
		
		_textField = new TextField();
		_textField.defaultTextFormat = textFormat;
		_textField.autoSize = TextFieldAutoSize.LEFT;
		//_textField.width = stage.stageWidth;
		addChild(_textField);
	}
	
	
	private function onUpdate(e:Event):Void 
	{
		
	}

	public function setTextFieldAutoSize(autoSize :TextFieldAutoSize) {
		_textField.autoSize = autoSize;
	}
	
	public function showText(text :String) {
		_textField.text = text;
	}
}