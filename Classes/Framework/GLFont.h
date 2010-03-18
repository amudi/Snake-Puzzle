//
//  GLFont.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GLTexture.h"

typedef struct {
	unichar character;
	GLfloat tx, ty, tx2, ty2;	// texture position and height
	GLfloat pw, ph;	// width and height in pixel
} Glyph;

@interface GLFont : GLTexture {
	int fontdataLength;
	Glyph *fontData;
	GLfloat charSpacing;	// extra spacing between letters, typically negative
}

- (id)initWithString:(NSString *)string fontName:(NSString *)name fontSize:(CGFloat)size;
- (id)initWithString:(NSString *)string fontName:(NSString *)name fontSize:(CGFloat)size strokeWidth:(CGFloat)strokeWidth fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor;

- (void)drawString:(NSString *)string atPoint:(CGPoint)point;

@end
