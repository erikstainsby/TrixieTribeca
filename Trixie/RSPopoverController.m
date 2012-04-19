//
//  RSPopoverController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSPopoverController.h"

@interface RSPopoverController ()

@end

@implementation RSPopoverController

@synthesize textField;
@synthesize popover;

- (void) awakeFromNib {	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popoverRequested:) name:RSPopoverRequestedNotification object:nil];
}


- (void) popoverRequested:(NSNotification *)nota {
	
	id sender = [nota object];
	id locator = nil;
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [sender className]);
	
	if([sender isKindOfClass:[NSButton class]])
	{
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @" button");
		locator = [sender superview];
	}
	else if([sender isKindOfClass:[NSMenuItem class]])
	{
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @" menu");
		locator = [sender representedObject];
	}
	if( ! popover) {
		popover = [[NSPopover alloc] init];
		popover.contentViewController = self;
	}
	[textField setStringValue:@"You got it!"];
	[popover showRelativeToRect:[locator bounds] ofView:locator preferredEdge:NSMaxXEdge];
}

@end
