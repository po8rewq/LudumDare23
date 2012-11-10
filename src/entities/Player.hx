package entities;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.utils.Input;
import com.haxepunk.utils.Key;
import com.haxepunk.HXP;

import com.haxepunk.masks.Circle;

import manager.BehaviorManager;
import manager.BulletManager;

private enum JumpStyle
{
	Normal;
	Gravity;
	Disable;
}

/**
 * ...
 * @author adrien
 */
class Player extends Physics
{
	private var sprite:Spritemap;
	
	private static var jumpStyle:JumpStyle = Normal;
	private static inline var kMoveSpeed:Float = 0.8;
	private static inline var kJumpForce:Int = 20;
	
	/** On ne bouge pas le tout premier coup avant d'avoir touché le sol */
	public var hasTouchTheGround(default, null) : Bool;
	
	private var _direction : Int;
	
	// Temps avant que le joueur puisse se re faire toucher par un mob
	private static inline var HURT_DELAY : Int = 2500;
	private var _hurtTimer : Int;
	
	public var isDead : Bool;
	
	public function new (x:Float, y:Float) 
	{
		super(x,y);
		
		isDead = false;
		hasTouchTheGround = false;
		
		sprite = new Spritemap("gfx/hero.png", 30, 40);
		
		sprite.add('normal_walk', [0,1], 4, true);
		sprite.add('normal_idle', [0]);
		
		sprite.add('armed_walk', [2,3], 4, true);
		sprite.add('armed_idle', [2]);
		
		graphic = sprite;
				
		setHitboxTo( sprite );
		
		_direction = 1;
		
		// Set physics properties
		gravity.y = 1.8;
		maxVelocity.y = kJumpForce;
		maxVelocity.x = kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction

		// Define input keys
		Input.define("left", [Key.A, Key.LEFT]);
		Input.define("right", [Key.D, Key.RIGHT]);
		Input.define("jump", [Key.W, Key.UP]);
		Input.define("fire", [Key.SPACE]);
	}
	
	public override function update()
	{
		acceleration.x = acceleration.y = 0;

		// Le jeu peut maintenant commencer
		if( !hasTouchTheGround && _onGround) hasTouchTheGround = true;

		if(BehaviorManager.getInstance().can('walk') && !isDead)
		{
			if (hasTouchTheGround && Input.check("left"))
			{
				acceleration.x = -kMoveSpeed;
			}
			else if (hasTouchTheGround && Input.check("right"))
			{
				acceleration.x = kMoveSpeed;
			}
		}
			
		if( !isDead && _onGround && BehaviorManager.getInstance().can('jump') && Input.pressed("jump") )
		{
			switch (jumpStyle)
			{
				case Normal:
					acceleration.y = -HXP.sign(gravity.y) * kJumpForce;
				case Gravity:
					gravity.y = -gravity.y;
				case Disable:
			}
		}
		
		if(!isDead && BehaviorManager.getInstance().can('fire') && Input.pressed("fire") )
		{
			BulletManager.getInstance().addBullet(x, y, _direction );
		}

		// Make animation changes here
		setAnimation();

		if(_hurtTimer > 0)
		{  
			if(nme.Lib.getTimer() >_hurtTimer + HURT_DELAY)
			{
				_hurtTimer = 0;
				sprite.alpha = 1;
			}
			else
				sprite.alpha = 0.2;
		}

		super.update();

		// Always face the direction we were last heading
		if (velocity.x < 0)
		{
			sprite.flipped = true; // left
			_direction = -1;
		}
		else if (velocity.x > 0)
		{
			_direction = 1;
			sprite.flipped = false; // right
		}
	}
	
	private function setAnimation()
	{
		var anim:String = BehaviorManager.getInstance().can('fire') ? 'armed' : 'normal';
		
		if (velocity.x == 0)
			sprite.play(anim + "_idle");
		else
			sprite.play(anim + "_walk");
	}
	
	public function isHurt()
	{
		_hurtTimer = nme.Lib.getTimer();
	}
	
	public function canBeHurt():Bool
	{
		return _hurtTimer == 0;
	}

}
