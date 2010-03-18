//
//  GameState.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>
#import "GameStateManager.h"


@interface GameState : UIView {
	GameStateManager *m_pManager;
}

- (id)initWithFrame:(CGRect)frame andManager:(GameStateManager *)pManager;
- (void)Render;
- (void)Update;

@end
