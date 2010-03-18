//
//  SnakeTileWorld.h
//  Snake Puzzle
//
//  Created by Amudi Sebastian on 3/18/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tile;
@class Entity;

@interface SnakeTileWorld : NSObject {
	Tile ***tiles;
	NSMutableArray *entities;
	CGRect view;	// typically will be the same rect as the screen. in pixels. considered to be in opengl coord (0,0 in bottom left)
	int worldWidth, worldHeight;	// in tiles, defines dimension of ***tiles
	int cameraX, cameraY;	// in pixels, relative to world origin (0,0). view will be centered around this point
	BOOL landscape;
}

@property (readonly) int worldWidth, worldHeight;
@property (nonatomic, assign) BOOL landscape;

- (void)loadLevel:(NSString *)levelFilename withTiles:(NSString *)imageFilename;

- (SnakeTileWorld *)initWithFrame:(CGRect)frame;
- (void)draw;
- (void)setCamera:(CGPoint)position;
- (CGPoint)worldPosition:(CGPoint)screenPosition;

- (void)addEntity:(Entity *)entity;
- (void)removeEntity:(Entity *)entity;
- (Tile *)tileAt:(CGPoint)worldPosition;
- (BOOL)walkable:(CGPoint)point;

- (NSArray *)entitiesNear:(CGPoint)point withRadius:(float)radius;

@end
