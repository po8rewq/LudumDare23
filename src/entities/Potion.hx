package entities;

/**
 * ...
 * @author adrien
 */
class Potion extends Item
{
	public var behavior(default, null) : String; // deverouille cette competence
	public var instruction(default, null) : String; // texte a afficher lors du ramassage de la potion
	
	public function new (objectGid: Int, px: Int, py: Int, col: Int, row: Int, pBehavior:String, pInstruction: String, pColor: String) 
	{
		super(objectGid, px, py, col, row);
		
		behavior = pBehavior;
		instruction = pInstruction;
				
		type = 'potion';
		setHitbox(30, 30, -15, 15);
		
		//_sprite.setFrame(col*32, row*32);
		
		var frNumber : Int = switch(pColor)
		{
			case 'orange':8;
			case 'blue': 7;
			default: 7;
		}
		
		_sprite.add("loop", [frNumber], 0, false);
		_sprite.play('loop');
	}

}
