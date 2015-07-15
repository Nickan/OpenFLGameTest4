package;
import framework.ScreenManager;
import framework.TextButton;
import framework.TextSprite;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.text.TextFieldAutoSize;
import screen_sprite.GameScreen;
import screen_sprite.TitleScreen;

/**
 * ...
 * @author Nickan
 */
class GameOverBox extends Sprite
{
	var _gameOverBox :Bitmap;
	var _score :Int;

	public function new(score :Int) 
	{
		super();
		_score = score;
		addEventListener(Event.ADDED_TO_STAGE, onAdded);
	}
	
	private function onAdded(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		setupGameOverBox();
		setupRestartButton();
		setupQuitButton();
	}
	
	function setupGameOverBox() 
	{
		_gameOverBox = new Bitmap(Assets.getBitmapData("assets/asset_gameover_popup.png"));
		addChild(_gameOverBox);
		
		var gameOverText = new TextSprite(20);
		addChild(gameOverText);
		gameOverText.showText("Game Over");
		gameOverText.x = _gameOverBox.width * 0.15;
		gameOverText.y = _gameOverBox.height * 0.05;
		
		var totalScoreText = new TextSprite(15, 0x00FF00);
		addChild(totalScoreText);
		totalScoreText.showText("Total Score");
		totalScoreText.x = _gameOverBox.width * 0.185;
		totalScoreText.y = _gameOverBox.height * 0.25;
		
		var scoreText = new TextSprite(25, 0xFFFFFF);
		addChild(scoreText);
		scoreText.showText("" + _score);
		scoreText.setTextFieldAutoSize(TextFieldAutoSize.CENTER);
		scoreText.x = _gameOverBox.width * 0.185;
		scoreText.y = _gameOverBox.height * 0.34;
	}
	
	function setupRestartButton() 
	{
		var restartButton = new TextButton("Restart", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onRestart);
		addChild(restartButton);
		restartButton.x = _gameOverBox.width * 0.5 - (restartButton.width * 0.5);
		restartButton.y = _gameOverBox.height * 0.53;
	}

	function setupQuitButton() 
	{
		var quitButton = new TextButton("Quit", new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_up.png")),
								new Bitmap(Assets.getBitmapData("assets/asset_button_down.png")), null, onQuit);
		addChild(quitButton);
		quitButton.x = _gameOverBox.width * 0.5 - (quitButton.width * 0.5);
		quitButton.y = _gameOverBox.height * 0.745;
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