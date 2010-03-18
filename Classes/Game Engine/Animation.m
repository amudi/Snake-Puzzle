//
//  Animation.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Animation.h"
#import "ResourceManager.h"

@implementation AnimationSequence

- (AnimationSequence *)initWithFrames:(NSDictionary *)animData width:(float)width height:(float)height {
	[super init];
	NSArray *framesData = [[animData valueForKey:@"anim"] componentsSeparatedByString:@","];
	NSArray *timeoutData = [[animData valueForKey:@"time"] componentsSeparatedByString:@","];	// will be nil if "time" is not present
	BOOL flip = [[animData valueForKey:@"flipHorizontal"] boolValue];
	self->next = [[animData valueForKey:@"next"] retain];
	frameCount = [framesData count];
	frames = malloc(frameCount * sizeof(CGRect));
	flipped = flip;
	for (int i = 0; i < frameCount; ++i) {
		// find where the frame is located
		int frame = [[framesData objectAtIndex:i] intValue];
		int x = (frame * (int)width) % kMaxTextureSize;
		int row = ((frame * width) - x) / kMaxTextureSize;
		int y = row * height;
		frames[i] = CGRectMake(x, y, width, height);
	}
	timeout = nil;
	if (timeoutData) {
		timeout = malloc(frameCount * sizeof(float));
		for (int i = 0; i < frameCount; ++i) {
			timeout[i] = [[timeoutData objectAtIndex:i] floatValue] / 1000.0f;
			if (i > 0) {
				timeout[i] += timeout[i - 1];
			}
		}
	}
	return self;
}

- (void)dealloc {
	free(frames);
	if (timeout) free(timeout);
	[self->next release];
	[super dealloc];
}

@end

@implementation Animation

- (Animation *)initWithAnim:(NSString *)img {
	NSData *pData;
	pData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Animations" ofType:@"plist"]];
	NSString *error;
	NSDictionary *animData;
	NSPropertyListFormat format;
	animData = [NSPropertyListSerialization propertyListFromData:pData mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&error];
	
	if (error) {
		NSLog(@"plist read error %@", error);
		[error release];
	}
	
	animData = [animData objectForKey:img];
	
	GLTexture *tex = [gResManager getTexture:img];
	image = img;
	
	float frameWidth;
	float frameHeight;
	if ([animData objectForKey:@"frameCount"]) {
		int frameCount = [[animData objectForKey:@"frameCount"] intValue];
		frameWidth = [tex width] / (float)frameCount;
		frameHeight = [tex height];
	}
	
	if ([animData objectForKey:@"frameSize"]) {
		NSArray *wh = [[animData objectForKey:@"frameSize"] componentsSeparatedByString:@"x"];
		frameWidth = [[wh objectAtIndex:0] intValue];
		frameHeight = [[wh objectAtIndex:1] intValue];
		NSLog(@"framesize read as %f, %f", frameWidth, frameHeight);
	}
	
	// anchor is the position in the image that is considered the center, in pixel, relative to the bottom left corner
	NSString *anchorData = [animData valueForKey:@"anchor"];
	if (anchorData) {
		NSArray *tmp = [anchorData componentsSeparatedByString:@","];
		anchor.x = [[tmp objectAtIndex:0] floatValue];
		anchor.y = [[tmp objectAtIndex:1] floatValue];
	}
	
	NSEnumerator *enumerator = [animData keyEnumerator];
	NSString *key;
	NSMutableDictionary *sequenceTmp = [NSMutableDictionary dictionaryWithCapacity:1];
	
	while ((key = [enumerator nextObject])) {
		NSDictionary *sequenceData = [animData objectForKey:key];
		if (![sequenceData isKindOfClass:[NSDictionary class]]) {
			continue;
		}
		AnimationSequence *tmp = [[AnimationSequence alloc] initWithFrames:sequenceData width:frameWidth height:frameHeight];
		[sequenceTmp setValue:[tmp autorelease] forKey:key];
	}
	sequences = [sequenceTmp retain];
	
	return self;
}

- (int)getFrameCount:(NSString *)sequence {
	return ((AnimationSequence *)[sequences valueForKey:sequence])->frameCount;
}

- (AnimationSequence *)get:(NSString *)sequence {
	return (AnimationSequence *)[sequences valueForKey:sequence];
}

- (NSString *)firstSequence {
	return [[sequences allKeys] objectAtIndex:0];
}

- (void)drawAtPoint:(CGPoint)point withSequence:(NSString *)sequence withFrame:(int)frame {
	AnimationSequence *seq = [sequences valueForKey:sequence];
	CGRect currFrame = seq->frames[frame];
	[[gResManager getTexture:image]
	 drawInRect:CGRectMake(
						   point.x + (seq->flipped ? currFrame.size.width : 0), 
						   point.y - anchor.y, 
						   seq->flipped ? -currFrame.size.width : currFrame.size.width,
						   currFrame.size.height)
	 withClip:currFrame
	 withRotation:0];
}

- (void)dealloc {
	[sequences removeAllObjects];
	[sequences release];
	[super dealloc];
}

@end

