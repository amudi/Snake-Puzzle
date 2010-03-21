//
//  SnakeTileWorld.m
//  Snake Puzzle
//
//  Created by Amudi Sebastian on 3/18/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "SnakeTileWorld.h"
#import "Tile.h"
#import "Sprite.h"
#import "ResourceManager.h"
#import "Entity.h"
#import "pointmath.h"

@implementation SnakeTileWorld

@synthesize worldWidth;
@synthesize worldHeight;
@synthesize landscape;

- (void)allocateWidth:(int)width height:(int)height {
	worldWidth = width;
	worldHeight = height;
	tiles = (Tile ***) malloc(width * sizeof(Tile **));
	for (int x = 0; x < width; ++x) {
		tiles[x] = (Tile **) malloc(height * sizeof(Tile *));
		for (int y = 0; y < height; ++y) {
			tiles[x][y] = [[Tile alloc] init];
		}
	}
}

- (SnakeTileWorld *)initWithFrame:(CGRect)frame {
	[super init];
	view = frame;
	return self;
}

- (void)loadLevel:(NSString *)levelFilename withTiles:(NSString *)imageFilename {
	NSData *fileData = [gResManager getBundledData:levelFilename];
	NSString *dush = [[NSString alloc] initWithData:fileData encoding:NSASCIIStringEncoding];
	
	NSArray *rows = [dush componentsSeparatedByString:@"\n"];
	int rowIndex = 0;
	NSArray *wh = [[rows objectAtIndex:rowIndex] componentsSeparatedByString:@"x"];
	int width = [[wh objectAtIndex:0] intValue];
	int height = [[wh objectAtIndex:1] intValue];
	[self allocateWidth:width height:height];
	++rowIndex;
	
	DLog(@"loadlevel dimension %dx%d", width, height);
	
	for (int y = 0; y < worldHeight; ++y) {
		NSArray *row = [[rows objectAtIndex:rowIndex] componentsSeparatedByString:@","];
		for (int x = 0; x < worldWidth; ++x) {
			int tile = [[row objectAtIndex:x] intValue];
			int tx = (tile * (int)TILE_SIZE) % kMaxTextureSize;
			int row = ((tile * TILE_SIZE) - tx) / kMaxTextureSize;
			int ty = row * TILE_SIZE;
			[tiles[x][worldHeight - y - 1] initWithTexture:imageFilename withFrame:CGRectMake(tx, ty, TILE_SIZE, TILE_SIZE)];
		}
		++rowIndex;
	}
	++rowIndex;
	for (int y = 0; y < worldHeight; ++y) {
		NSArray *row = [[rows objectAtIndex:rowIndex] componentsSeparatedByString:@","];
		for (int x = 0; x < worldWidth; ++x) {
			int flags = [[row objectAtIndex:x] intValue];
			tiles[x][worldHeight - y - 1]->flags = (PhysicsFlags)flags;
		}
		++rowIndex;
	}
	[dush release];
}

- (void)draw {
	CGFloat xoff, yoff;
	xoff = view.origin.x;
	yoff = view.origin.y;
	CGRect rect = CGRectMake(0, 0, TILE_SIZE, TILE_SIZE);
	
	for (int x = 0; x < worldWidth; ++x) {
		rect.origin.x = x * TILE_SIZE + xoff;
		
		// optimization: don't draw offscreen tiles
		if (rect.origin.x + rect.size.width < view.origin.y ||
			rect.origin.x > view.origin.y + view.size.height) {
			continue;
		}
		
		for (int y = 0; y < worldHeight; ++y) {
			rect.origin.y = y * TILE_SIZE + yoff;
			if (rect.origin.y + rect.size.height < view.origin.x ||
				rect.origin.y > view.origin.x + view.size.width) {
				continue;
			}
			[tiles[x][y] drawInRect:rect];
		}
	}
	if (entities) {
		[entities sortUsingSelector:@selector(depthSort:)];
		for (Entity *entity in entities) {
			[entity drawAtPoint:CGPointMake(xoff, yoff)];
		}
	}
	if (snake != nil) {
		[snake drawAtPoint:CGPointMake(xoff, yoff)];
	}
}

- (void)addEntity:(Entity *)entity {
	if (!entities) {
		entities = [[NSMutableArray alloc] init];
	}
	[entity setWorld:self];
	[entities addObject:entity];
}

- (void)removeEntity:(Entity *)entity {
	[entities removeObject:entity];
}

- (void)setSnake:(Snake *)newSnake {
	snake = newSnake;
	[snake setWorld:self];
}

// used when tapping an area of the screen to move player
- (CGPoint)worldPosition:(CGPoint)screenPosition {
	int xoff, yoff;
	// get actual world position (in pixel)
	xoff = view.origin.x;
	yoff = view.origin.y;
	
	// convert pixel position to tile position
	// calculate tile offset in tile
	int xTileOff = xoff / TILE_SIZE + (xoff % TILE_SIZE > 0 ? 1 : 0);
	int yTileOff = yoff / TILE_SIZE + (yoff % TILE_SIZE > 0 ? 1 : 0);
	
	// calculate touch position in tile
	int xScreenPosInt = (int)screenPosition.x;
	int yScreenPosInt = (int)screenPosition.y;
	int xTilePos = (xScreenPosInt / TILE_SIZE) + (xScreenPosInt % TILE_SIZE > 0 ? 1 : 0);
	int yTilePos = (yScreenPosInt / TILE_SIZE) + (yScreenPosInt % TILE_SIZE > 0 ? 1 : 0);
	
	DLog(@"tap at tile (%d, %d)", xTilePos, yTilePos);
	return CGPointMake(xTileOff + xTilePos, yTileOff + yTilePos);
}

// used by entities to get the tile they are standing over
- (Tile *)tileAt:(CGPoint)worldPosition {
	int x = worldPosition.x / TILE_SIZE;
	int y = worldPosition.y / TILE_SIZE;
	if (worldPosition.x < 0 || worldPosition.y < 0 || x >= worldWidth || y >= worldHeight) {
		return nil;
	}
	return tiles[x][y];
}

- (BOOL)walkable:(CGPoint)point {
	Tile *overtile = [self tileAt:point];
	return !(overtile == nil || (overtile->flags & UNWALKABLE) != 0);
}

- (void)dealloc {
	for (int x = 0; x < worldWidth; ++x) {
		for (int y = 0; y < worldHeight; ++y) {
			[tiles[x][y] release];
		}
		free(tiles[x]);
	}
	free(tiles);
	[entities removeAllObjects];
	[entities release];
	[snake release];
	[super dealloc];
}

@end
