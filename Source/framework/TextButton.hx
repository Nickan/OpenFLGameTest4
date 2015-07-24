package framework;
import openfl.display.DisplayObject;
import openfl.display.SimpleButton;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFieldAutoSize;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

/**
 * ...
 * @author Nickan
 */
class TextButton extends Sprite
{
	var _text :String;
	var _textToReturn :String;
	var _simpleButton :SimpleButton;
	var _functionToCallOnButtonDown :Void->Void;
	
	public function new(text :String, upState :DisplayObject = null, overState :DisplayObject = null, 
							downState :DisplayObject = null, hitTestState :DisplayObject = null, 
							functionToCallOnButtonDown :Void->Void) 
	{
		super();
		//super(upState, overState, downState, hitTestState);
		_simpleButton = new SimpleButton(upState, overState, downState, hitTestState);
		_text = text;
		_functionToCallOnButtonDown = functionToCallOnButtonDown;
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupSimpleButton();
		setupText();
	}
	
	function setupSimpleButton() 
	{
		addChild(_simpleButton);
		if (_simpleButton.hitTestState == null)
			_simpleButton.hitTestState = _simpleButton.upState;
		_simpleButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
	}
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		_functionToCallOnButtonDown();
	}
	
	function setupText() 
	{
		var textFormat = new TextFormat("Verdana", 25, 0xFFFFFF);
		
		var textField = new TextField();
		//textField.width = _simpleButton.width;
		textField.defaultTextFormat = textFormat;
		textField.autoSize = TextFieldAutoSize.CENTER;
		textField.text = _text;
		textField.mouseEnabled = false;
		addChild(textField);
		var bounds = getBounds(this);
		textField.x = bounds.width * 0.5 - (textField.width * 0.5);
		textField.y = bounds.height * 0.5 - (textField.height * 0.5);
	}
	
	public function dispose() {
		_simpleButton.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeChildren();
		_functionToCallOnButtonDown = null;
	}
	
}