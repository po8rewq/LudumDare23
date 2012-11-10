package entities;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Entity;
import com.haxepunk.HXP;

import manager.BulletManager;
import manager.MonsterManager;
import manager.BlockManager;

/**
 * ...
 * @author adrien
 */
class Bullet extends Physics
{
	
	private var sprite:Spritemap;
	private static inline var kMoveSpeed:Float = 2;
	
	private var _sign : Int;
	
	/**
	 * @param pDirection : 1 gauche, -1 droite
	 */
	public function new (pX: Float, pY: Float, pDirection:Int) 
	{
		super(pX, pY);
		
		_sign = pDirection;
		type = 'bullet';
		
		sprite = new Spritemap("gfx/tiles.png", 32, 32);
		sprite.setFrame(4, 1);
		
		graphic = sprite;
				
		setHitboxTo( sprite );
		
		gravity.y = 1.8;
		maxVelocity.x = kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
	}	
	
	public override function update()
	{
		acceleration.x = acceleration.y = 0;
		acceleration.x = kMoveSpeed * _sign;
		
		// si sort de l'ecran
		if(x + width < 0 || x > worlds.GameWorld._tmxEntity.width) // TODO
			BulletManager.getInstance().removeBullet(this);
		
		// si rentre en collision avec un mob
		var mob : Monster = cast HXP.world.collideRect('monster', x, y, width, height);
		if( mob != null )
		{
			BulletManager.getInstance().removeBullet(this, false);
			BulletManager.getInstance().addExplosion(mob.x, mob.y);
			MonsterManager.getInstance().removeMonster(mob);
		}
		
		super.update();
	}
	
	public override function moveCollideX(e:Entity)
	{
		if(Std.is(e, Block))
		{
			BulletManager.getInstance().removeBullet(this, false);
			BulletManager.getInstance().addExplosion(e.x, e.y);
			BlockManager.getInstance().removeBlock(cast e, true);
		}
		else
		{
			BulletManager.getInstance().removeBullet(this, true);
		}
	}

}
