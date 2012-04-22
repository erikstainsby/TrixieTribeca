//
//  RSPopoverViewController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSPopoverViewController.h"

@interface RSPopoverViewController ()

@end


@implementation RSPopoverViewController

@synthesize contextNote;
@synthesize locator;
@synthesize popover;

- (void) awakeFromNib {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popoverRequested:) name:RSPopoverRequestedNotification object:nil];
}

- (void) popoverRequested:(NSNotification*)nota {
	
	id sender = [nota object];
	locator = nil;
	
	if( [sender respondsToSelector:@selector(representedObject)] ) {
		locator = [sender representedObject];
	}
	else if( [[sender className] isEqualToString:[RSLocatorView className]]) {
		locator = sender;
	}
	else {
		locator = [sender superview];
	}
	
	if( ! popover) {
		popover = [[NSPopover alloc] init];
		popover.contentViewController = self;
	}
	
	[contextNote setStringValue:[self nodeDetails]];
	
	[popover showRelativeToRect:[locator bounds] ofView:locator preferredEdge:NSMaxXEdge];
}

- (NSString*) nodeDetails {
	NSString * tagName = [[locator node] nodeName];
	NSString * idAttr = [[locator node] getAttribute:@"id"];
	NSString * classes = [[locator node] getAttribute:@"class"];
	return [NSString stringWithFormat:@"<%@ id=\"%@\" class=\"%@\">", tagName, idAttr, classes];
}

@end
