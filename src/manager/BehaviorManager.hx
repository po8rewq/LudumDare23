package manager;

/**
 * ...
 * @author adrien
 */
class BehaviorManager 
{	
#if debug
	private static inline var GOD_MOD : Bool = false;
#end

	private static var _self : BehaviorManager;

	/** Behaviors list */
	private var _behaviors : Hash<Bool>; // indicé par le nom du behavior, le bool savoir si c'est actif ou non

	private function new () 
	{	
		_behaviors = new Hash();
	}		
	
	public static function getInstance():BehaviorManager
	{
		if(_self == null)
			_self = new BehaviorManager();
		return _self;
	}
	
	public function addBehavior(pName: String, ?pIsActive: Bool = true)
	{
		_behaviors.set(pName, pIsActive);
	}
	
	public function can(pName: String):Bool
	{
	#if debug
		if(GOD_MOD) return true;
	#end
		if(_behaviors.exists(pName))
			return _behaviors.get(pName);
		return false;
	}
	
	/**
	 * @param pBehavior : "behavior1,behavior2"
	 */
	public function update(pBehaviors:String):Void
	{
		if(pBehaviors == '') return;
		var behaviors : Array<String> = pBehaviors.split(',');
		for(b in behaviors)
			addBehavior(b);
	}
	
	public function clear()
	{
		_behaviors = new Hash();
	}

}

enum Behaviors {
	walk;
	jump;
	//doublejump;
	fire;	
}