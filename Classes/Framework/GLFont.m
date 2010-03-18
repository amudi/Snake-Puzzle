//
//  GLFont.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "GLFont.h"

@implementation GLFont

- (id)initWithString:(NSString *)string fontName:(NSString *)name fontSize:(CGFloat)size {
	return [self initWithString:string fontName:name fontSize:size
					strokeWidth:0.0f fillColor:[UIColor whiteColor] strokeColor:nil];
}

- (id)initWithString:(NSString *)string fontName:(NSString *)name fontSize:(CGFloat)size strokeWidth:(CGFloat)strokeWidth fillColor:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor {
	NSUInteger width;
	NSUInteger height;
	NSUInteger i;
	CGContextRef context;
	void *data;
	CGColorSpaceRef colorSpace;
	UIFont *font;
	CGSize dimensions;
	
	font = [UIFont fontWithName:name size:size];
	charSpacing = -strokeWidth - 1;	// since we pad the letters out, we need to consume some of that padding when rendering to screen
	
	Glyph *tFontData = malloc(sizeof(Glyph) * [string length]);
	
	float length = 0.0f;
	for (int i = 0; i < [string length]; ++i) {
		CGSize size = [[string substringWithRange:NSMakeRange(i, 1)] sizeWithFont:font];
		size.width += strokeWidth * 2 + 1;	// this should only be +strokewidth, but we get some overlap on character sequences like "kl" with a large strokewidth. so it's +strokewidth*2
		size.height += strokeWidth;
		length += size.width;
		dimensions.height = size.height;
		tFontData[i].character = [string characterAtIndex:i];
		tFontData[i].pw = size.width;
		tFontData[i].ph = size.height;
	}
	dimensions.width = length;
	
	// expand to power-of-two dimension, should probably check for absurdly large widths here
	width = dimensions.width;
	if ((width != 1) && (width & (width - 1))) {
		i = 1;
		while (i < width) {
			i *= 2;
		}
		width = i;
	}
	height = dimensions.height;
	if ((height != 1) && (height & (height - 1))) {
		i = 1;
		while (i < height) {
			i *= 2;
		}
		height = i;
	}
	
	NSLog(@"allocating font texture, dimensions %dx%d", width, height);
	
	colorSpace = CGColorSpaceCreateDeviceRGB();
	data = malloc(height * width * 4);
	context = CGBitmapContextCreate(data, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
	CGColorSpaceRelease(colorSpace);
	
	CGContextSetFillColorWithColor(context, [fillColor CGColor]);
	CGTextDrawingMode drawingMode;
	if (strokeWidth == 0.0f) {
		drawingMode = kCGTextFill;
	} else {
		CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
		CGContextSetLineWidth(context, strokeWidth);
		drawingMode = kCGTextFillStroke;
	}
	CGContextTranslateCTM(context, 0.0, height);
	CGContextScaleCTM(context, 1.0, -1.0);	//NOTE: NSString draws in UIKit referential i.e. renders upside-down compared to CGBitmapContext referential
	UIGraphicsPushContext(context);
	CGContextSetTextDrawingMode(context, drawingMode);
	length = 0.0f;
	for (int i = 0; i < [string length]; ++i) {
		CGSize size = CGSizeMake(tFontData[i].pw, tFontData[i].ph);
		[[string substringWithRange:NSMakeRange(i, 1)]
		 drawInRect:CGRectMake(length, 0.0f, size.width, size.height) 
		 withFont:font
		 lineBreakMode:UILineBreakModeClip
		 alignment:UITextAlignmentCenter
		];
		length += size.width;
	}
	UIGraphicsPopContext();
	
	self = [self initWithData:data pixelFormat:kGLTexturePixelFormat_RGBA8888 pixelsWide:width pixelsHigh:height contentSize:dimensions];
	
	CGContextRelease(context);
	free(data);
	
	length = 0.0f;
	for (int i = 0; i < [string length]; ++i) {
		tFontData[i].ty = 0;
		tFontData[i].tx = length;
		tFontData[i].ty2 = self.maxT;
		tFontData[i].tx2 = length + tFontData[i].pw / self.pixelsWide;
		length = tFontData[i].tx2;
	}
	
	if (fontData) {
		free(fontData);	// just in case initWithString gets called more than once
	}
	fontData = tFontData;
	fontdataLength = [string length];
	
	return self;
	
}

// draws align bottom-left, like opengl coordinates
- (void)drawString:(NSString *)string atPoint:(CGPoint)point {
	if (fontData == NULL) return;
	glBindTexture(GL_TEXTURE_2D, self.name);
	
	GLfloat xoff = 0.0f;
	for (int j = 0; j < [string length]; ++j) {
		int index = -1;
		unichar ch = [string characterAtIndex:j];
		for (int i = 0; i < fontdataLength; ++i) {
			if (fontData[i].character == ch) {
				index = i;
				break;
			}
		}
		if (index == -1) {
			xoff += fontData[0].pw + charSpacing;	// insert spaces for character we don't know about
			continue;
		}
		Glyph g = fontData[index];
		// TODO: it should be faster if we put tex coordinates and vertices inside each Glyph, since they are constant after initialization
		GLfloat coordinates[] = {	g.tx,	g.ty2,
									g.tx2,	g.ty2,
									g.tx,	g.ty,
									g.tx2,	g.ty };
		GLfloat width = g.pw;
		GLfloat height = g.ph;
		GLfloat vertices[] = {	0,		0,		0.0,
								width,	0,		0.0,
								0,		height,	0.0,
								width,	height,	0.0 };
		
		glVertexPointer(3, GL_FLOAT, 0, vertices);
		glTexCoordPointer(2, GL_FLOAT, 0, coordinates);
		
		glPushMatrix();
		glTranslatef(point.x + xoff, point.y, 0);
		glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
		glPopMatrix();
		xoff += g.pw + charSpacing;
	}
}

- (void)dealloc {
	if (fontData) {
		free(fontData);
	}
	[super dealloc];
}

@end
