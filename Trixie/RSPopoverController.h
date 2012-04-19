//
//  RSPopoverController.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RSLocatorView.h"

@interface RSPopoverController : NSViewController < NSPopoverDelegate >

@property (retain) IBOutlet NSPopover * popover;
@property (retain) IBOutlet NSTextField * textField;

- (void) popoverRequested:(NSNotification*)nota;


@end
