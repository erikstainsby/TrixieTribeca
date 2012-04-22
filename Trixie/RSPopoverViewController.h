//
//  RSPopoverViewController.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RSLocatorView.h"

@interface RSPopoverViewController : NSViewController

@property (retain) IBOutlet NSTextField * contextNote;
@property (assign) IBOutlet id locator;
@property (retain) IBOutlet NSPopover * popover;

@end
