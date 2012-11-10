package manager;

import entities.Block;
import flash.geom.Point;
import com.haxepunk.HXP;

/**
 * ...
 * @author adrien
 */
class BlockManager 
{
	
	static var _self : BlockManager;
	
	private var _blocks : List<Block>;
	private var _destroyedBlocks : List<DestroyedBlock>;
	
	private function new () 
	{
		_blocks = new List();
		_destroyedBlocks = new List();
	}
	
	public static function getInstance():BlockManager
	{
		if(_self == null)
			_self = new BlockManager();
		return _self;
	}
	
	/**
	 * Return true if the player has already destroyed this block
	 */
	private function hasBeenDestroyed(b: Block):Bool
	{
		for(d in _destroyedBlocks)
			if(b.x == d.x && b.y == d.y && d.mapId == b.mapId)
				return true;
		return false;
	}
	
	/**
	 * On ajoute un block si on ne l'a pas deja detruit
	 */
	public function addBlock(b: Block):Void
	{
		if(!hasBeenDestroyed(b))
		{
			_blocks.add(b);
			HXP.world.add(b);
		}
	}
	
	public function removeBlock(b: Block, pIsDestroyed:Bool=false):Void
	{
		if( _blocks.remove(b) )
		{
			if(b.world != null)
				b.world.remove(b);
			if(pIsDestroyed)
				_destroyedBlocks.add( {x: b.x, y: b.y, mapId: b.mapId} );
			b = null;
		}
	}
	
	/**
	 * Suppression des entités graphique
	 */
	public function removeAll():Void
	{
		for(b in _blocks)
		{
			if(b.world != null)
				b.world.remove(b);
			b = null;
		}
		_blocks = new List();
	}
	
	public function clear()
	{
		removeAll();
		for(d in _destroyedBlocks)
			d = null;
		_destroyedBlocks = new List();
	}

}

typedef DestroyedBlock = {
	var x : Float;
	var y : Float;
	var mapId: Int;
}