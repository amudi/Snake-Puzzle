//
//  pointmath.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/14/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef struct PolarCoord {
	float theta;
	float magnitude;
} PolarCoord;

CGPoint add (CGPoint a, CGPoint b);
CGPoint sub (CGPoint a, CGPoint b);
CGPoint scale(CGPoint a, float mag);
CGPoint clamp(CGPoint a, float magsquared);
CGFloat distsquared(CGPoint a, CGPoint b);
//returns a unit vector pointing from a to b.
CGPoint toward(CGPoint a, CGPoint b);
CGPoint unit(CGPoint a);
PolarCoord PolarCoordFromPoint(CGPoint a);
CGPoint PointFromPolarCoord(PolarCoord p);
float thetaToward(float a, float b, float step);

CG_INLINE PolarCoord
PolarCoordMake(CGFloat theta, CGFloat magnitude)
{
    PolarCoord p; p.theta = theta; p.magnitude = magnitude; return p;
}

float min(float a, float b);
float sign(float a);

//clockwise from straight up, in opengl coords.
int cheapsin[4];// = { 1, 0, -1, 0 };
int cheapcos[4];// = { 0, -1, 0, 1 };
