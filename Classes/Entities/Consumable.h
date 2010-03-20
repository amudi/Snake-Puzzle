//
//  Consumable.h
//  Snake Puzzle
//
//  Created by Amudi Sebastian on 3/20/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@class Snake;

// A Consumable is a sprite with static location.
// Can give effect to Snake when eaten.
@interface Consumable : Entity {
	CGPoint tilePosition;
}

// pos is in tile unit
- (id)initWithPos:(CGPoint)pos sprite:(Sprite *)spr;
- (void)applyEffect:(Snake *)snake;

@end
