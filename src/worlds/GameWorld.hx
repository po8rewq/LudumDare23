package worlds;

import com.haxepunk.HXP;
import com.haxepunk.tmx.TmxMap;
import com.haxepunk.tmx.TmxEntity;
import com.haxepunk.tmx.TmxObject;
import com.haxepunk.tmx.TmxObjectGroup;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.utils.Input;
import com.haxepunk.World;

import entities.Player;
import entities.Item;
import entities.Coin;
import entities.Potion;
import entities.Monster;
import entities.Block;

import factory.ItemFactory;
import manager.InstructionsManager;
import manager.BehaviorManager;
import manager.ItemManager;
import manager.MonsterManager;
import manager.BlockManager;
import manager.UiManager;

import flash.display.BitmapData;
import flash.geom.Point;

class GameWorld extends World
{
	/** Entities on screen */
	var _player : Player;
	public static var _tmxEntity : TmxEntity;
			
	/** Camera stuff */
	var cameraOffset : Int;
	var cameraSpeed : Float;
	
	/** Level data */
	var _levels : Array<String>;
	var _currentLevel : Int;

	public function new()
	{
		super();
		initLevels();
	}
	
	public override function begin()
	{	
		Input.define("restart", [Key.ESCAPE]);
		
		_player = new Player(0, 0);
		initCamera();		
		loadLevel();
	}
	
	private function initLevels():Void
	{
		_currentLevel = 0;
		_levels = ['level1', 'level2', 'level3', 'level4', 'level5'];
	}
	
	private function loadLevel(?pStartFromTheBeginning:Bool = true):Void
	{
		var bitmapData : BitmapData = nme.Assets.getBitmapData('gfx/tiles.png', true);
		
		var map : TmxMap = new TmxMap( nme.Assets.getText('levels/'+_levels[_currentLevel]+'.tmx') );
		var order : Array<String> = ["background", "backdrop", "ground"]; // layer order (back-to-front) 
		
		_tmxEntity = new TmxEntity(map, bitmapData, checkTiles, order);
		_tmxEntity.setCollidable(checkTiles, "ground"); // Set collidable function and layer name
		
		if(_tmxEntity.world == null)
			add(_tmxEntity);
		
		/** Récupération des items */		
		var itemGroup : TmxObjectGroup = map.getObjectGroup('items');
		var object : TmxObject;
		if(itemGroup != null)
		{
			for(object in itemGroup.objects)
			{
				var item : Item = ItemFactory.createItem(object.gid, object.x, object.y, _currentLevel, object.custom);
				if( ItemManager.getInstance().addItem(item) )
					add( item );
				else
					item = null;
			}
		}
		
		/** Récupération des mobs */
		var monstersGroup : TmxObjectGroup = map.getObjectGroup('monsters');
		if(monstersGroup != null)
		{
			for(object in monstersGroup.objects)
			{
				var m : Monster = new Monster(object.x, object.y);
				MonsterManager.getInstance().addMonster(m);
			}
		}
		
		/** Récupération des instructions */
		var instructionGroup : TmxObjectGroup = map.getObjectGroup('instructions');
		if(instructionGroup != null)
		{
			for(object in instructionGroup.objects)
			{
				var repeat : String = object.custom.resolve('repeat');
				InstructionsManager.getInstance().addInstruction(object.x, object.y, object.custom.resolve('text'), _currentLevel, repeat == '' ? 1 : Std.parseInt(repeat) );
			}
		}
		
		/** Récuperation des blocks divers */
		var blocksGroup : TmxObjectGroup = map.getObjectGroup('blocks');
		if(blocksGroup != null)
		{
			for(object in blocksGroup.objects)
			{
				// Si on a spécifié une autre tile (oh le fourbe !!)
				var forceCol : String = object.custom.resolve('col');
				var forceRow : String = object.custom.resolve('row');
			
				var block: Block = new Block(object.x, object.y, _currentLevel, forceCol != '' ? Std.parseInt(forceCol) : -1, forceRow != '' ? Std.parseInt(forceRow) : -1);
				BlockManager.getInstance().addBlock(block);
			}
		}
		
		/** On met a jours les behaviors */
		BehaviorManager.getInstance().update( _tmxEntity.map.properties.resolve('behaviors') );
		
		/** Initialisation de la position du joueur */
		initCharacterPosition(pStartFromTheBeginning);
		
		UiManager.getInstance().init();
	}
	
	private function initCharacterPosition(pStartFromTheBeginning:Bool)
	{
		var cellX : Int;
		var cellY : Int;
		
		if(pStartFromTheBeginning)
		{
			// Cas particulier de l'entrée en jeu
			if(_currentLevel == 0 && !_player.hasTouchTheGround)
			{
				cellX = 1;
				cellY = 0;
			}
			else
			{
				cellX = Std.parseInt( _tmxEntity.map.properties.resolve('startx') );
				cellY = Std.parseInt( _tmxEntity.map.properties.resolve('starty') );
			}
		}
		else
		{
			cellX = Std.parseInt( _tmxEntity.map.properties.resolve('endx') );
			cellY = Std.parseInt( _tmxEntity.map.properties.resolve('endy') );
		}
		
		_player.x = cellX * _tmxEntity.map.tileWidth;
		_player.y = (cellY + 1) * _tmxEntity.map.tileHeight - _player.height - 1;
		add(_player);
	}
	
	private function initCamera()
	{
		cameraOffset = 300;
		cameraSpeed = 2;
	}
	
	public function checkTiles(tile:Int, col:Int, row:Int):Bool 
	{
		if(tile != 0)
			return true;
		return false; 
	}
	
	public override function update()
	{
		if(Input.released("restart"))
		{
			BehaviorManager.getInstance().clear();
			BlockManager.getInstance().clear();
			InstructionsManager.getInstance().clear();
			ItemManager.getInstance().clear();
			UiManager.getInstance().clear();
			HXP.world = new StartScreen();
		}
	
		updateCamera();
		
		/** Update items */
		updateItems();
		
		/** update instructions */
		updateInstructions();
		
		/** gestion collision avec les mobs */ 
		updateMobsCollision();
		
		super.update();
		
		/** Next Level */
		if(_player.x + _player.width > _tmxEntity.width)
			nextLevel();
		else if(_player.x < 0)
			previousLevel();
	}
	
	private function updateCamera():Void
	{
		var newCameraX : Float = (_player.x + _player.width/2) - HXP.width / 2;
		var newCameraY : Float = (_player.y + _player.height/2) - HXP.height / 2;
				
		if(newCameraX < 0) newCameraX = 0;
		else if(newCameraX + HXP.width > _tmxEntity.width) newCameraX = _tmxEntity.width - HXP.width;
		
		if(newCameraY < 0) newCameraY = 0;
		else if(newCameraY + HXP.height > _tmxEntity.height) newCameraY = _tmxEntity.height - HXP.height;
		
		HXP.camera.x = newCameraX;
	//	HXP.camera.y = newCameraY;
	}
	
	/**
	 * Mise ajour des données pour les instructions de jeu / textes
	 */
	private function updateInstructions():Void
	{
		InstructionsManager.getInstance().checkCollisionsWith(_player, _currentLevel);
	}
	
	/**
	 * Gestion de la récupération des objets
	 */
	private function updateItems():Void
	{
		var coin : Coin = cast _player.collide('coin', _player.x, _player.y);
		if( coin != null )
		{
			remove(coin);
			ItemManager.getInstance().removeItem(coin, true);
			
			if(UiManager.getInstance().pieceFound())
			{
				InstructionsManager.getInstance().showEndText("I've found all the pieces in this tiny world...\nBut... It's too late, the Ludum Dare has ended... sniff...\nPress ESC to quit");
			}
		}
		
		var potion : Potion = cast _player.collide('potion', _player.x, _player.y);
		if( potion != null )
		{
			BehaviorManager.getInstance().addBehavior(potion.behavior);
			InstructionsManager.getInstance().addInstruction(Math.round(potion.x), Math.round(potion.y), "You won a new ability! " + potion.instruction, _currentLevel, 1, true);
			remove(potion);
			ItemManager.getInstance().removeItem(potion, true);
		}
	}
	
	private function previousLevel()
	{
		if(_currentLevel - 1 >= 0)
		{
			_currentLevel--;
		}
		else
		{
			_currentLevel = _levels.length - 1;
		}
		
		clearLevel();			
		loadLevel(false);
	}
	
	private function nextLevel()
	{
		if(_currentLevel + 1 < _levels.length)
		{
			_currentLevel++;
		}
		else
		{
			_currentLevel = 0;
		}
			
		clearLevel();			
		loadLevel(true);
	}
	
	private function updateMobsCollision()
	{
		var mob : Monster = cast _player.collide('monster', _player.x, _player.y);
		if( mob != null && _player.canBeHurt() && !_player.isDead )
		{
			_player.isHurt();
			var nbLifeLeft : Int = UiManager.getInstance().looseLife();
			if(nbLifeLeft == 0)
			{
				_player.isDead = true;
			//	_player.collidable = false;
				InstructionsManager.getInstance().showEndText("AAHHHH..... I'll never see again the love of my life... My computer....");
			}
			else if(nbLifeLeft == 1)
			{
				InstructionsManager.getInstance().addInstruction(Math.round(_player.x), Math.round(_player.y), "Ouch!! If they hit me again, I'll die!! Be careful!!", _currentLevel, -1, true);
			}
			else
			{
				InstructionsManager.getInstance().addInstruction(Math.round(_player.x), Math.round(_player.y), "Ouch!! It hurts!!", _currentLevel, -1, true);
			}
			
		}
	}
	
	/**
	 * Fait le ménage dans les elements graphique entre chaque tableau
	 */
	private function clearLevel():Void
	{
		remove(_player);
		remove(_tmxEntity);
		
		ItemManager.getInstance().removeAll();
		MonsterManager.getInstance().removeAll();
		BlockManager.getInstance().removeAll();
	}

}