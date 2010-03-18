//
//  Sprite.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Sprite.h"
#import "ResourceManager.h"
#import "Animation.h"

@implementation Sprite

@synthesize anim;
@synthesize sequence;
@synthesize currentFrame;

+ (Sprite *)spriteWithAnimation:(Animation *)anim {
	Sprite *retval = [[Sprite alloc] init];
	retval.anim = anim;
	retval.sequence = [retval.anim firstSequence];
	[retval autorelease];
	return retval;
}

- (void)drawAtPoint:(CGPoint)point {
	[anim drawAtPoint:point withSequence:sequence withFrame:currentFrame];
}

- (void)update:(float)time {
	AnimationSequence *seq = [anim get:sequence];
	if (seq->timeout == nil) {
		++currentFrame;
		if (currentFrame >= [anim getFrameCount:sequence]) {
			currentFrame = 0;
		}
	} else {
		sequenceTime += time;
		if (sequenceTime > seq->timeout[seq->frameCount - 1]) {
			if (seq->next == nil) {
				sequenceTime -= seq->timeout[seq->frameCount - 1];
			} else {
				self.sequence = seq->next;
			}
		}
		for (int i = 0; i < seq->frameCount; ++i) {
			if (sequenceTime < seq->timeout[i]) {
				currentFrame = i;
				break;
			}
		}
	}
}

- (void)setSequence:(NSString *)seq {
	[seq retain];
	[self->sequence release];
	self->sequence = seq;
	currentFrame = 0;
	sequenceTime = 0;
}

- (void)dealloc {
	[anim release];
	[self->sequence release];
	[super dealloc];
}

@end
