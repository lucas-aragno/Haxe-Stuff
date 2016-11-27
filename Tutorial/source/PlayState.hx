package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.tile.FlxTilemap;
import openfl.Assets;


class PlayState extends FlxState
{
	private var _player:Player;
  public var level:TiledLevel;

	override public function create():Void
	{
		/*
		_player = new Player(20, 20);
		_level = new FlxTilemap();
		var mapData:String  = Assets.getText('assets/data/map.csv');
		var mapTilePath:String = 'assets/images/tiles.png';
		_level.loadMap(mapData, mapTilePath, 16, 16);
		add(_level);
    //add(_player);
		super.create();*/
		level = new TiledLevel("assets/tiled/map.tmx", this);
		add(level.backgroundLayer);
		add(level.imagesLayer);
		add(level.objectsLayer);
		add(level.foregroundTiles);
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
