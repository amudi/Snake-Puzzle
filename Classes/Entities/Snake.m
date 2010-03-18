//
//  Snake.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/17/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Snake.h"
#import "TileWorld.h"
#import "Sprite.h"
#import "ResourceManager.h"

@implementation Snake

@synthesize celebrating;
@synthesize speed;
@synthesize headTextureName;
@synthesize tailTextureName;
@synthesize bodyTextureName;
@synthesize bodyBlockSize;
@synthesize positions;

- (id)initWithPos:(CGPoint)pos length:(NSInteger)length {
	[super init];
	bodyBlockSize = TILE_SIZE;
	lastDirection = 3;	// facing right
	celebrating = NO;
	dying = NO;
	speed = 200;	// default speed

	NSInteger bodyLength = length;
	if (bodyLength <= 0) {
		bodyLength = 3;	// length minimum should be 3: head-body-tail
	}
	positions = [NSMutableArray arrayWithCapacity:length];
	
	// make snake in straight line, facing right
	for (int i = 0; i < bodyLength; ++i) {
		[positions addObject:[NSValue valueWithCGPoint:CGPointMake(pos.x - (bodyLength * i), pos.y)]];
	}
	
	return self;
}

- (void)moveToPosition:(CGPoint)point {
	destPos = point;
}

- (BOOL)doneMoving {
	CGPoint headLocation = [[positions objectAtIndex:0] CGPointValue];
	return  headLocation.x == destPos.x && headLocation.y == destPos.y;
}

// force move the whole snake to pos, arrange body in a straight line
- (void)forceToPos:(CGPoint)pos {
	NSLog(@"forceToPos:%@, old positions: %@", pos, positions);
	if ([world walkable:pos]) {
		NSInteger i = 0;
		for (id blockPosObject in positions) {
			CGPoint blockPos = [blockPosObject CGPointValue];
			blockPos.x = pos.x - (i * bodyBlockSize);
			++i;
		}
		destPos = pos;
	}
	NSLog(@"New positions: %@", positions);
}

- (void)dieWithAnimation:(NSString *)deathAnim {
	if (!dying) {	// make sure we only die once
		dying = YES;
		// TODO: animate death
	}
}

- (void)update:(CGFloat)time {
	float xSpeed = speed * time;
	float ySpeed = speed * time;
	
	if (dying) {
		xSpeed = ySpeed = 0;
	}
	
	NSMutableArray* revertPositions = [NSMutableArray arrayWithArray:positions];
	CGPoint revertPos = [[revertPositions objectAtIndex:0] CGPointValue];
	CGPoint worldPos = [[positions objectAtIndex:0] CGPointValue];
	float dx = worldPos.x - destPos.x;
	if (dx != 0) {
		if (fabs(dx) < xSpeed) {
			worldPos.x = destPos.x;
		} else {
			worldPos.x += -sign(dx) * xSpeed;
		}
	}
	
	float dy = worldPos.y - destPos.y;
	if (dy != 0) {
		if (fabs(dy) < ySpeed) {
			worldPos.y = destPos.y;
		} else {
			worldPos.y += -sign(dy) * ySpeed;
		}
	}
	
	if (![world walkable:worldPos]) {
		if ([world walkable:CGPointMake(worldPos.x, revertPos.y)]) {
			// just revert y so we can slide along the wall
			worldPos = CGPointMake(worldPos.x, revertPos.y);
			if (dx == 0) destPos = worldPos;
		} else if ([world walkable:CGPointMake(revertPos.x, worldPos.y)]) {
			// just revert x so we can slide along wall
			worldPos = CGPointMake(revertPos.x, worldPos.y);
			if (dy == 0) destPos = worldPos;
		} else {
			// can't move here
			worldPos = revertPos;
			destPos = worldPos;
		}
	}
		
	NSString *facing = nil;
	int direction = -1;
	if (dx != 0 || dy != 0) {
		if (fabs(dx) > fabs(dy)) {
			if (dx < 0) {
				direction = 3;
			} else {
				direction = 1;
			}
		} else {
			if (dy < 0) {
				direction = 0;
			} else {
				direction = 2;
			}
		}
		lastDirection = direction;
	}
	
	if (direction == -1) {
		if (celebrating) {
			facing = @"celebration";
		} else {
			// idle
			NSString *idles[] = {
				@"idle-up", @"idle-left", @"idle", @"idle-right"
			};
			facing = idles[lastDirection];
		}
	} else {
		NSString *walks[] = {
			@"walkup", @"walkleft", @"walkdown", @"walkright"
		};
		facing = walks[lastDirection];
	}
	
	if (dying) {
		// let the dying animation proceed
	} else {
		// check if different than current facing
		//if (facing && ![sprite.sequence isEqualToString:facing]) {
			// TODO: set facing
		//}
	}
	
	// update graphic
	//[sprite update:time];
}

- (void)addBody {
	
}

- (void)setWorld:(TileWorld *)newWorld {
	world = newWorld;
}

- (void)drawAtPoint:(CGPoint)offset {
	
}

- (void)dealloc {
	[positions removeAllObjects];
	[positions release];
	[super dealloc];
}

@end
