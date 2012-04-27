//
//  RSPopoverController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSPopoverController.h"

@interface RSPopoverController ()

@end

@implementation RSPopoverController

@synthesize popoverWindow;
@synthesize window = _window;
@synthesize borderColor;
@synthesize popoverBackgroundColor;

@synthesize locatorView;
@synthesize currentPanel;
@synthesize currentPlugin;

@synthesize actionPlugin;
@synthesize filterPlugin;
@synthesize reactionPlugin;

@synthesize actionPanel;
@synthesize filterPanel;
@synthesize reactionPanel;


#ifndef RSPopover_constants
#define RSPopover_constants

const CGFloat	distance = 10;
const CGFloat	borderWidth = 3;
const CGFloat	cornerRadius = 12;
const BOOL		drawsArrow = YES;
const CGFloat	arrowWidth = 20;
const CGFloat	arrowHeight = 20;
const BOOL		drawRoundCornerBesideArrow = YES;
const CGFloat	viewMargin = 10;

#endif

- (void) awakeFromNib {
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPopover:) name:RSPopoverRequestedNotification object:nil];
	
	_popoverController = [[SFBPopoverWindowController alloc] initWithWindow:popoverWindow];
	
	[[_popoverController popoverWindow] setBorderColor:[NSColor colorWithCalibratedWhite:0.688 alpha:0.4]];
	[[_popoverController popoverWindow] setPopoverBackgroundColor:[NSColor colorWithCalibratedWhite:0.888 alpha:0.95]];
	[[_popoverController popoverWindow] setDistance:floorf(distance)];
	[[_popoverController popoverWindow] setArrowWidth:floorf(arrowWidth)];
	[[_popoverController popoverWindow] setArrowHeight:floorf(arrowHeight)];
	[[_popoverController popoverWindow] setCornerRadius:floorf(cornerRadius)];
	[[_popoverController popoverWindow] setDrawsArrow:drawsArrow];
	[[_popoverController popoverWindow] setViewMargin:floorf(viewMargin)];
	
}

- (IBAction) swapPlugin:(id)sender {
	
	/**
	 *	 [ A | F | R ] segment control
	 **/
	
	if(0 == [sender selectedSegment]) {
		// show action plugin
		
		[popoverWindow setContentView:actionPanel];
	}
	else if(1 == [sender selectedSegment]) {
		// show filter plugin
		[popoverWindow setContentView:filterPanel];
	}
	else if(2 == [sender selectedSegment]) {
		// show reaction plugin
		[popoverWindow setContentView:reactionPanel];
	}
	
}


- (void) showPopover:(NSNotification*)nota {
	id sender = [nota object];
	
	if([sender isKindOfClass:[NSButton class]]) {
		sender = [sender superview];
	}
	else {
		sender = [sender representedObject];
	}
	
	[self setLocatorView: sender];
	
	if([[_popoverController window] isVisible]) {
		[_popoverController closePopover:locatorView];
	}
	else 
	{
		currentPanel = [sender currentPanel];
		if(nil == currentPanel) currentPanel = actionPanel;
				
		[popoverWindow setContentView:currentPanel];
		
		NSPoint where = [locatorView frame].origin;
		where.x += [locatorView frame].size.width / 2;
		where.y += [locatorView frame].size.height / 2;
//		SFBPopoverPosition position = [_popoverController bestPositionInWindow:_window atPoint:where];
//		[popoverWindow setPopoverPosition:position];
//		[_popoverController displayPopoverInWindow:_window atPoint:where];
		[_popoverController displayPopoverInWindow:_window atPoint:where chooseBestLocation:YES];
		
	}
}

- (void)windowDidResize:(NSNotification *)notification {
	
    if([[_popoverController window] isVisible]) 
	{
        NSPoint where = [locatorView frame].origin;
        where.x += [locatorView frame].size.width / 2;
        where.y += [locatorView frame].size.height / 2;
        [_popoverController movePopoverToPoint:where];
	}
}

@end
