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
#import "Consumable.h"

@implementation Snakeboard

@dynamic boardHeight;
@dynamic boardWidth;

- (void)setupWorld {
	tileWorld = [[SnakeTileWorld alloc] initWithFrame:self.frame];
	[tileWorld setLandscape:landscape];
	[tileWorld loadLevel:@"Snakeboard.txt" withTiles:@"Snakeboard.png"];
	
	player = [[Snake alloc] initWithPos:CGPointMake(5.0f, 5.0f) length:3];
	[tileWorld setSnake:player];
	
	Animation *anim = [[Animation alloc] initWithAnim:@"Blue_gem.png"];
	Consumable *consumable1 = [[Consumable alloc] initWithPos:CGPointMake(0.0f, 0.0f) sprite:[Sprite spriteWithAnimation:anim]];
	Consumable *consumable2 = [[Consumable alloc] initWithPos:CGPointMake(14.0f, 0.0f) sprite:[Sprite spriteWithAnimation:anim]];
	Consumable *consumable3 = [[Consumable alloc] initWithPos:CGPointMake(14.0f, 9.0f) sprite:[Sprite spriteWithAnimation:anim]];
	Consumable *consumable4 = [[Consumable alloc] initWithPos:CGPointMake(0.0f, 9.0f) sprite:[Sprite spriteWithAnimation:anim]];
	[anim autorelease];
	[tileWorld addEntity:consumable1];
	[tileWorld addEntity:consumable2];
	[tileWorld addEntity:consumable3];
	[tileWorld addEntity:consumable4];
	
	[gResManager stopMusic];
	[gResManager playMusic:@"trimsqueak.mp3"];
}

- (void)Update {
	float time = LOOP_TIMER_MINIMUM;
	
	//[tileWorld setCamera:[[[player positions] objectAtIndex:0] CGPointValue]];
	[player update:time];
	
	[super updateEndGame:time];
}

- (void)Render {
	glClearColor(0xff/256.0f, 0x66/256.0f, 0x00/256.0f, 1.0f);
	glClear(GL_COLOR_BUFFER_BIT);
	
	[tileWorld draw];
	
	int fps = [((Snake_PuzzleAppDelegate *)m_pManager) getFramesPerSecond];
	NSString *fpsStr = [NSString stringWithFormat:@"%d", fps];
	[[gResManager defaultFont] drawString:fpsStr atPoint:CGPointMake(450.0f, 300.0f)];
	
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
	
	if ([player dying]) {
		[player forceToPos:CGPointMake(5.0f, 5.0f)];
		[player setSpeed:10.0f];
		[player setDying:NO];
		[player setDirection:DIRECTION_EAST];
	} else {
		// check whether player touch left button or right button
		CGPoint touchPos = [tileWorld worldPosition:[self touchPosition:touch]];
		if (touchPos.x <= [tileWorld worldWidth] / 2) {
			[player turnLeft];
		} else {
			[player turnRight];
		}
	}
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
