package manager;

import entities.Bullet;
import entities.EmitterEntity;

import com.haxepunk.HXP;

/**
 * ...
 * @author adrien
 */
class BulletManager 
{
	private static var _self : BulletManager;
	
	private var _bullets : List<Bullet>;
	private var _explosionEntity : EmitterEntity;
		
	private function new () 
	{
		_bullets = new List();
	}
	
	public static function getInstance():BulletManager
	{
		if(_self == null)
			_self = new BulletManager();
		return _self;
	}
	
	public function addBullet(px: Float, py: Float, pSign:Int):Void
	{
		var b : Bullet = new Bullet(px, py, pSign);
		_bullets.add(b);
		HXP.world.add(b);
	}
	
	public function removeBullet(bullet: Bullet, ?pAddExplosion:Bool = false):Void
	{
		if( _bullets.remove(bullet) )
		{
			if(pAddExplosion) 
				addExplosion(bullet.x, bullet.y);
			if(bullet.world != null)
				bullet.world.remove(bullet);
			bullet = null;
		}
	}
	
	public function removeAll():Void
	{
		for(bullet in _bullets)
		{
			if(bullet.world != null)
				bullet.world.remove(bullet);
			bullet = null;
		}
		_bullets = new List();
	}
	
	public function addExplosion(px:Float, py:Float)
	{
		// Si besoin on initialise les données
		if(_explosionEntity == null)
			_explosionEntity = new EmitterEntity();
		if(_explosionEntity.world == null)
			HXP.world.add(_explosionEntity);
		HXP.world.bringToFront(_explosionEntity);
		
		// on lance l'anim
		_explosionEntity.explode(px, py);
	}

}
