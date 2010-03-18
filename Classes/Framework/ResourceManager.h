//
//  ResourceManager.h
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGLDrawable.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import "GLTexture.h"
#import "GLFont.h"

@class GLESGameState;
@class ResourceManager;

extern ResourceManager *gResManager;

@interface ResourceManager : NSObject {
	// used to allocate and manage GLTexture instances, needs to be cleared in dealloc
	NSMutableDictionary *textures;
	
	// used to track sound allocations. The actual sound data is buffered in SoundEngine; 'sounds' here only tracks openAL ids of loaded sounds
	NSMutableDictionary *sounds;
	
	NSMutableDictionary *storage;
	BOOL storageDirty;
	NSString *storagePath;
	
	GLFont *defaultFont;
}

+ (ResourceManager *)instance;

- (void)shutdown;

// loads amd buffers images and 2d opengles textures
- (GLTexture *)getTexture:(NSString *)filename;
- (void)purgeTextures;

- (void)setupSound;	// initialize sound device, should be called during initialization
- (UInt32)getSound:(NSString *)filename;	// useful for preloading sounds, called automatically by playSound
- (void)purgeSounds;
- (void)playSound:(NSString *)filename;	// play a sound, load and buffer sound if needed
- (void)playMusic:(NSString *)filename;	// play and loop a  music file in the background
- (void)stopMusic;	// stop the music, unload currently playing music file

// useful for loading binary files that included in the program bundle
- (NSData *)getBundledData:(NSString *)filename;

// for saving preferences, may bersist between app version updates
- (BOOL)storeUserData:(id)data toFile:(NSString *)filename;
// for loading user prefs or other data saved with storeData, returns nil if file does not exist
- (id)getUserData:(NSString *)filename;
- (BOOL)userDataExists:(NSString *)filename;
+ (NSString *)appendStorePath:(NSString *)filename;

- (GLFont *)defaultFont;
- (void)setDefaultFont:(GLFont *)newValue;

@end
