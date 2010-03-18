//
//  Tile.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Tile.h"
#import "Sprite.h"
#import "ResourceManager.h"

@implementation Tile

@synthesize textureName;
@synthesize frame;

- (Tile *)init {
	[super init];
	flags = UNWALKABLE;
	return self;
}

- (Tile *)initWithTexture:(NSString *)texture withFrame:(CGRect)_frame {
	[self init];
	self.textureName = texture;
	self.frame = _frame;
	return self;
}

- (void)drawInRect:(CGRect)rect {
	[[gResManager getTexture:textureName] drawInRect:rect withClip:frame withRotation:0];
}

- (void)dealloc {
	[super dealloc];
}

@end
