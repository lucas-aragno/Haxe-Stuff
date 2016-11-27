package;

import openfl.Assets;
import haxe.io.Path;
import haxe.xml.Parser;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tile.FlxTilemap;
import flixel.editors.tiled.TiledMap;
import flixel.editors.tiled.TiledObject;
import flixel.editors.tiled.TiledObjectGroup;
import flixel.editors.tiled.TiledTileSet;

class TiledImport extends TiledMap
{
	//The path to your tilemaps. Edit this if you do not have your maps in "assets/data/maps".
	private inline static var c_PATH_LEVEL_TILESHEETS = "assets/data/maps/";

	// The three layers that this script will load.
	public var foregroundTiles:FlxGroup;
	public var backgroundTiles:FlxGroup;
	public var collisionTiles:FlxGroup;

	//Collidable tiles (Don't worry about this)
	private var collidableTileLayers:Array<FlxTilemap>;

	public function new(tiledLevel:Dynamic)
	{
		super(tiledLevel);


		//The three layers that this script will load.

		foregroundTiles = new FlxGroup();
		backgroundTiles = new FlxGroup();
		collisionTiles = new FlxGroup();

		//The collision tiles should only be visible in Tiled, if you want them to be visible in-game, delete the line of code under this comment.
		collisionTiles.visible = false;


		//Set World bounds and camera bounds. You do not need to set camera bounds if you don't want to.

		FlxG.camera.setBounds(0, 0, fullWidth, fullHeight, true);
		FlxG.worldBounds.set(0, 0, fullWidth, fullHeight);

		// Load Tile Maps
		for (tileLayer in layers)
		{
			/*
			 * These are custom variables you need to set within your layers inside of the editor.
			 * So a layer, prehaps "Tile Layer 1", would require the custom variables "tileset" and "layer"
			 * The "tileset" variable should be set to whichever tileset the layer is using, this limits your layers to one tileset.
			 * We will get to the "layer" variable later.
			 */
			var tileSheetName:String = tileLayer.properties.get("tileset");
			var tileLayerName:String = tileLayer.properties.get("layer");

			/*
			 * This part is used for splashing errors. Nothing in this part really matters (for beginners, at least.), so just go on to the next comment.
			 */

			if (tileSheetName == null)
				throw "'tileset' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";

			if (tileLayerName == null)
				throw "'layer' property not defined for the '" + tileLayer.name + "' layer. Please add the property to the layer.";


			var tileSet:TiledTileSet = null;
			for (ts in tilesets)
			{
				if (ts.name == tileSheetName)
				{
					tileSet = ts;
					break;
				}
			}

			if (tileSet == null)
				throw "Tileset '" + tileSheetName + " not found. Did you mispell the 'tilesheet' property in " + tileLayer.name + "' layer?";

			var imagePath 		= new Path(tileSet.imageSource);
			var processedPath 	= c_PATH_LEVEL_TILESHEETS + imagePath.file + "." + imagePath.ext;

			var tilemap:FlxTilemap = new FlxTilemap();
			tilemap.widthInTiles = width;
			tilemap.heightInTiles = height;
			tilemap.loadMap(tileLayer.tileArray, processedPath, tileSet.tileWidth, tileSet.tileHeight, 0, tileSet.firstGID, 1, 1);

			/*
			 * This is for loading layers. You can add more if you'd like, but I have set up some simple layers here.
			 * To set the layer in Tiled, click on the layer you want to set. Then add a custom variable titled "layer"
			 * Your new "layer" variable should equal one of the layers referenced below.
			 * (layer should be "foreground", "background", etc.)
			 *
			 * Graphical layers that only serve for, well, graphical purposes only require this code:
			 * 	foregroundTiles.add(tilemap);
			 *
			 * Layers that must collide require this code:
			  	if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();

				collisionTiles.add(tilemap);

				collidableTileLayers.push(tilemap);
			 */

			if (tileLayerName == 'foreground')
			{
				foregroundTiles.add(tilemap);
			}
			else if (tileLayerName == 'background')
			{
				backgroundTiles.add(tilemap);
			}
			else if (tileLayerName == 'collisions')
			{
				/*
				 * All collidable layers require the below code:
				 */
				if (collidableTileLayers == null)
					collidableTileLayers = new Array<FlxTilemap>();

				collisionTiles.add(tilemap);

				collidableTileLayers.push(tilemap);
			}
		}
	}

	public function loadObjects(state:PlayState)
	{
		for (group in objectGroups)
		{
			for (o in group.objects)
			{
				loadObject(o, group, state);
			}
		}
	}

	private function loadObject(o:TiledObject, g:TiledObjectGroup, state:PlayState)
	{
		var x:Int = o.x;
		var y:Int = o.y;

		if (o.gid != -1)
			y -= g.map.getGidOwner(o.gid).tileHeight;

		switch (o.type.toLowerCase())
		{
			/*
			 * This is for importing objects. The objects within Tiled require their "type" variable to equal something, for example "player"
			 *
			 * Example Object Loading:
			 *
			 * case "player":
			 * 	_state.player.x = x;
			 * 	_state.player.y = y;
			 *
			 * This would set the PlayState's player x and y variables to the object's x and y.
			 * (That should be obvious)
			 */

			case "null":
				//Don't do anything. You should delete this once you add actual objects.
		}
	}

	public function collideWithLevel(obj:FlxObject, ?notifyCallback:FlxObject->FlxObject->Void, ?processCallback:FlxObject->FlxObject->Bool):Bool
	{
		if (collidableTileLayers != null)
		{
			for (map in collidableTileLayers)
			{
				return FlxG.overlap(map, obj, notifyCallback, processCallback != null ? processCallback : FlxObject.separate);
			}
		}
		return false;
	}
}
