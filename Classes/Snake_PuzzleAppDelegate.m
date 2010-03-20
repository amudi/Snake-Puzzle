//
//  Snake_PuzzleAppDelegate.m
//  Snake Puzzle
//
//  Created by Amudi Sebastian on 3/18/10.
//  Copyright amudi.org 2010. All rights reserved.
//

#import "Snake_PuzzleAppDelegate.h"
#import "Snake_PuzzleViewController.h"

// include the state classes we might switch to
#import "Snakeboard.h"

@implementation Snake_PuzzleAppDelegate

@synthesize window;
@synthesize viewController;

- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // Override point for customization after app launch
    [ResourceManager initialize];
    
	// set up main loop
	[NSTimer scheduledTimerWithTimeInterval:LOOP_TIMER_MINIMUM target:self selector:@selector(gameLoop:) userInfo:nil repeats:NO];
	
	mLastUpdateTime = [[NSDate date] timeIntervalSince1970];
	mFPSLastSecondStart = mLastUpdateTime;
	mFPSFramesThisSecond = 0;
	
	[self doStateChange:[Snakeboard class]];
}

- (void) gameLoop:(id)sender {
	double currTime = [[NSDate date] timeIntervalSince1970];
	[((GameState *)viewController.view) Update];
	[((GameState *)viewController.view) Render];
	
	++mFPSFramesThisSecond;
	float timeThisSecond = currTime - mFPSLastSecondStart;
	if (timeThisSecond > 1.0f) {
		mEstFramesPerSecond = mFPSFramesThisSecond;
		mFPSFramesThisSecond = 0;
		mFPSLastSecondStart = currTime;
	}
	
	float sleepPeriod = LOOP_TIMER_MINIMUM;
	[NSTimer scheduledTimerWithTimeInterval:sleepPeriod target:self selector:@selector(gameLoop:) userInfo:nil repeats:NO];
	mLastUpdateTime = currTime;
}

- (float)getFramesPerSecond {
	return mEstFramesPerSecond;
}

- (void)doStateChange:(Class)state {
	BOOL animateTransition = YES;
	if (animateTransition) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.5];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:window cache:YES];
	}
	
	if (viewController.view != nil) {
		[viewController.view removeFromSuperview];
		[viewController.view release];
	}
	
	viewController.view = [[state alloc] initWithFrame:CGRectMake(0, 0, IPHONE_WIDTH, IPHONE_HEIGHT) andManager:self];
	
	[window addSubview:viewController.view];
	[window makeKeyAndVisible];
	
	if (animateTransition) {
		[UIView commitAnimations];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	DLog(@"appdelegate release");
	[gResManager shutdown];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	DLog(@"low memory, purging cache");
	[gResManager purgeSounds];
	[gResManager purgeTextures];
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
