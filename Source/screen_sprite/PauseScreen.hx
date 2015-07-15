package screen_sprite;
import framework.Screen;
import framework.ScreenManager;
import framework.TextButton;
import framework.TextSprite;
import haxe.Timer;
import lime.text.TextScript;
import motion.Actuate;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class PauseScreen extends Screen
{
	static inline var DURATION :Float = 0.4;
	var _pauseBitmap :Bitmap;
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupBackground();
	}
	
	function setupBackground() 
	{
		graphics.beginFill(0x000000, 0.3);
		graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
		graphics.endFill();
		
		this.alpha = 0;
		
		Actuate.tween(this, DURATION, { alpha: 1 } );
		Timer.delay(showPauseBox, Std.int(DURATION * 1000));
	}
	
	function setupResumeButton() 
	{
		var resumeButton = new TextButton("Resume", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onResume);
		addChild(resumeButton);
		resumeButton.x = stage.stageWidth * 0.5 - (resumeButton.width * 0.5);
		resumeButton.y = (stage.stageHeight * 0.45) - (resumeButton.height * 0.5);
	}
	
	function setupRestartButton() 
	{
		var restartButton = new TextButton("Restart", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onRestart);
		addChild(restartButton);
		restartButton.x = stage.stageWidth * 0.5 - (restartButton.width * 0.5);
		restartButton.y = (stage.stageHeight * 0.55) - (restartButton.height * 0.5);
	}

	function setupQuitButton() 
	{
		var quitButton = new TextButton("Quit", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onQuit);
		addChild(quitButton);
		quitButton.x = stage.stageWidth * 0.5 - (quitButton.width * 0.5);
		quitButton.y = (stage.stageHeight * 0.65) - (quitButton.height * 0.5);
	}
	
	
	function showPauseBox() 
	{
		_pauseBitmap = new Bitmap(Assets.getBitmapData("assets/asset_pause_menu.png"));
		addChild(_pauseBitmap);
		_pauseBitmap.x = (stage.stageWidth * 0.5) - (_pauseBitmap.width * 0.5);
		_pauseBitmap.y = (stage.stageHeight * 0.5) - (_pauseBitmap.height * 0.5);
		
		var pauseText = new TextSprite();
		addChild(pauseText);
		pauseText.showText("Paused");
		pauseText.x = (stage.stageWidth * 0.5) - (pauseText.width * 0.5);
		pauseText.y = (stage.stageHeight * 0.3) - (pauseText.height * 0.5);
		
		setupResumeButton();
		setupRestartButton();
		setupQuitButton();
	}
	
	
	function onResume() 
	{
		Actuate.tween(this, DURATION, { alpha :0 } ).onComplete(onResumeGame);
	}
	
	function onResumeGame() 
	{
		ScreenManager.getInstance().removeTopScreen();
	}
	
	function onRestart() 
	{
		ScreenManager.getInstance().removeTopScreen();
		ScreenManager.getInstance().showOnScreen(new GameScreen());
	}
	
	function onQuit() 
	{
		ScreenManager.getInstance().removeTopScreen();
		ScreenManager.getInstance().showOnScreen(new TitleScreen());
	}
	
}