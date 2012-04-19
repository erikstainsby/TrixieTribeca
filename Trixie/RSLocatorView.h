//
//  RSLocatorView.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSLocatorView : NSView

@property (retain) IBOutlet NSButton * locatorButton;
@property (assign) NSInteger tag;
@property (assign) NSTrackingRectTag trackingRectTag;

- (BOOL) acceptsFirstResponder;
- (IBAction) requestPopover:(id)sender;

@end
