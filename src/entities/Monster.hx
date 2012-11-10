package entities;

import com.haxepunk.graphics.Spritemap;
import com.haxepunk.Entity;

/**
 * ...
 * @author adrien
 */
class Monster extends Physics 
{
	private var sprite:Spritemap;
	private static inline var kMoveSpeed:Float = 0.7;
	
	private var _moveLeft : Bool;
	
	public function new (pX: Float, pY: Float) 
	{
		super(pX, pY);
		
		sprite = new Spritemap("gfx/monster.png");
		graphic = sprite;
		
		type = 'monster';
								
		setHitboxTo( sprite );
		
		_moveLeft= false;
		
		gravity.y = 1.8;
		maxVelocity.x = kMoveSpeed * 4;
		friction.x = 0.82; // floor friction
		friction.y = 0.99; // wall friction
	}	
	
	public override function update()
	{
		acceleration.x = acceleration.y = 0;

		if(_moveLeft)
			acceleration.x = -kMoveSpeed;
		else 
			acceleration.x = kMoveSpeed;
		
		
		super.update();

		// Always face the direction we were last heading
		if (velocity.x < 0)
			sprite.flipped = true; // left
		else if (velocity.x > 0)
			sprite.flipped = false; // right
	}
	
	public override function moveCollideX(e:Entity)
	{
		acceleration.x = 0;
		_moveLeft = !_moveLeft;
	}

}
