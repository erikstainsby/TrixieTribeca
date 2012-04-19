//
//  RSWindow.h
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-13.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import "RSWebView.h"

@interface RSWindow : NSWindow < NSPopoverDelegate >

@property (assign) BOOL mouseIsOverWebView;
@property (retain) IBOutlet RSWebView * webview;

- (BOOL) acceptsFirstResponder;
- (BOOL) acceptsMouseMovedEvents;

- (void) mouseDown:(NSEvent *)theEvent;
- (void) mouseUp:(NSEvent *)theEvent;

- (void) mouseEntered:(NSEvent *)theEvent;
- (void) mouseExited:(NSEvent *)theEvent;

- (void) sendEvent:(NSEvent *)theEvent;

#pragma mark - NSPopoverDelegate methods 

- (void) performClose:(id)sender;

@end
