package;
import events.BlockMoveEvent;
import openfl.Assets;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.events.TouchEvent;

/**
 * ...
 * @author Nickan
 */
class Block extends Sprite
{
	public var id(default, null) :Int;
	
	var _dragging :Bool = false;
	var _mouseX :Float = 0;
	var _mouseY :Float = 0;
	
	public function new(id :Int) 
    {
        super();
		this.id = id;
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):Void 
    {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
		addEventListener(Event.ENTER_FRAME, onUpdate);
        addEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		addEventListener(MouseEvent.MOUSE_OUT, onMouseOUt);
		
		setupTexture();
    }
	
	function setupTexture() 
	{
		var bitmapData = Assets.getBitmapData("assets/asset_gem" + id + ".png");
		var bitmap = new Bitmap(bitmapData);
		bitmap.width = 44;
		bitmap.height = 44;
		addChild(bitmap);
	}
	
	
    private function onUpdate(e:Event):Void 
    {
		
    }
	
	private function onMouseDown(e:MouseEvent):Void 
	{
		_dragging = true;
		_mouseX = e.stageX;
		_mouseY = e.stageY;
		
		//...
		//trace("ID: " + id + " Pos: " + x + ": " + y);
	}
	
	private function onMouseUp(e:MouseEvent):Void 
	{
		_dragging = false;
	}
	
	private function onMouseMove(e:MouseEvent):Void 
	{
		if (!_dragging)
			return;
		else {
			var direction = getDirection(e);
			if (direction != null) {
				dispatchEvent(new BlockMoveEvent(BlockMoveEvent.BLOCK_MOVE, false, false, this, direction));
				_dragging = false;
			}
		}
		
	}
	
	private function onMouseOUt(e:MouseEvent):Void 
	{
		_dragging = false;
	}
	
	function getDirection(e:MouseEvent) 
	{
		var diffX = e.stageX - _mouseX;
		var diffY = e.stageY - _mouseY;
		var DIRECTION_HORIZONTAL_ALLOWANCE = stage.stageWidth * 0.005;
		var DIRECTION_VERTICAL_ALLOWANCE = stage.stageHeight * 0.005;
		
		
		if (Math.abs(diffX) > Math.abs(diffY)) {
			if (diffX < -DIRECTION_HORIZONTAL_ALLOWANCE)
				return Direction.LEFT;
			else if (diffX > DIRECTION_HORIZONTAL_ALLOWANCE)
				return Direction.RIGHT;
		} else if (Math.abs(diffY) > Math.abs(diffX)) {
			if (diffY < -DIRECTION_VERTICAL_ALLOWANCE)
				return Direction.UP;
			else if (diffY > DIRECTION_VERTICAL_ALLOWANCE)
				return Direction.DOWN;
		}
		
		return null;
	}
	
	
    private function onRemoved(e:Event):Void 
    {
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		dispose();
    }
	
	public function dispose() {
		removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        removeEventListener(Event.ENTER_FRAME, onUpdate);
        removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
		removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		removeEventListener(MouseEvent.MOUSE_OUT, onMouseOUt);
	}
	
}