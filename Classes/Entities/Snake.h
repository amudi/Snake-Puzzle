//
//  Snake.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/17/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TileWorld;

@interface Snake : NSObject {
	CGPoint destPos;
	NSInteger lastDirection;
	BOOL celebrating;
	BOOL dying;
	NSInteger speed;
	TileWorld *world;
@private
	NSString *headTextureName;
	NSString *tailTextureName;
	NSString *bodyTextureName;
	NSMutableArray *positions;	// top left coordinates of snake's blocks
	NSInteger bodyBlockSize;
}

@property (nonatomic) BOOL celebrating;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, retain) NSString *headTextureName;
@property (nonatomic, retain) NSString *tailTextureName;
@property (nonatomic, retain) NSString *bodyTextureName;
@property (nonatomic, assign) NSInteger bodyBlockSize;
@property (nonatomic, readonly) NSMutableArray *positions;

- (id)initWithPos:(CGPoint)pos length:(NSInteger)length;
- (void)moveToPosition:(CGPoint)point;
- (BOOL)doneMoving;
- (void)dieWithAnimation:(NSString *)deathAnim;
- (void)addBody;

- (void)drawAtPoint:(CGPoint)offset;
- (void)update:(CGFloat)time;
- (void)setWorld:(TileWorld *)newWorld;
- (void)forceToPos:(CGPoint)pos;

@end
