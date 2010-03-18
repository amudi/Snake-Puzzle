//
//  GLESGameState.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "GLESGameState.h"
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>
#import "ResourceManager.h"

// primary context for all opengl calls. set in setup2D, should be cleared in teardown
EAGLContext *glesContext;

// there is a white flash when changing between two GLESGameStates
GLuint glesFrameBuffer;
GLuint glesRenderBuffer;
CGSize _size;

@implementation GLESGameState

@synthesize landscape;

+ (Class)layerClass {
	return [CAEAGLLayer class];
}

+ (void)initialize {
	static BOOL initialized = NO;
	if (!initialized) {
		[GLESGameState setup2D];
		initialized = YES;
	}
}

// initialize opengles, setup camera for 2d rendering
+ (void)setup2D {
	// create and set the gles context
	glesContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	[EAGLContext setCurrentContext:glesContext];
	
	glGenRenderbuffersOES(1, &glesRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, glesRenderBuffer);
	
	glGenFramebuffersOES(1, &glesFrameBuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, glesFrameBuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, glesRenderBuffer);
	
	// initialize OpenGL states
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);	// most 2d games will want alpha-blending on by default
	glEnable(GL_TEXTURE_2D);
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	
	CGSize newSize;
	
	// TODO: this was originally done in bindToState, since that is where we would get sizing info.
	newSize = CGSizeMake(IPHONE_WIDTH, IPHONE_HEIGHT);	
	newSize.width = roundf(newSize.width);
	newSize.height = roundf(newSize.height);
	
	NSLog(@"dimension %f x %f", newSize.width, newSize.height);
	
	_size = newSize;
	glViewport(0, 0, newSize.width, newSize.height);
	glScissor(0, 0, newSize.width, newSize.height);
	
	// setup OpenGL projection matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	glOrthof(0, _size.width, 0, _size.height, -1, 1);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// landscape
	float w = _size.width / 2;
	float h = _size.height / 2;
	glPushMatrix();
	glTranslatef(w,h,0);
	glRotatef(-90,0,0,1);
	glTranslatef(-h,-w,0);
}

// set opengl context's output to the underlying gl layer of this gamestate
// should be called during the counstruction of any state that wants to do opengl rendering
- (BOOL)bindLayer {
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)[self layer];
	
	NSLog(@"layer %@", eaglLayer);
	
	// set up a few drawing properties
	// TODO: benchmark this
	[eaglLayer setDrawableProperties:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGB565, kEAGLDrawablePropertyColorFormat, nil]];
	
	if (![EAGLContext setCurrentContext:glesContext]) {
		return NO;
	}
	
	// disconnect any existing render storage.
	[glesContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:nil];
	
	// connect our renderbuffer to the eaglLayer's storage
	if (![glesContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:eaglLayer]) {
		glDeleteRenderbuffersOES(1, &glesRenderBuffer);	// probably should exit the app here
		return NO;
	}
	
	return YES;
}

- (void)startDraw {
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, glesRenderBuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, glesFrameBuffer);
}

// finish opengl calls and send the results to the screen
// should be called to end the rendering of a frame
- (void)swapBuffers {
	EAGLContext *oldContext = [EAGLContext currentContext];
	GLuint oldRenderBuffer;
	
	if (oldContext != glesContext) {
		[EAGLContext setCurrentContext:glesContext];
	}
	
	glGetIntegerv(GL_RENDERBUFFER_BINDING_OES, (GLint *)&oldRenderBuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, glesRenderBuffer);
	
	//NSLog(@"oldrenderbuffer %d, renderbuffer %d", oldRenderBuffer, glesRenderBuffer);
	
	glFinish();
		
	if (![glesContext presentRenderbuffer:GL_RENDERBUFFER_OES]) {
		NSLog(@"failed to swap render buffer in %s", __FUNCTION__);
	}
}

- (void)teardown {
	[glesContext release];
}

- (id)initWithFrame:(CGRect)frame andManager:(GameStateManager *)pManager {
	if (self = [super initWithFrame:frame andManager:pManager]) {
		// Initialization code
		landscape = YES;
		[self bindLayer];
	}
	return self;
}

- (CGPoint)touchPosition:(UITouch *)touch {
	CGPoint point = [touch locationInView:self];
	point.y = self.frame.size.height - point.y;	// convert to opengl coordinates
	
	CGPoint point2 = CGPointMake(point.x, point.y);
	
	// landscape?
	if (landscape) {
		point2.x = self.frame.size.height - point.y;
		point2.y = point.x;
		//NSLog(@"touch original: (%f, %f), touch converted: (%f. %f)", point.x, point.y, point2.x, point2.y);
	}	
	return point2;
}

- (void)updateEndGame:(float)time {
	if (endGameState != 0) {
		endGameCompleteTime += time;
	}
}

- (void)touchEndGame {
	if (endGameCompleteTime > 2.0f) {
		[gResManager stopMusic];
		//[m_pManager doStateChange:[gsMainMenu class]];
	}
}

@end
