//
//  Animation.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationSequence : NSObject {
@public
	int frameCount;
	float *timeout;
	CGRect *frames;
	BOOL flipped;
	NSString *next;
}

- (AnimationSequence *)initWithFrames:(NSDictionary *)animData width:(float)width height:(float)height;

@end

@interface Animation : NSObject {
	NSString *image;
	NSMutableDictionary *sequences;
	CGPoint anchor;
}

- (Animation *)initWithAnim:(NSString *)img;
- (void)drawAtPoint:(CGPoint)point withSequence:(NSString *)sequence withFrame:(int)frame;
- (int)getFrameCount:(NSString *)sequence;
- (NSString *)firstSequence;
- (AnimationSequence *)get:(NSString *)sequence;

@end

