//
//  Consumable.m
//  Snake Puzzle
//
//  Created by Amudi Sebastian on 3/20/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Consumable.h"
#import "Snake.h"

@implementation Consumable

- (id)initWithPos:(CGPoint)pos sprite:(Sprite *)spr {
	tilePosition = pos;
	CGPoint worldPosition = CGPointMake(tilePosition.x * TILE_SIZE, tilePosition.y * TILE_SIZE);
	[super initWithPos:worldPosition sprite:spr];
	return self;
}

- (void)applyEffect:(Snake *)snake {
	// do nothing, implemented by subclasses
}

@end
