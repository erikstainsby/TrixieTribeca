//
//  RSPopoverViewController.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RSLocatorView.h"
#import <RSTrixiePlugin/RSTrixie.h>
#import "NSView+RSPositionView.h"

@interface RSPopoverViewController : NSViewController


@property (retain) IBOutlet NSTextField * contextNote;
@property (assign) IBOutlet id locator;
@property (retain) IBOutlet NSPopover * popover;
@property (retain) IBOutlet NSBox * popoverHeader;
@property (retain) IBOutlet NSTextField * popoverTitle;

@property (retain) NSArray * actionPlugins;
@property (retain) NSArray * reactionPlugins;
@property (retain) NSArray * filterPlugins;

@property (retain) IBOutlet NSPopUpButton * actionMenu;
@property (retain) IBOutlet NSPopUpButton * reactionMenu;
@property (retain) IBOutlet NSPopUpButton * filterMenu;

@property (retain) IBOutlet NSButton * actionHelp;
@property (retain) IBOutlet NSButton * reactionHelp;
@property (retain) IBOutlet NSButton * filterHelp;

@property (retain) RSActionPlugin * activeActionPlugin;
@property (retain) RSReactionPlugin * activeReactionPlugin;
@property (retain) RSConditionPlugin * activeFilterPlugin; 

@property (retain) IBOutlet NSView * actionPanel;
@property (retain) IBOutlet NSView * reactionPanel;
@property (retain) IBOutlet NSView * filterPanel;

@property (retain) IBOutlet id currentPlugin;
@property (retain) IBOutlet id currentPanel;

@property (retain) IBOutlet NSBox * placeholderBox;
@property (assign) NSInteger activePanelWidth;
@property (assign) NSInteger activePanelHeight;



- (IBAction)	showActionPlugin:(id)sender;
- (IBAction)	showFilterPlugin:(id)sender;
- (IBAction)	showReactionPlugin:(id)sender;

- (void) popoverRequested:(NSNotification*)nota;
- (void) performClose:(id)sender;

@end
