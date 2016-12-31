package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.editors.tiled.TiledTileLayer;
import flixel.addons.editors.tiled.TiledObjectLayer;
import flixel.addons.editors.tiled.TiledMap;
import flixel.tile.FlxBaseTilemap;
import openfl.Assets;
import flixel.FlxObject;


class PlayState extends FlxState
{
	private var _player:Player;
  private var _map:TiledMap;
	private var _mWalls:FlxTilemap;
  private var _grpCoins:FlxTypedGroup<Coin>;

	override public function create():Void
	{
		_map = new TiledMap("assets/tiled/map.tmx");
		var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
		_mWalls = new FlxTilemap();
		_mWalls.loadMapFromArray(cast(_map.getLayer("walls"), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		_mWalls.follow();
    _mWalls.setTileProperties(2, FlxObject.NONE);
    _mWalls.setTileProperties(3, FlxObject.ANY);
    add(_mWalls);
		_grpCoins = new FlxTypedGroup<Coin>();
		add(_grpCoins);
		for (e in tmpMap.objects)
		{
			placeEntities(e.type, e.xmlData.x);
		}
		add(_player);
		FlxG.camera.follow(_player, TOPDOWN, 1);
		super.create();
	}

	public function placeEntities(type:String, data:Xml):Void
	{
		var x:Int = Std.parseInt(data.get("x"));
		var y:Int = Std.parseInt(data.get("y"));
		if (type == "player")
		{
		   _player = new Player(x, y);
		}  else if (type == "coin")
    {
		  _grpCoins.add(new Coin(x - 4, y + 4));
    }
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(_player, _mWalls);
		FlxG.overlap(_player, _grpCoins, playerTouchCoin);
		super.update(elapsed);
	}

	private function playerTouchCoin(P:Player, C:Coin):Void
	{
		if (P.alive && P.exists && C.alive && C.exists) {
			C.kill();
		}
	}
}
