//
//  Entity.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Entity.h"
#import "ResourceManager.h"
#import "Sprite.h"
#import "TileWorld.h"
#import "Tile.h"
#import "Rideable.h"

@implementation Entity

@synthesize sprite;
@synthesize position = worldPos;

- (id)initWithPos:(CGPoint)pos sprite:(Sprite *)spr {
	[super init];
	self.sprite = spr;
	worldPos = pos;
	return self;
}

- (void)forceToPos:(CGPoint)pos {
	worldPos = pos;
}

- (void)drawAtPoint:(CGPoint)offset {
	offset.x += worldPos.x;
	offset.y += worldPos.y;
	[sprite drawAtPoint:offset];
}

- (void)update:(CGFloat)time {
	[sprite update:time];
}

- (NSComparisonResult)depthSort:(Entity *)other {
	if (self->worldPos.y > other->worldPos.y) return NSOrderedAscending;
	if (self->worldPos.y < other->worldPos.y) return NSOrderedDescending;
	// use memory addresses for a tie-breaker
	if (self < other) return NSOrderedDescending;
	return NSOrderedAscending;
}

- (void)setWorld:(TileWorld *)newWorld {
	world = newWorld;
}

- (void)dealloc {
	[sprite release];
	[super dealloc];
}

@end
