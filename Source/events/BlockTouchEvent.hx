package events;
import openfl.events.Event;

/**
 * ...
 * @author Nickan
 */
class BlockTouchEvent extends Event
{
	public static inline var BLOCK_TOUCH :String = "block touch";
	
	public var block(default, null) :Block;
	
	public function new(type :String, bubbles :Bool = false, cancelable :Bool = false, block :Block) 
	{
		super(type, bubbles, cancelable);
		this.block = block;
	}
	
}