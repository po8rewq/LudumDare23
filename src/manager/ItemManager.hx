package manager;

import entities.Item;
import flash.geom.Point;

/**
 * ...
 * @author adrien
 */
class ItemManager 
{

	static var _self : ItemManager;
	
	private var _itemsList : List<Item>;
	
	/** Liste des items deja recupérés (on ne peut recuperer qu'un seul item bien sur) */
	private var _pickUpItemsList : List<PickedUpItem>; // on part du principe qu'on a qu'un item par point ;)
			
	private function new () 
	{
		_itemsList = new List();
		_pickUpItemsList = new List();
	}		
	
	public static function getInstance():ItemManager
	{
		if(_self == null)
			_self = new ItemManager();
		return _self;
	}
	
	/**
	 * Return true if the item has been added
	 */
	public function addItem(item: Item):Bool
	{
		if(!hasBeenPickedUp(item))
		{
			_itemsList.add(item);
			return true;
		}
		return false;
	}
	
	/**
	 * Return true if the player has already picked up this item
	 */
	private function hasBeenPickedUp(i: Item):Bool
	{
		for(p in _pickUpItemsList)
			if(p.x == i.x && p.y == i.y && i.mapId == p.mapId)
				return true;
		return false;
	}
	
	public function removeItem(item: Item, ?markAsPickUp: Bool = false):Bool
	{
		if(_itemsList.remove(item))
		{
			_pickUpItemsList.push( {x: item.x, y: item.y, mapId: item.mapId} );
			return true;
		}
		return false;
	}
	
	/**
	 * Suppression des entités graphique
	 */
	public function removeAll():Void
	{
		for(i in _itemsList)
			if(i.world != null)
				i.world.remove(i);
	}
	
	public function clear()
	{
		removeAll();
		for(d in _pickUpItemsList)
			d=null;
		_pickUpItemsList = new List();
	}

}

typedef PickedUpItem = {
	var x : Float;
	var y : Float;
	var mapId: Int;
}