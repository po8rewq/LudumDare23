package manager;

import com.haxepunk.graphics.Text;
import com.haxepunk.HXP;
import com.haxepunk.Entity;

import haxe.Timer;

/**
 * ...
 * @author adrien
 */
class InstructionsManager 
{
	private static var INSTRUCTION_DELAY : Int = 3000;

	private static var _self;
	
	private var _entity : Entity;
	private var _text : Text;
	private var _instructions : List<Instruction>;
	
	private function new () 
	{
		_instructions = new List();
	}
	
	public static function getInstance(): InstructionsManager
	{
		if(_self == null)
			_self = new InstructionsManager();
		return _self;
	}
		
	public function addInstruction(pX: Int, pY: Int, pText:String, pMapId:Int, ?pRepeatCount: Int = 1, ?pShow:Bool = false)
	{
		var i : Instruction = {x: pX, y: pY, text: pText, start: 0.0, repeatCount: pRepeatCount, mapId: pMapId};
		
		if(!isAlreadyIn(i))
		{
			_instructions.add(i);
			
			if(pShow)
				showText(i);
		}
	}
	
	public function showEndText(pText: String)
	{
		hideCurrent();
		
		_text = new Text(pText, 0, 0);
		_text.scrollX = _text.scrollY = 0;
		_entity.graphic = _text;
		
		var posX : Int = Math.round((HXP.width - _text.width) / 2);
		var posY : Int = Math.round((HXP.height - _text.height) / 2);
		
		_entity.x = posX;
		_entity.y = posY;
		
		HXP.world.add(_entity);
	}
	
	private function showText(i: Instruction, ?xPos: Int = -1, ?yPos: Int = -1):Void
	{		
		if(_entity == null)
		{
			_entity = new Entity(0, 0/*i.x, i.y*/);
			_text = new Text(i.text, 0, 0);
			_text.scrollX = _text.scrollY = 0;
			_entity.graphic = _text;
		}
		else
		{
			hideCurrent();
		
			_text = new Text(i.text, 0, 0);
			_text.scrollX = _text.scrollY = 0;
			_entity.graphic = _text;
		}
		
		var posX : Int = xPos == -1 ? Math.round((HXP.width - _text.width) / 2) : xPos;
		var posY : Int = yPos == -1 ? 450 : yPos;
		
		_entity.x = posX;
		_entity.y = posY;
		
		if(i.repeatCount > 0)
			i.repeatCount--;
		i.start = nme.Lib.getTimer();
		
		HXP.world.add(_entity);
	}
	
	/**
	 * On force la disparition du texte
	 */
	public function hideCurrent()
	{
		if(_entity.world != null)
			_entity.world.remove(_entity);
		
		for(i in _instructions)
			i.start = 0;
	}
	
	/**
	 * Update instructions
	 */
	public function checkCollisionsWith(e: Entity, currentMapId: Int)
	{
		var i : Instruction;
		for(i in _instructions)
		{
			if(i.mapId != currentMapId) continue; // on ne traite pas les instructions present sur les autres map
			if(i.start == 0 && e.collideRect(e.x, e.y, i.x, i.y, 32, 32) )
			{
				if(i.repeatCount == -1 || i.repeatCount > 0)
					showText(i/*, cast e.x, cast e.y - 50*/);
			}
			else if( i.start > 0 && nme.Lib.getTimer() > (i.start + INSTRUCTION_DELAY) )
			{
				hideCurrent();
			}
		}
	}
	
	public function isEquals(i1: Instruction, i2: Instruction):Bool
	{
		if(i1.x == i2.x && i1.y == i2.y && i1.text == i2.text)
			return true;
		return false;
	}
	
	private function isAlreadyIn(instruction: Instruction):Bool
	{
		var i : Instruction;
		for(i in _instructions)
			if( isEquals(i, instruction) )
				return true;
		return false;
	}
	
	public function clear()
	{
		hideCurrent();
		for(d in _instructions)
			d = null;
		_instructions = new List();
	}

}

typedef Instruction = {
	var x : Int;
	var y : Int;
	var text : String;
	var start : Float; // pour le timer
	var repeatCount : Int; // nb max de fois répété (-1 a chaque fois)
	var mapId: Int;
}