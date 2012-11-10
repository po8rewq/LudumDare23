package entities;

/**
 * ...
 * @author adrien
 */
class KeyItem extends Item 
{
	
	public function new (objectGid: Int, px: Int, py: Int, col: Int, row: Int) 
	{
		super(objectGid, px, py, col, row);
		
		type = 'key';
		
		
	}		

}
