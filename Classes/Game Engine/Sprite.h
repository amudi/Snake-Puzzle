//
//  Sprite.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Animation;

@interface Sprite : NSObject {
	Animation *anim;
	NSString *sequence;
	float sequenceTime;
	int currentFrame;
}

@property (nonatomic, retain) Animation *anim;
@property (nonatomic, retain) NSString *sequence;
@property (nonatomic, readonly) int currentFrame;

+ (Sprite *)spriteWithAnimation:(Animation *)anim;
- (void)drawAtPoint:(CGPoint)point;
- (void)update:(float)time;

@end
