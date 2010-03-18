//
//  Snakeboard.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/17/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "Snakeboard.h"
#import "ResourceManager.h"
#import "Entity.h"
#import "SnakeTileWorld.h"
#import "Sprite.h"
#import "Animation.h"
#import "Snake.h"
#import "Snake_PuzzleAppDelegate.h"


@implementation Snakeboard

- (void)setupWorld {
	tileWorld = [[SnakeTileWorld alloc] initWithFrame:self.frame];
	[tileWorld setLandscape:landscape];
	[tileWorld loadLevel:@"Snakeboard.txt" withTiles:@"Snakeboard_tiles.png"];
//	Animation *playerAnimation = [[Animation alloc] initWithAnim:@"player_walk.png"];
	//player = [[Snake alloc] initWithPos:CGPointMake(100, 100) sprite:[Sprite spriteWithAnimation:nil]];
	
	//[tileWorld addEntity:player];
	[tileWorld setCamera:CGPointMake(100, 100)];
	
//	[playerAnimation autorelease];
	[gResManager stopMusic];
	[gResManager playMusic:@"trimsqueak.mp3"];
}

- (void)Update {
	float time = LOOP_TIMER_MINIMUM;
	//[player update:time];
	[tileWorld setCamera:[[[player positions] objectAtIndex:0] CGPointValue]];
	
	[super updateEndGame:time];
}

- (void)Render {
	glClearColor(0xff/256.0f, 0x66/256.0f, 0x00/256.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[tileWorld draw];
	
	[self swapBuffers];
}

- (id)initWithFrame:(CGRect)frame andManager:(GameStateManager *)pManager{
	if (self = [super initWithFrame:frame andManager:pManager]) {
		[self setupWorld];
	}
	return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	[player moveToPosition:[tileWorld worldPosition:[self touchPosition:touch]]];
	[super touchEndGame];
}

- (void)dealloc {
	[tileWorld release];
	[player release];
	[super dealloc];
}

@end
