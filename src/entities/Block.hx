package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

/**
 * ...
 * @author adrien
 */
class Block extends Entity 
{
	var sprite : Spritemap;
	public var mapId(default, null):Int;
	
	public function new (px:Float, py:Float, pMapId:Int, ?pCol:Int = -1, ?pRow: Int = -1)
	{
		super( px, (Math.round(py / 32) - 1) * 32);	
		
		if(pCol == -1) pCol = 0;
		if(pRow == -1) pRow = 2;
		
		type = 'solid';
		
		sprite = new Spritemap("gfx/tiles.png", 32, 32);
		sprite.setFrame(pCol, pRow);
		
		graphic = sprite;
				
		setHitbox(32, 32);
	}		

}
