package factory;

import entities.Item;
import entities.Coin;
import entities.Potion;

import com.haxepunk.tmx.TmxPropertySet;

/**
 * ...
 * @author adrien
 */
class ItemFactory 
{	
	public static function createItem(objectGid: Int, px: Int, py : Int, mapId: Int, ?data: TmxPropertySet = null):Item
	{	
		var item : Item;
		switch(objectGid)
		{
			case 6: // ship piece
				item = new Coin(objectGid, px, py, 0, 1);
			case 8: // potion
				item = new Potion(objectGid, px, py, 2, 1, data.resolve('behavior'), data.resolve('instruction'), data.resolve('color'));
			//case 12: // key
				// TODO
			default:
				throw ('ObjectGID unknown');
		}
		
		item.mapId = mapId;
		return item;
	}

}
