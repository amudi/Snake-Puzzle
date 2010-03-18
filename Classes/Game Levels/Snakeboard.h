//
//  Snakeboard.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/17/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLESGameState.h"

@class SnakeTileWorld;
@class Snake;

@interface Snakeboard : GLESGameState {
	SnakeTileWorld *tileWorld;
	Snake *player;
}

@property (nonatomic, readonly) int boardHeight;
@property (nonatomic, readonly) int boardWidth;

@end
