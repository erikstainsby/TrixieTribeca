//
//  RSWindow.m
//  RSTrixie
//
//  Created by Erik Stainsby on 12-03-13.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSWindow.h"

@implementation RSWindow

@synthesize mouseIsOverWebView;
@synthesize webview;

- (void) awakeFromNib {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMouseExitedWebView:) name:RSMouseEnteredLocatorNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toggleMouseEnteredWebView:) name:RSMouseExitedLocatorNotification object:nil];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}
- (BOOL) acceptsMouseMovedEvents {
	return YES;
}

- (void) mouseDown:(NSEvent *)theEvent {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}
- (void) mouseUp:(NSEvent *)theEvent {
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
}

- (void) mouseEntered:(NSEvent *)theEvent {
	[self setMouseIsOverWebView:YES];
}
- (void) mouseExited:(NSEvent *)theEvent {
	[self setMouseIsOverWebView:NO];
}
 
- (void) toggleMouseExitedWebView:(NSNotification*) note {
	[self setMouseIsOverWebView:NO];
}
- (void) toggleMouseEnteredWebView:(NSNotification*) note {
	[self setMouseIsOverWebView:YES];
}

- (IBAction) showEditorPopover:(id)sender {
	id locator = [sender representedObject];
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [locator tag]);
}

- (IBAction) removeLocator:(id)sender {
	
	[self setMouseIsOverWebView:YES];
	id locator = [sender representedObject];
	[locator removeFromSuperview];
	[webview removeBoundingBox];
}


- (void) sendEvent:(NSEvent *)theEvent {
	if([theEvent type] == NSLeftMouseDown && mouseIsOverWebView) {
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"WebView mouseDown");
		[[NSNotificationCenter defaultCenter] postNotificationName:RSWebViewLeftMouseDownEventNotification object:theEvent];
	}
	else if([theEvent type] == NSLeftMouseUp && mouseIsOverWebView) {
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"WebView mouseUp");
		[[NSNotificationCenter defaultCenter] postNotificationName:RSWebViewLeftMouseUpEventNotification object:theEvent];
	}
	else {
		[super sendEvent: theEvent];
	}
}

@end
