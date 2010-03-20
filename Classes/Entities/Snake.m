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
@synthesize bodyLength;
@synthesize bodyBlockSize;
@synthesize positions;

- (id)initWithPos:(CGPoint)pos length:(NSInteger)length {
	[super init];
	bodyBlockSize = TILE_SIZE;
	direction = DIRECTION_EAST;	// facing right
	celebrating = NO;
	dying = NO;
	speed = 5;	// default speed

	headTextureName = @"Head.png";
	bodyTextureName = @"Body.png";
	tailTextureName = @"Tail.png";
	
	movedDistance = 0.0f;
	
	bodyLength = length;
	if (bodyLength <= 3) {
		bodyLength = 3;	// length minimum should be 3: head-body-tail
	}
	
	positions = [[NSMutableArray alloc] initWithCapacity:length];
	
	// make snake in straight line, facing right
	for (int i = 0; i < bodyLength; ++i) {
		CGPoint bodyPos = CGPointMake(pos.x - i, pos.y);
		NSValue *bodyPosValue = [[NSValue value:&bodyPos withObjCType:@encode(CGPoint)] retain];
		[positions addObject:bodyPosValue];
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
	movedDistance += speed * time;
	
	if (dying) {
		speed = 0;
	}
	
	if (movedDistance >= 1.0f) {
		movedDistance -= 1.0f;
		[self moveForward];
	}
	
	[self drawAtPoint:CGPointMake(0.0f, 0.0f)];
}

- (void)addBody {
	
}

- (void)setWorld:(SnakeTileWorld *)newWorld {
	world = newWorld;
}

- (void)drawAtPoint:(CGPoint)offset {
	for (NSValue *currentObject in positions) {
		GLTexture *bodyTex = [gResManager getTexture:bodyTextureName];
		CGPoint worldPos = [currentObject CGPointValue];
		CGPoint screenPos = CGPointMake(offset.x, offset.y);
		screenPos.x += worldPos.x;
		screenPos.y += worldPos.y;
		screenPos.x *= TILE_SIZE;
		screenPos.y *= TILE_SIZE;
		[bodyTex drawAtPoint:screenPos];
	}
}

- (CGPoint)getDestination {
	CGPoint headPosition = [[positions objectAtIndex:0] CGPointValue];
	CGPoint destination;
	switch (direction) {
		case DIRECTION_NORTH:
			destination = CGPointMake(headPosition.x, IPHONE_WIDTH / TILE_SIZE);
			break;
		case DIRECTION_WEST:
			destination = CGPointMake(0, headPosition.y);
			break;
		case DIRECTION_SOUTH:
			destination = CGPointMake(headPosition.x, 0);
			break;
		case DIRECTION_EAST:
			destination = CGPointMake(IPHONE_HEIGHT / TILE_SIZE, headPosition.y);
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

- (void)moveForward {
	// determine destination
	CGPoint destPos = [self getDestination];
	
	// move last block of body to the front
	CGPoint headPosition = [[positions objectAtIndex:0] CGPointValue];
	
	if (headPosition.x == destPos.x && headPosition.y == destPos.y) {
		// collided with wall?
		dying = YES;
		return;
	} else {
		// remove from last element, then insert at index 0
		[positions removeLastObject];
		CGPoint head = [[positions objectAtIndex:0] CGPointValue];
		NSValue *newHead;
		CGPoint newHeadPoint;
		switch (direction) {
			case DIRECTION_NORTH:
				newHeadPoint = CGPointMake(head.x, head.y + 1);
				break;
			case DIRECTION_WEST:
				newHeadPoint = CGPointMake(head.x - 1, head.y);
				break;
			case DIRECTION_SOUTH:
				newHeadPoint = CGPointMake(head.x, head.y - 1);
				break;
			case DIRECTION_EAST:
				newHeadPoint = CGPointMake(head.x + 1, head.y);
				break;
			default:
				[NSException raise:NSInternalInconsistencyException format:@""];
				break;
		}
		newHead = [[NSValue valueWithCGPoint:newHeadPoint] retain];
		[positions insertObject:newHead atIndex:0];
	}

}

- (void)dealloc {
	[positions removeAllObjects];
	[positions release];
	[super dealloc];
}

@end
