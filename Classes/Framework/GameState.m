//
//  GameState.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "GameState.h"


@implementation GameState


- (id)initWithFrame:(CGRect)frame andManager:(GameStateManager *)pManager {
    if (pManager != nil) {
		if ((self = [super initWithFrame:frame])) {
			// Initialization code
			m_pManager = pManager;
			self.userInteractionEnabled = true;
		}
	}
    return self;
}

- (void)Update {
	
}

- (void)Render {
	
}

- (void)drawRect:(CGRect)rect {

}


- (void)dealloc {
    [super dealloc];
}


@end
