//
//  Snakeboard.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/17/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLESGameState.h"

@class TileWorld;
@class Snake;

@interface Snakeboard : GLESGameState {
	TileWorld *tileWorld;
	Snake *player;
}

@end
