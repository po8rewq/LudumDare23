package entities;

import com.haxepunk.Entity;
import com.haxepunk.graphics.Spritemap;

import flash.geom.Rectangle;

/**
 * ...
 * @author adrien
 */
class Item extends Entity
{
	var _sprite : Spritemap;
	var _objectGid : Int;
	public var mapId: Int;
	
	public function new (objectGid: Int, px: Int, py: Int, col: Int, row: Int) 
	{
		super(px, py - 32);
		
		_objectGid = objectGid;
		
		_sprite = new Spritemap("gfx/tiles.png", 32, 32);//new Rectangle(col*32, row*32, 32, 32) );
		
		graphic = _sprite;
	}
	
	public function animEnd():Void
	{
		// override it if needed
	}

}
