//
//  Snake.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/17/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Snake.h"
#import "SnakeTileWorld.h"
#import "Sprite.h"
#import "ResourceManager.h"

@implementation Snake

@synthesize direction;
@synthesize celebrating;
@synthesize speed;
@synthesize headTextureName;
@synthesize tailTextureName;
@synthesize bodyTextureName;
@synthesize bodyBlockSize;
@synthesize positions;

- (id)initWithPos:(CGPoint)pos length:(unsigned int)length {
	[super init];
	bodyBlockSize = TILE_SIZE;
	direction = DIRECTION_EAST;	// facing right
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

// force move the whole snake to pos, arrange body in a straight line
- (void)forceToPos:(CGPoint)pos {
	NSLog(@"forceToPos:%@, old positions: %@", pos, positions);
	if ([world walkable:pos]) {
		NSInteger i = 0;
		for (id currentBlockPosObject in positions) {
			CGPoint currentBlockPos = [currentBlockPosObject CGPointValue];
			CGPoint newBlockPos = CGPointMake(currentBlockPos.x - (i * bodyBlockSize), currentBlockPos.y);
			[positions replaceObjectAtIndex:i withObject:[NSValue valueWithCGPoint:newBlockPos]];
			[currentBlockPosObject release];
			++i;
		}
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
	
	// determine destination
	CGPoint destPos = [self getDestination];
	
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
	SnakeDirection nextDirection = DIRECTION_UNKNOWN;
	if (dx != 0 || dy != 0) {
		if (fabs(dx) > fabs(dy)) {
			if (dx < 0) {
				nextDirection = DIRECTION_EAST;
			} else {
				nextDirection = DIRECTION_WEST;
			}
		} else {
			if (dy < 0) {
				nextDirection = DIRECTION_NORTH;
			} else {
				nextDirection = DIRECTION_SOUTH;
			}
		}
		direction = nextDirection;
	}
	
	if (direction == DIRECTION_UNKNOWN) {
		if (celebrating) {
			facing = @"celebration";
		} else {
			// idle
			NSString *idles[] = {
				@"idle-up", @"idle-left", @"idle", @"idle-right"
			};
			facing = idles[direction];
		}
	} else {
		NSString *walks[] = {
			@"walkup", @"walkleft", @"walkdown", @"walkright"
		};
		facing = walks[direction];
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

- (void)setWorld:(SnakeTileWorld *)newWorld {
	world = newWorld;
}

- (void)drawAtPoint:(CGPoint)offset {
	
}

- (CGPoint)getDestination {
	CGPoint headPosition = [[positions objectAtIndex:0] CGPointValue];
	CGPoint destination;
	switch (direction) {
		case DIRECTION_NORTH:
			destination = CGPointMake(headPosition.x, IPHONE_WIDTH);
			break;
		case DIRECTION_WEST:
			destination = CGPointMake(0, headPosition.y);
			break;
		case DIRECTION_SOUTH:
			destination = CGPointMake(headPosition.x, 0);
			break;
		case DIRECTION_EAST:
			destination = CGPointMake(IPHONE_HEIGHT, headPosition.y);
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@""];
			break;
	}
	return destination;
}

- (void)turnLeft {
	switch (direction) {
		case DIRECTION_NORTH:
			direction = DIRECTION_WEST;
			break;
		case DIRECTION_WEST:
			direction = DIRECTION_SOUTH;
			break;
		case DIRECTION_SOUTH:
			direction = DIRECTION_EAST;
			break;
		case DIRECTION_EAST:
			direction = DIRECTION_NORTH;
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@""];
			break;
	}
}

- (void)turnRight {
	switch (direction) {
		case DIRECTION_NORTH:
			direction = DIRECTION_EAST;
			break;
		case DIRECTION_WEST:
			direction = DIRECTION_NORTH;
			break;
		case DIRECTION_SOUTH:
			direction = DIRECTION_WEST;
			break;
		case DIRECTION_EAST:
			direction = DIRECTION_SOUTH;
			break;
		default:
			[NSException raise:NSInternalInconsistencyException format:@""];
			break;
	}
}

- (void)dealloc {
	[positions removeAllObjects];
	[positions release];
	[super dealloc];
}

@end
