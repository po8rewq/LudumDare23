package manager;

import entities.Monster;
import com.haxepunk.HXP;

/**
 * ...
 * @author adrien
 */
class MonsterManager 
{
	private static var _self : MonsterManager;
	
	private var _monsters : List<Monster>;
	
	private function new () 
	{
		_monsters = new List();
	}		
	
	public static function getInstance():MonsterManager
	{
		if(_self == null)
			_self = new MonsterManager();
		return _self;
	}
	
	public function addMonster(m:Monster):Void
	{
		_monsters.add(m);
		HXP.world.add(m);
	}
	
	public function removeMonster(m:Monster):Void
	{
		if(m.world != null)
			m.world.remove(m);
		
		_monsters.remove(m);
		m = null;
	}
	
	/**
	 * Suppression des entités graphique
	 */
	public function removeAll():Void
	{
		for(m in _monsters)
		{
			if(m.world != null)
				m.world.remove(m);
			m = null;
		}
		_monsters = new List();
	}

}
