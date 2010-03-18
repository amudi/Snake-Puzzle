//
//  Tile.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	UNWALKABLE = 1,
	WATER = 2,
	EMUTEARS = 4,
} PhysicsFlags;

@interface Tile : NSObject {
@public
	PhysicsFlags flags;
	NSString *textureName;
	CGRect frame;
}

@property (nonatomic, retain) NSString *textureName;
@property (nonatomic) CGRect frame;

- (void)drawInRect:(CGRect)rect;
- (Tile *)initWithTexture:(NSString *)texture withFrame:(CGRect)_frame;

@end
