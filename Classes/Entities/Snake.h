//
//  Snake.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/17/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SnakeTileWorld;

typedef enum {
	DIRECTION_UNKNOWN = -1,
	DIRECTION_NORTH = 0,
	DIRECTION_WEST = 1,
	DIRECTION_SOUTH = 2,
	DIRECTION_EAST = 3,
} SnakeDirection;

@interface Snake : NSObject {
	SnakeDirection direction;
	BOOL celebrating;
	BOOL dying;
	int speed;
	SnakeTileWorld *world;
@private
	NSString *headTextureName;
	NSString *tailTextureName;
	NSString *bodyTextureName;
	NSMutableArray *positions;	// array of tiles (CGPoint) coordinates of snake's blocks
	int bodyBlockSize;
}

@property (readonly) SnakeDirection direction;
@property (nonatomic) BOOL celebrating;
@property (nonatomic, assign) int speed;
@property (nonatomic, retain) NSString *headTextureName;
@property (nonatomic, retain) NSString *tailTextureName;
@property (nonatomic, retain) NSString *bodyTextureName;
@property (nonatomic, assign) int bodyBlockSize;
@property (nonatomic, retain) NSMutableArray *positions;

- (id)initWithPos:(CGPoint)pos length:(NSInteger)length;
- (void)dieWithAnimation:(NSString *)deathAnim;
- (void)addBody;

- (void)drawAtPoint:(CGPoint)offset;
- (void)update:(CGFloat)time;
- (void)setWorld:(SnakeTileWorld *)newWorld;
- (void)forceToPos:(CGPoint)pos;

// movement
- (void)turnLeft;
- (void)turnRight;
- (CGPoint)getDestination;

@end
