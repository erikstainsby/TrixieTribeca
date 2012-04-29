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

@synthesize actionMenu;
@synthesize filterMenu;
@synthesize reactionMenu;

@synthesize actionPlugins;
@synthesize filterPlugins;
@synthesize reactionPlugins;


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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeActiveActionPlugin:) name:RSTrixieChangeActiveActionPluginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeActiveFilterPlugin:) name:RSTrixieChangeActiveFilterPluginNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeActiveReactionPlugin:) name:RSTrixieChangeActiveReactionPluginNotification object:nil];
	
	_popoverController = [[SFBPopoverWindowController alloc] initWithWindow:popoverWindow];
	
	[[_popoverController popoverWindow] setBorderColor:[NSColor colorWithCalibratedWhite:0.688 alpha:0.4]];
	[[_popoverController popoverWindow] setPopoverBackgroundColor:[NSColor colorWithCalibratedWhite:0.888 alpha:1]];
	[[_popoverController popoverWindow] setDistance:floorf(distance)];
	[[_popoverController popoverWindow] setArrowWidth:floorf(arrowWidth)];
	[[_popoverController popoverWindow] setArrowHeight:floorf(arrowHeight)];
	[[_popoverController popoverWindow] setCornerRadius:floorf(cornerRadius)];
	[[_popoverController popoverWindow] setDrawsArrow:drawsArrow];
	[[_popoverController popoverWindow] setViewMargin:floorf(viewMargin)];
	
	RSTrixieLoader * loader = [[RSTrixieLoader alloc] init];
	actionPlugins = [loader loadPluginsWithPrefix:@"Action" ofType:@"bundle"];
	filterPlugins = [loader loadPluginsWithPrefix:@"Filter" ofType:@"bundle"];
	reactionPlugins = [loader loadPluginsWithPrefix:@"Reaction" ofType:@"bundle"]; 
	loader = nil;
	
	NSMenu * m1 = [[NSMenu alloc] initWithTitle:@"Actions"];
	for( RSActionPlugin * p in actionPlugins) {
		NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(setActiveActionPlugin:) keyEquivalent:@""];
		[item setRepresentedObject: p];
		[m1 addItem:item];
	}
	[actionMenu setMenu:m1];
	
	NSMenu * m2 = [[NSMenu alloc] initWithTitle:@"Actions"];
	for( RSFilterPlugin * p in filterPlugins) {
		NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(setActiveFilterPlugin:) keyEquivalent:@""];
		[item setRepresentedObject: p];
		[m2 addItem:item];
	}
	[filterMenu setMenu:m2];
	
	NSMenu * m3 = [[NSMenu alloc] initWithTitle:@"Actions"];
	for( RSReactionPlugin * p in reactionPlugins) {
		NSMenuItem * item = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(setActiveReactionPlugin:) keyEquivalent:@""];
		[item setRepresentedObject: p];
		[m3 addItem:item];
	}
	[reactionMenu setMenu:m3];

}

- (IBAction) swapPluginPanel:(id)sender {
	
	/**
	 *	 [ A | F | R ] segment control
	 **/
	
	NSRect frame = locatorView.frame;
	NSPoint pt = locatorView.centerPoint;
	pt.x += frame.origin.x;
	pt.y += frame.origin.y;
	
	//	[popoverWindow orderOut:self];
	if(0 == [sender selectedSegment]) {
		// show action plugin
		currentPanel = actionPanel;
	}
	else if(1 == [sender selectedSegment]) {
		// show filter plugin
		currentPanel = filterPanel;
	}
	else if(2 == [sender selectedSegment]) {
		// show reaction plugin
		currentPanel = reactionPanel;
	}
	[popoverWindow setContentView:currentPanel];
	[_popoverController displayPopoverInWindow:_window atPoint:pt chooseBestLocation:YES];
	
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

		[_popoverController displayPopoverInWindow:_window atPoint:where chooseBestLocation:YES];
		
	}
}

- (void) changeActiveActionPlugin:(NSNotification*)nota {
	RSActionPlugin * p = [nota object];
	if(nil != actionPlugin) {
		[actionPanel replaceSubview:[actionPlugin view] with:[p view]];
	}
	else {
		[actionPanel addSubview:[p view]];
	}
	actionPlugin = p;
}
- (void) changeActiveFilterPlugin:(NSNotification*)nota {
	RSFilterPlugin * p = [nota object];
	if(nil != filterPlugin) {
		[filterPanel replaceSubview:[filterPlugin view] with:[p view]];
	}
	else {
		[filterPanel addSubview:[p view]];
	}
	filterPlugin = p;
}
- (void) changeActiveReactionPlugin:(NSNotification*)nota {
	RSReactionPlugin * p = [nota object];
	if(nil != reactionPlugin) {
		[reactionPanel replaceSubview:[reactionPlugin view] with:[p view]];
	}
	else {
		[reactionPanel addSubview:[p view]];
	}
	reactionPlugin = p;
}

- (void) windowDidResize:(NSNotification *)notification {
	
    if([[_popoverController window] isVisible]) 
	{
        NSPoint where = [locatorView frame].origin;
        where.x += [locatorView frame].size.width / 2;
        where.y += [locatorView frame].size.height / 2;
        [_popoverController movePopoverToPoint:where];
	}
}

@end
