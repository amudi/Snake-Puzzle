//
//  SPPoint.h
//  Snake Puzzle
//
//  Created by Amudi Sebastian on 3/19/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct SPPoint {
	unsigned int x;
	unsigned int y;
} SPPoint;

CG_INLINE SPPoint
SPPointMake(unsigned int x, unsigned int y)
{
	SPPoint p; p.x = x; p.y = y; return p;
}