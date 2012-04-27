//
//  RSAppDelegate.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-10.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <RSTrixieFramework/RSTrixie.h>
#import "RSTrixieController.h"

@interface RSAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (retain) IBOutlet RSTrixieController * windowController;

@end
