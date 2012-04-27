//
//  RSPopoverViewController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSPopoverViewController.h"

@interface RSPopoverViewController ()

- (NSString*) nodeDetails;

@end


@implementation RSPopoverViewController

@synthesize contextNote;
@synthesize locator;
@synthesize popover;
@synthesize popoverHeader;
@synthesize popoverTitle;

@synthesize actionPanel;		// custom view
@synthesize filterPanel;		// custom view
@synthesize reactionPanel;		// custom view

@synthesize actionPlugins;
@synthesize filterPlugins;
@synthesize reactionPlugins;

@synthesize actionMenu;			// popup button
@synthesize filterMenu;			// popup button
@synthesize reactionMenu;		// popup button

@synthesize actionHelp;
@synthesize filterHelp;
@synthesize reactionHelp;

@synthesize activeActionPlugin;
@synthesize activeFilterPlugin;
@synthesize activeReactionPlugin;

@synthesize currentPlugin;
@synthesize currentPanel;

@synthesize placeholderBox;
@synthesize activePanelWidth;
@synthesize activePanelHeight;

const int ACTION = 0;
const int FILTER = 1;
const int REACTION = 2;


- (void) awakeFromNib {
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
	
	actionPlugins = [NSMutableArray array];
	reactionPlugins = [NSMutableArray array];
	filterPlugins = [NSMutableArray array];
	
	currentPlugin = nil;
	currentPanel = nil;

	activeActionPlugin = nil;
	activeFilterPlugin = nil;
	activeReactionPlugin = nil;
	
	RSTrixieLoader * loader = [[RSTrixieLoader alloc] init];

	[self setActionPlugins:		[loader loadPluginsWithPrefix:@"Action"		ofType:@"bundle"]];
	[self setReactionPlugins:	[loader loadPluginsWithPrefix:@"Reaction"	ofType:@"bundle"]];
	[self setFilterPlugins:		[loader loadPluginsWithPrefix:@"Condition"	ofType:@"bundle"]];
	
	loader = nil;
	
	NSMenu * menu = [[NSMenu alloc] init];
	for(RSActionPlugin * p in actionPlugins)
	{
		NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(showActionPlugin:) keyEquivalent:@""];
		[menuItem setRepresentedObject:p];
		[menu addItem:menuItem];
	}
	[actionMenu setMenu:menu];
	menu = nil;
	
	NSMenu * menu2 = [[NSMenu alloc] init];	
	for(RSReactionPlugin * p in reactionPlugins)
	{
		NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(showReactionPlugin:) keyEquivalent:@""];
		[menuItem setRepresentedObject:p];
		[menu2 addItem:menuItem];
	}
	[reactionMenu setMenu:menu2];
	menu2 = nil;
	
	NSMenu * menu3 = [[NSMenu alloc] init];	
	for(RSConditionPlugin * p in filterPlugins)
	{
		NSMenuItem * menuItem = [[NSMenuItem alloc] initWithTitle:[p pluginName] action:@selector(showFilterPlugin:) keyEquivalent:@""];
		[menuItem setRepresentedObject:p];
		[menu3 addItem:menuItem];
	}
	[filterMenu setMenu:menu3];
	menu3 = nil;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(popoverRequested:) name:RSPopoverRequestedNotification object:nil];
}


- (IBAction)	cyclePopover:(id)sender {
	
	int tag = [sender selectedSegment];
	
	if(tag==ACTION ) {
		
		[self showPanel:actionPanel]; 
		[self setCurrentPlugin: [[actionMenu itemAtIndex:([actionMenu indexOfSelectedItem]? [actionMenu indexOfSelectedItem] : 0)] representedObject]];
		// go to filter - enable both
		[[self popoverTitle] setStringValue:@"Action"];
	}
	else if(tag==FILTER ) {
		
		[self showPanel:filterPanel];
		[self setCurrentPlugin: [[filterMenu itemAtIndex:([filterMenu indexOfSelectedItem]? [filterMenu indexOfSelectedItem] : 0)] representedObject]];
		// go to action	- disable goLeft
		[[self popoverTitle] setStringValue:@"Filter"];
	}
	else if(tag==REACTION ) {
		
		[self showPanel:reactionPanel];
		[self setCurrentPlugin: [[reactionMenu itemAtIndex:([reactionMenu indexOfSelectedItem]? [reactionMenu indexOfSelectedItem] : 0)] representedObject]];
		// go to reaction - disable goRight
		[[self popoverTitle] setStringValue:@"Reaction"];
	}
	else {	
		[[self popoverTitle] setStringValue:@"Urk?!"];
		// houston we have a problem
	}
	
	NSLog(@"%s- [%04d] pluginClass: %@, tag: %d", __PRETTY_FUNCTION__, __LINE__, [currentPlugin className], tag);
}


- (void) performClose:(id)sender {
	
}


- (void) showPanel:(NSView*)panel {
	// guard
	if(!panel) panel = actionPanel; 
	
	[self setActivePanelWidth: panel.frame.size.width];
	[self setActivePanelHeight: panel.frame.size.height];
	
	NSLog(@"%s- [%04d] %@: %0.2f", __PRETTY_FUNCTION__, __LINE__, [panel className], panel.frame.size.height);
	
	NSRect newFrameSize = self.view.frame;
	newFrameSize.size.height = popoverHeader.frame.size.height + activePanelHeight;
	
	NSLog(@"%s- [%04d] %@: %0.2f", __PRETTY_FUNCTION__, __LINE__, [self.view className], self.view.frame.size.height);
	
	
	[[self view] setFrame:newFrameSize];
		
	if( currentPanel == nil) 
	{
		[[self view] replaceSubview:[self placeholderBox] with: panel];
	}
	else {
		
		[[self view] replaceSubview:currentPanel with: panel];
	}
	// a custom category on NSView
	[panel setFrameTopLeftPoint: popoverHeader.frame.origin];
	
	currentPanel = panel;
	[locator setCurrentPanel: panel];
	
	[popover showRelativeToRect:[locator bounds] ofView:locator preferredEdge:NSMaxXEdge];
}


- (IBAction)	showActionPlugin:(id)sender {
	
	NSString * name = [sender title];
	RSActionPlugin * p  = [sender representedObject];
	
	if( activeActionPlugin == nil) {
		[actionPanel addSubview:[p view]];
	}
	else {	
		[actionPanel replaceSubview:[activeActionPlugin view] with:[p view]];
	}
	
	[[self popoverTitle] setStringValue:@"Action"];
	
	NSPoint pt = actionMenu.frame.origin;
	pt.x -= 15;
	[[p view] setFrameTopLeftPoint:pt];
	
	currentPlugin = p;
	activeActionPlugin = p;
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, name);
}

- (IBAction)	showReactionPlugin:(id)sender {
	
	NSString * name = [sender title];
	RSReactionPlugin * p  = [sender representedObject];
	
	if( activeReactionPlugin == nil) {
		[reactionPanel addSubview:[p view]];
	}
	else {
		[reactionPanel replaceSubview:[activeReactionPlugin view] with:[p view]];
	}
	
	[[self popoverTitle] setStringValue:@"Filter"];
	
	NSPoint pt = reactionMenu.frame.origin;
	pt.x -= 15;
	[[p view] setFrameTopLeftPoint:pt];
	
	currentPlugin = p;
	activeReactionPlugin = p;
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, name);
}

- (IBAction)	showFilterPlugin:(id)sender {
	
	NSString * name = [sender title];
	RSConditionPlugin * p  = [sender representedObject];
	
	if(activeFilterPlugin == nil) {
		[filterPanel addSubview:[p view]];
	}
	else {
		[filterPanel replaceSubview:[activeFilterPlugin view] with:[p view]];
	}
	
	[[self popoverTitle] setStringValue:@"Reaction"];
	
	NSPoint pt = filterMenu.frame.origin;
	pt.x -= 15;
	[[p view] setFrameTopLeftPoint:pt];	
	
	currentPlugin = p;
	activeFilterPlugin = p;
	
	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, name);
}

- (void)		popoverRequested:(NSNotification*)nota {
	
	id sender = [nota object]; 
	locator = nil;
	
	if( [sender respondsToSelector:@selector(representedObject)] ) {
		locator = [sender representedObject];
	}
	else if( [[sender className] isEqualToString:[RSLocatorView className]]) {
		locator = sender;
	}
	else {
		locator = [sender superview];	// punt
	}
	
	if( ! popover) {
		popover = [[NSPopover alloc] init];
		popover.contentViewController = self;
	}
	//	[contextNote setStringValue:[self nodeDetails]];
	
	currentPanel = [locator currentPanel];
	currentPlugin = [locator currentPlugin];

	[self showPanel:currentPanel];
}	



- (NSString*) nodeDetails {
	NSString * tagName = [[locator node] nodeName];
	NSString * idAttr = [[locator node] getAttribute:@"id"];
	NSString * classes = [[locator node] getAttribute:@"class"];
	return [NSString stringWithFormat:@"<%@ id=\"%@\" class=\"%@\">", tagName, idAttr, classes];
}

@end
