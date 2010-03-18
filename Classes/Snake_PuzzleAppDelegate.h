//
//  Snake_PuzzleAppDelegate.h
//  Snake Puzzle
//
//  Created by Amudi Sebastian on 3/18/10.
//  Copyright amudi.org 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResourceManager.h"
#import "GameStateManager.h"

@class Snake_PuzzleViewController;

@interface Snake_PuzzleAppDelegate : GameStateManager <UIApplicationDelegate> {
    UIWindow *window;
    Snake_PuzzleViewController *viewController;
	
	CFTimeInterval mFPSLastSecondStart;
	int mFPSFramesThisSecond;
	
	CFTimeInterval mLastUpdateTime;
	float mEstFramesPerSecond;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Snake_PuzzleViewController *viewController;

- (void)gameLoop:(id)sender;
- (float)getFramesPerSecond;
@end

