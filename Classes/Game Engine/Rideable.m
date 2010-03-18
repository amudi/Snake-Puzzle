//
//  Rideable.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Rideable.h"
#import "Sprite.h"
#import "SnakeTileWorld.h"

@implementation Rideable

- (id)initWithPos:(CGPoint)pos sprite:(Sprite *)spr {
	[super initWithPos:pos sprite:spr];
	bounds = CGRectMake(-57, -17, 113, 17);	// should probably be moved to animation.plist and Animation or Sprite
	return self;
}

- (BOOL)under:(CGPoint)point {
	if (point.x > self.position.x + bounds.origin.x &&
		point.x < self.position.x + bounds.origin.x + bounds.size.width &&
		point.y > self.position.y + bounds.origin.y &&
		point.y < self.position.y + bounds.origin.y + bounds.size.height) {
		return YES;
	}
	return NO;
}

- (void)update:(CGFloat)time {
	if (mRider && [sprite.sequence isEqualToString:@"sinking"]) {
		if (sprite.currentFrame > sunkFrame) {
			sunkFrame = sprite.currentFrame;
			int sinkOffset[] = {1,9,5,5,8};
			[mRider forceToPos:CGPointMake(mRider.position.x, mRider.position.y - sinkOffset[sunkFrame])];
		}
	}
	[super update:time];
}

- (void)drawAtPoint:(CGPoint)offset {
	if ([sprite.sequence isEqualToString:@"sunk"]) {
		return;
	}
	[super drawAtPoint:offset];
}

- (void)markRidden:(Entity *)rider {
	mRider = rider;
	sunkFrame = 0;
	if (rider) {
		sprite.sequence = @"sinking";
	} else {
		sprite.sequence = @"rising";
	}

}

@end
