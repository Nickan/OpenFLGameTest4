package screen_sprite;
import framework.Screen;
import framework.ScreenManager;
import framework.TextButton;
import haxe.Timer;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.DisplayObject;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class TitleScreen extends Screen
{
	var _titleBitmap :Bitmap;
	var POP_UP_DURATION :Float = 0.4;
	var _playButton :TextButton;
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupBackground();
		Timer.delay(showTitle, 750);
	}
	
	function setupBackground() 
	{
		var bg = new Bitmap(Assets.getBitmapData("assets/asset_title_bg.png"));
		addChild(bg);
	}
	
	function showTitle() 
	{
		_titleBitmap = new Bitmap(Assets.getBitmapData("assets/asset_title.png"));
		addChild(_titleBitmap);
		_titleBitmap.x = (stage.stageWidth * 0.5) - (_titleBitmap.width * 0.5);
		_titleBitmap.y = (stage.stageHeight * 0.4) - (_titleBitmap.height * 0.5);
		
		playPopUp(_titleBitmap, POP_UP_DURATION);
		Timer.delay(showPlayButton, Std.int(POP_UP_DURATION * 1000));
	}
	
	function showPlayButton() 
	{
		_playButton = new TextButton("Play", new Bitmap(Assets.getBitmapData("assets/asset_large_btn_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_large_btn_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_large_btn_down.png")), null, onPlay);	
		
		addChild(_playButton);
		_playButton.x = stage.stageWidth * 0.5 - (_playButton.width * 0.5);
		_playButton.y = (stage.stageHeight * 0.6) - (_playButton.height * 0.5);
		playPopUp(_playButton, POP_UP_DURATION);
	}
	
	function onPlay() 
	{
		playShrink(_playButton, POP_UP_DURATION);
		Timer.delay(goToGameScreen, Std.int(POP_UP_DURATION * 1000));
	}

	function playPopUp(displayObject :DisplayObject, popUpDuration :Float) 
	{
		var originalX = displayObject.x;
		var originalY = displayObject.y;
		
		displayObject.x = originalX + displayObject.width * 0.5;
		displayObject.y = originalY + displayObject.height * 0.5;
		displayObject.scaleX = 0;
		displayObject.scaleY = 0;
		Actuate.tween(displayObject, popUpDuration, { scaleX :1 } );
		Actuate.tween(displayObject, popUpDuration, { scaleY :1 } );
		Actuate.tween(displayObject, popUpDuration, { x :originalX } );
		Actuate.tween(displayObject, popUpDuration, { y :originalY } );
	}
	
	function playShrink(displayObject :DisplayObject, popUpDuration :Float) 
	{
		var originalX = displayObject.x;
		var originalY = displayObject.y;
		
		var targetX = originalX + displayObject.width * 0.5;
		var targetY = originalY + displayObject.height * 0.5;
		displayObject.scaleX = 1;
		displayObject.scaleY = 1;
		Actuate.tween(displayObject, popUpDuration, { scaleX :0 } );
		Actuate.tween(displayObject, popUpDuration, { scaleY :0 } );
		Actuate.tween(displayObject, popUpDuration, { x :targetX } );
		Actuate.tween(displayObject, popUpDuration, { y :targetY } );
	}
	
	
	function goToGameScreen() 
	{
		ScreenManager.getInstance().showOnScreen(new GameScreen());
	}
	
}