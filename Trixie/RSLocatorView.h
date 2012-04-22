//
//  RSLocatorView.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "RSWebView.h"

@interface RSLocatorView : NSView

@property (retain) IBOutlet DOMElement * node;
@property (retain) IBOutlet NSButton * locatorButton;
@property (assign) NSInteger tag;
@property (assign) NSTrackingRectTag trackingRectTag;


- (IBAction) requestPopover:(id)sender;
- (id)		 representedObject;
- (BOOL)	 acceptsFirstResponder;
- (void)	 updateTrackingAreas;

@end
