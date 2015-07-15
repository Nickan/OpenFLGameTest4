package events;
import openfl.events.Event;

enum Direction {
	LEFT;
	RIGHT;
	UP;
	DOWN;
}

/**
 * ...
 * @author Nickan
 */
class BlockMoveEvent extends Event
{
	public static inline var BLOCK_MOVE :String = "block touch";
	
	public var block(default, null) :Block;
	public var direction(default, null) :Direction;
	
	public function new(type :String, bubbles :Bool = false, cancelable :Bool = false, block :Block, direction :Direction) 
	{
		super(type, bubbles, cancelable);
		this.block = block;
		this.direction = direction;
	}
	
}