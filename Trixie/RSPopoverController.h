//
//  RSPopoverController.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SFBPopovers/SFBPopoverWindow.h>
#import <SFBPopovers/SFBPopoverWindowController.h>
#import "RSLocatorView.h"

@interface RSPopoverController : NSViewController
{
	SFBPopoverWindowController * _popoverController;
}

@property (retain) IBOutlet NSColor * borderColor;
@property (retain) IBOutlet NSColor * popoverBackgroundColor;
@property (retain) IBOutlet SFBPopoverWindow * popoverWindow;
@property (assign) IBOutlet NSWindow * window;

@property (retain) IBOutlet RSLocatorView * locatorView;
@property (retain) IBOutlet NSView * currentPanel;
@property (retain) IBOutlet RSTrixiePlugin * currentPlugin;

@property (retain) IBOutlet RSActionPlugin * actionPlugin;
@property (retain) IBOutlet RSFilterPlugin * filterPlugin;
@property (retain) IBOutlet RSReactionPlugin * reactionPlugin;

@property (retain) IBOutlet NSView * actionPanel;
@property (retain) IBOutlet NSView * filterPanel;
@property (retain) IBOutlet NSView * reactionPanel;


- (void) showPopover:(NSNotification*)nota;

@end
