//
//  Entity.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sprite;
@class SnakeTileWorld;

@interface Entity : NSObject {
	CGPoint worldPos;	// specifies origin for physical representation in the game world. in pixels
	Sprite *sprite;
	SnakeTileWorld  *world;	// set when entity added to a TileWorld. used for tile collision detection
}

@property (nonatomic, retain) Sprite *sprite;
@property (nonatomic) CGPoint position;

- (id)initWithPos:(CGPoint)pos sprite:(Sprite *)spr;
- (void)drawAtPoint:(CGPoint)offset;
- (void)update:(CGFloat)time;
- (void)setWorld:(SnakeTileWorld *)newWorld;
- (void)forceToPos:(CGPoint)pos;

@end
