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
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);
	}
}
