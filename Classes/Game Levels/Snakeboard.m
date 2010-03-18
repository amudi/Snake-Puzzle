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

@dynamic boardHeight;
@dynamic boardWidth;

- (void)setupWorld {
	tileWorld = [[SnakeTileWorld alloc] initWithFrame:self.frame];
	[tileWorld setLandscape:landscape];
	[tileWorld loadLevel:@"Snakeboard.txt" withTiles:@"Snakeboard_tiles.png"];
	
	[tileWorld setCamera:CGPointMake(100, 100)];
	
	//[gResManager stopMusic];
	//[gResManager playMusic:@"trimsqueak.mp3"];
}

- (void)Update {
	float time = LOOP_TIMER_MINIMUM;
	
	//[tileWorld setCamera:[[[player positions] objectAtIndex:0] CGPointValue]];
	
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
	//UITouch *touch = [touches anyObject];
	
	// check whether player touch left button or right button
	//[player moveToPosition:[tileWorld worldPosition:[self touchPosition:touch]]];
	[super touchEndGame];
}

- (int)getBoardHeight {
	return [tileWorld worldHeight];
}

- (int)getBoardWidth {
	return [tileWorld worldWidth];
}

- (void)dealloc {
	[tileWorld release];
	[player release];
	[super dealloc];
}

@end
