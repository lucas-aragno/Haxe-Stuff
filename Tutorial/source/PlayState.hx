package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
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

	override public function create():Void
	{
		_map = new TiledMap("assets/tiled/map.tmx");
		var tmpMap:TiledObjectLayer = cast _map.getLayer("entities");
		for (e in tmpMap.objects)
    {
		  placeEntities(e.type, e.xmlData.x);
    }
		_mWalls = new FlxTilemap();
		_mWalls.loadMapFromArray(cast(_map.getLayer("walls"), TiledTileLayer).tileArray, _map.width, _map.height, AssetPaths.tiles__png, _map.tileWidth, _map.tileHeight, FlxTilemapAutoTiling.OFF, 1, 1, 3);
		_mWalls.follow();
    _mWalls.setTileProperties(2, FlxObject.NONE);
    _mWalls.setTileProperties(3, FlxObject.ANY);
    add(_mWalls);
		add(_player);
		FlxG.camera.follow(_player, TOPDOWN, 1);
		super.create();
	}

	public function placeEntities(type:String, data:Xml):Void
	{
		trace("data: ========");
		trace(data);
		var x:Int = Std.parseInt(data.get("x"));
		var y:Int = Std.parseInt(data.get("y"));
		if (type == "player")
		{
		   _player = new Player(x, y);
		}
	}

	override public function update(elapsed:Float):Void
	{
		FlxG.collide(_player, _mWalls);
		super.update(elapsed);
	}
}
