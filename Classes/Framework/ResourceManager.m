//
//  ResourceManager.m
//  DCrawler
//
//  Created by Amudi Sebastian on 3/13/10.
//  Copyright 2010 amudi.org. All rights reserved.
//

#import "ResourceManager.h"
#import "GLESGameState.h"
#import "SoundEngine.h"

ResourceManager *gResManager;

@implementation ResourceManager

// initialize is called automatically before the class gets any other message
+ (void)initialize {
	static BOOL initialized = NO;
	if (!initialized) {
		gResManager = [[ResourceManager alloc] init];
		initialized = YES;
	}
}

+ (ResourceManager *)instance {
	return (gResManager);
}

- (ResourceManager *)init {
	[super init];
	textures = [[NSMutableDictionary dictionary] retain];
	sounds = [[NSMutableDictionary dictionary] retain];
	[self setupSound];
	
	storagePath = [[ResourceManager appendStorePath:STORAGE_FILENAME] retain];
	storageDirty = NO;
	storage = [[NSMutableDictionary alloc] init];
	[storage setDictionary:[NSDictionary dictionaryWithContentsOfFile:storagePath]];
	if (storage == nil) {
		NSLog(@"creating empty storage");
		storage = [[NSMutableDictionary alloc] init];
		storageDirty = YES;
	}
	
	return self;
}

- (void)shutdown {
	[self purgeSounds];
	[self purgeTextures];
	if (DEBUG_SOUND_ENABLED) {
		SoundEngine_Teardown();
	}
	if (storageDirty) {
		[storage writeToFile:storagePath atomically:YES];
	}
	[storagePath release];
	[storage release];
	[defaultFont release];
}

#pragma mark image cache

// creates and returns texture for the given image file. The texture is buffered,
// so the first call to getTexture will create the texture, and subsequent calls will
// simply return the same texture object
// TODO: catch allocation failures here, purge enough texture to make it work, retry loading the texture
- (GLTexture *)getTexture:(NSString *)filename {
	// lookup is .00001 (seconds) to .00003 on simulator, and consistently .00003 on device. Tested average over 1000 cycles, compared against using a local cache (e.g. not calling gettexture).
	// If you are drawing over a thousand instances per frame, you should use a local cache.
	GLTexture *retval = [textures valueForKey:filename];
	if (retval != nil) {
		return retval;
	}
	
	// load time seems to correlate with image complexity with png files.
	// Images loaded later in the app were quicker as well. Ranged 0.075 to 0.288 in test app
	NSString *fullPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	UIImage *loadImage = [UIImage imageWithContentsOfFile:fullPath];
	retval = [[GLTexture alloc] initWithImage:loadImage];
	[textures setValue:[retval autorelease] forKey:filename];
	return retval;
}

- (void)purgeTextures {
	[textures removeAllObjects];
}

#pragma mark sound code

// load and buffer sound, file should preferably in core-audio format (.caf)
// TODO: test
- (UInt32)getSound:(NSString *)filename {
	NSNumber *retval = [sounds valueForKey:filename];
	if (retval != nil) {
		return [retval intValue];
	}
	
	NSString *fullPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	UInt32 loadedSound;
	SoundEngine_LoadEffect([fullPath UTF8String], &loadedSound);
	[sounds setValue:[NSNumber numberWithInt:loadedSound] forKey:filename];
	NSLog(@"loaded sound:%@", filename);
	return loadedSound;
}

- (void)purgeSounds {
	NSEnumerator *e = [sounds objectEnumerator];
	NSNumber *snd;
	while (snd = [e nextObject]) {
		SoundEngine_UnloadEffect([snd intValue]);
	}
	[sounds removeAllObjects];
}

// play specified file, loaded and buffered as necessary
- (void)playSound:(NSString *)filename {
	if (DEBUG_SOUND_ENABLED) {
		SoundEngine_StartEffect([self getSound:filename]);
	}
}

// works with mp3, caf, wav
- (void)playMusic:(NSString *)filename {
	NSString *fullPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	SoundEngine_StopBackgroundMusic(FALSE);
	SoundEngine_UnloadBackgroundMusicTrack();
	SoundEngine_LoadBackgroundMusicTrack([fullPath UTF8String], false, false);
	SoundEngine_StartBackgroundMusic();
}

- (void)stopMusic {
	SoundEngine_StopBackgroundMusic(FALSE);
	SoundEngine_UnloadBackgroundMusicTrack();
}

- (void)setupSound {
	if (DEBUG_SOUND_ENABLED) {
		SoundEngine_Initialize(44100);
		SoundEngine_SetListenerPosition(0.0, 0.0, 1.0);
	}
}

#pragma mark data storage

// For loading data files from application bundle. Should retain and release return value
- (NSData *)getBundledData:(NSString *)filename {
	NSString *fullPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:filename];
	NSData *data = [NSData dataWithContentsOfFile:fullPath];
	return data;
}

// For saving preferences or other game data, stored in the documents directory and may persist between app version updates
- (BOOL)storeUserData:(id)data toFile:(NSString *)filename {
	[[NSUserDefaults standardUserDefaults] setObject:data forKey:filename];
	return YES;
}

// For loading prefs or other data saved with storeUserData
- (id)getUserData:(NSString *)filename {
	return [[NSUserDefaults standardUserDefaults] objectForKey:filename];
}

- (BOOL)userDataExists:(NSString *)filename {
	return [self getUserData:filename] != nil;
}

#pragma mark default font helper

- (GLFont *)defaultFont {
	if (defaultFont == nil) {
		defaultFont = [[GLFont alloc] initWithString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ,.?!@/: "
			fontName:@"Helvetica"
			fontSize:12.0f
			strokeWidth:1.0f
			fillColor:[UIColor blackColor]
			strokeColor:[UIColor blackColor]];
	}
	return defaultFont;
}

- (void)setDefaultFont:(GLFont *)newValue {
	[defaultFont autorelease];
	defaultFont = [newValue retain];
}

#pragma mark unsupported features and generally abusive functions

+ (NSString *)appendStorePath:(NSString *)filename {
	// find the user's document directory
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	// there should be only one directory returned
	NSString *documentsDirectory = [paths objectAtIndex:0];
	// make full path name
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:filename];
	return filePath;
}

+ (void)scrapeData {
	NSDictionary *datas = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
	NSArray *keys = [datas allKeys];
	for (int i = 0; i < keys.count; ++i) {
		NSLog(@"key %@ val %@", [keys objectAtIndex:i], [datas objectForKey:[keys objectAtIndex:i]]);
	}
}

@end
