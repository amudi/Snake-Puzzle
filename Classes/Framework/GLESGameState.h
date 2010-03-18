//
//  GLESGameState.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameState.h"

@interface GLESGameState : GameState {
	int endGameState;
	BOOL landscape;
@private
	float endGameCompleteTime;
}

@property (nonatomic, assign) BOOL landscape;

+ (void)setup2D;

- (id)initWithFrame:(CGRect)frame andManager:(GameStateManager *)pManager;

- (void)startDraw;
- (void)swapBuffers;
- (BOOL)bindLayer;

- (CGPoint)touchPosition:(UITouch *)touch;

- (void)updateEndGame:(float)time;
- (void)touchEndGame;

@end
