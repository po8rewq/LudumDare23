package entities;

import com.haxepunk.HXP;

/**
 * ...
 * @author adrien
 */
class Coin extends Item 
{	
	public function new (objectGid: Int, px: Int, py: Int, col: Int, row: Int) 
	{
		super(objectGid, px, py, col, row);
				
		type = 'coin';
		setHitbox(16, 30);
		
		_sprite.add("loop", [5, 6], 3, true);
		_sprite.play('loop');
	}

}
