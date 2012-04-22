//
//  RSLocatorView.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSLocatorView.h"

@implementation RSLocatorView

@class RSWebView;

@synthesize node;
@synthesize locatorButton;
@synthesize tag = _tag;
@synthesize trackingRectTag;

- (id)		initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        trackingRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
		[[self locatorButton] setTarget:self];
		[[self locatorButton] setAction:@selector(requestPopover:)];
    }
    return self;
}

- (void)	awakeFromNib {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[[self.menu itemWithTitle:@"Edit"] setRepresentedObject:self];
	[[self.menu itemWithTitle:@"Delete"] setRepresentedObject:self];
}

- (IBAction) requestPopover:(id)sender {
	[[NSNotificationCenter defaultCenter] postNotificationName:RSPopoverRequestedNotification object:sender];
}

- (id)		representedObject {
	return self;
}

- (void)	mouseEntered:(NSEvent *)theEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName:RSMouseEnteredLocatorNotification object:self];
}

- (void)	mouseExited:(NSEvent *)theEvent {
	[[NSNotificationCenter defaultCenter] postNotificationName:RSMouseExitedLocatorNotification object:self];
}

- (void)	updateTrackingAreas {
	[self removeTrackingRect:trackingRectTag];
	trackingRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

- (BOOL)	acceptsFirstResponder {
	return YES;
}

- (void)	drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
}

- (void)	dealloc {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[[NSNotificationCenter defaultCenter] postNotificationName:RSMouseExitedLocatorNotification object:self];
	[self removeTrackingRect:trackingRectTag];
}

@end
