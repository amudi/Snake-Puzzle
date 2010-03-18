//
//  Rideable.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Rideable : Entity {
	CGRect bounds;
	Entity *mRider;
	int sunkFrame;
}

- (BOOL)under:(CGPoint)point;
- (void)markRidden:(Entity *)rider;

@end
