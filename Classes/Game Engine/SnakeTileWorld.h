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
@class Snake;

@interface SnakeTileWorld : NSObject {
	Tile ***tiles;
	NSMutableArray *entities;
	Snake *snake;
	CGRect view;	// typically will be the same rect as the screen. in pixels. considered to be in opengl coord (0,0 in bottom left)
	int worldWidth, worldHeight;	// in tiles, defines dimension of ***tiles
	BOOL landscape;
}

@property (readonly) int worldWidth, worldHeight;
@property (nonatomic, assign) BOOL landscape;

- (void)loadLevel:(NSString *)levelFilename withTiles:(NSString *)imageFilename;

- (SnakeTileWorld *)initWithFrame:(CGRect)frame;
- (void)draw;
- (CGPoint)worldPosition:(CGPoint)screenPosition;

- (void)addEntity:(Entity *)entity;
- (void)removeEntity:(Entity *)entity;
- (void)setSnake:(Snake *)newSnake;
- (Tile *)tileAt:(CGPoint)worldPosition;
- (BOOL)walkable:(CGPoint)point;

@end
