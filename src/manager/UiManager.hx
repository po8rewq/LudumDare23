package manager;

import com.haxepunk.graphics.Image;
import com.haxepunk.graphics.Canvas;
import com.haxepunk.HXP;
import com.haxepunk.Entity;
import com.haxepunk.graphics.Text;

import flash.geom.Rectangle;

/**
 * ...
 * @author adrien
 */
class UiManager 
{
	static var _self : UiManager;
	
	static inline var TOTAL_PIECES : Int = 22;
	static inline var PIECES_HEIGHT : Int = 24;
	static inline var PIECES_PADDING : Int = 2;
	
	private var _nbLive : Int;	
	private var _totalPiecesPickedUp : Int;
	
	var _progression : Canvas;
	var imgPieces : Entity;
	
	var _quitText : Entity;
	
	private function new () 
	{
		_nbLive = 3;
		_totalPiecesPickedUp = 0;
		
		var t : Text = new Text('Press ESCAPE to quit',0,0,HXP.width);
		t.y = HXP.height - t.height;
		t.scrollX = t.scrollY = 0;
		_quitText = HXP.world.addGraphic(t);
		
		_progression = new Canvas(HXP.width, PIECES_HEIGHT + PIECES_PADDING * 2);
		_progression.y = 0;//HXP.height - (PIECES_HEIGHT + PIECES_PADDING * 2);
		_progression.scrollX = _progression.scrollY = 0;
		_progression.fill(new Rectangle(0, 0, HXP.width, PIECES_HEIGHT + PIECES_PADDING * 2), 0x000000);		
	}
	
	public function clear()
	{
		_nbLive = 3;
		_totalPiecesPickedUp = 0;
		_progression.fill(new Rectangle(0, 0, HXP.width, PIECES_HEIGHT + PIECES_PADDING * 2), 0x000000);		
	}
	
	public function init()
	{
		if(_quitText.world != null)
			_quitText.world.remove(_quitText);
		HXP.world.add(_quitText);
		
		updatePiecesBar();
	}
	
	private function updatePiecesBar()
	{
		if(imgPieces != null && imgPieces.world != null)
			imgPieces.world.remove(imgPieces);
		
		// Valeur de remplissage
		var width : Int = Math.round( HXP.width * _totalPiecesPickedUp / TOTAL_PIECES );
		if(width > 0) 
			_progression.drawRect( new Rectangle(PIECES_PADDING, PIECES_PADDING, width - PIECES_PADDING * 2, PIECES_HEIGHT), 0xfff000);
					
		imgPieces = HXP.world.addGraphic(_progression);
	}
	
	public static function getInstance():UiManager
	{
		if(_self == null)
			_self = new UiManager();
		return _self;
	}
	
	/**
	 * True if the game is complete
	 */
	public function pieceFound():Bool
	{
		_totalPiecesPickedUp++;
		updatePiecesBar();
		
		return (_totalPiecesPickedUp == TOTAL_PIECES);
	}
	
	/**
	 * @param 1 ou -1
	 * @return if dead
	 */
	public function looseLife():Int
	{
		if(_nbLive > 0)
			_nbLive--;
		return _nbLive;
	}

}
