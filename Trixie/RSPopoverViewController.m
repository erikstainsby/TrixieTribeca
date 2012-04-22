//
//  RSPopoverViewController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSPopoverViewController.h"
#import "RSLocatorView.h"

@interface RSPopoverViewController ()

@end

@implementation RSPopoverViewController


@synthesize popover;

- (void) awakeFromNib {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popoverRequested:) name:RSPopoverRequestedNotification object:nil];
}

- (void) popoverRequested:(NSNotification*)nota {
	
	id sender = [nota object];
	id locator = nil;
	
	NSLog(@"%s- [%04d] requested by: %@", __PRETTY_FUNCTION__, __LINE__, [sender className]);
	
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
		
	[popover showRelativeToRect:[locator bounds] ofView:locator preferredEdge:NSMaxXEdge];
}

@end
