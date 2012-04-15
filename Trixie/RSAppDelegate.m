//
//  RSAppDelegate.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-10.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSAppDelegate.h"

@implementation RSAppDelegate

@synthesize window = _window;
@synthesize windowController;

- (id)init {
	if(nil!=(self=[super init]))
	{
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		
		windowController = [[RSTrixieController alloc] init];
		[[windowController window] orderFront:self];
	}
	return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
	return YES;
}

@end
