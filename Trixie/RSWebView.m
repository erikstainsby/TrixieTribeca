//
//  RSWebView.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSWebView.h"
#import "WebView+RSConvert.h"

@implementation RSWebView

@synthesize trixie;
@synthesize trackingRectTag;
@synthesize boundingBox;
@synthesize viewControllers; 
@synthesize taggedNodes;

- (void) awakeFromNib {
	
	trixie			= [[NSApp delegate] windowController];
	viewControllers = [NSMutableDictionary dictionary];
	taggedNodes		= [NSMutableDictionary dictionary];
		
	boundingBox		= nil;
	NSRect inset	= NSInsetRect([self bounds], 3, 3);
	trackingRectTag = [self addTrackingRect:inset owner:self userData:nil assumeInside:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tagElement:) name:RSWebViewLeftMouseUpEventNotification object:nil];
}


- (NSInteger) tagForNode:(DOMElement*)node {
	
	if( DOM_ELEMENT_NODE == [node nodeType]) 
	{
		if( [[node tagName] isEqualToString:@"IMG"])  
		{
			NSString * idNumber =  [(DOMElement*)node getAttribute:kRSTrixieIdKeyName];
			if( [idNumber length] > 0 && [idNumber integerValue]>-1) {
				// if we have a valid idtag skip the next op
			}
			else {
				[(DOMElement*)node setAttribute:kRSTrixieIdKeyName value:[NSString stringWithFormat:@"%d",idnum++]];
			}			
		}
		return [[(DOMElement*)node getAttribute:kRSTrixieIdKeyName] integerValue];
	}
	// DOM_TEXT_NODE - use parent node
	DOMElement * parent = (DOMElement*)[node parentNode];
	return [[parent getAttribute:kRSTrixieIdKeyName] integerValue];
}

- (void) tagElement:(NSNotification*) notification {
	
	NSEvent * event = [notification object];
	NSPoint pt = [event locationInWindow];
	NSDictionary * dict = [self elementAtPoint:pt];
	DOMElement * node = [dict objectForKey:WebElementDOMNodeKey];
	
	RSBoundingBox * temp = [[RSBoundingBox alloc] initWithFrame:[node boundingBox]];
	
	// flip box coords from WebView top-left to Window bottom-left
		NSPoint converted = NSMakePoint(temp.frame.origin.x, [self superview].frame.size.height - temp.frame.origin.y - temp.frame.size.height);
		[temp setFrameOrigin:converted];
	
	RSLocatorViewController * ctlr = [[RSLocatorViewController alloc] init];
	// cache the node in the viewController for instance data access in popover context
	[ctlr setNode:node];
	RSLocatorView * locatorView = (RSLocatorView*)[ctlr view];
	
	// 20 x 20 outside top-left of bounding box
	NSRect tempFrame = [self frameRelativeTo:temp];
	[locatorView setFrame: tempFrame];
	[locatorView setTag: [self tagForNode:node]];
	
	if(nil != boundingBox)
	{
		[[self superview] replaceSubview:boundingBox with: temp];
	}
	else {
		[[self superview] addSubview:temp];
	}

	if([taggedNodes objectForKey:[NSString stringWithFormat:@"%d",locatorView.tag]]){
		//	the object is already in our cache
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @" already cached node - ");
	}
	else {
		if( ! [[self superview] viewWithTag: locatorView.tag]) 
		{
			[[self superview] addSubview:locatorView];
			[locatorView setNeedsDisplay:YES];
			
			[viewControllers setObject: ctlr forKey:[NSString stringWithFormat:@"%d",locatorView.tag]];
			
			if( DOM_TEXT_NODE == [(DOMElement*)node nodeType]) {
				[taggedNodes setObject:[(DOMElement*)node parentNode] forKey:[NSString stringWithFormat:@"%d",locatorView.tag]];
			}
			else {
				[taggedNodes setObject: node forKey:[NSString stringWithFormat:@"%d",locatorView.tag]];
			}
		}
	}
	locatorView = nil;
	
	boundingBox = temp;
	[boundingBox setDisplayCoordinates:YES];
	[boundingBox setNeedsDisplay:YES];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}

- (DOMElement*) nodeForTag:(NSString*)idtag {
	return [taggedNodes objectForKey:idtag];
}

- (RSBoundingBox*) boundingBoxForNodeWithTag:(NSString*)idtag {
	DOMElement * node = [self nodeForTag:idtag];
	return [[RSBoundingBox alloc] initWithFrame:[node boundingBox]];
}

- (NSRect) frameRelativeTo:(RSBoundingBox*)bbox {
	return NSMakeRect(bbox.frame.origin.x-20, bbox.frame.origin.y + bbox.frame.size.height - 20, 20, 20);
}

- (NSRect) frameRelativeForTag:(NSString *) idtag {
	RSBoundingBox * bbox = [self boundingBoxForNodeWithTag: idtag];
	return [self frameRelativeTo: bbox];
}

- (IBAction) removeLocatorFromDict:(id)sender { 
	RSLocatorView * view = sender;
	[self removeBoundingBox];
	[viewControllers removeObjectForKey: [NSString stringWithFormat:@"%d",view.tag]];
	[taggedNodes removeObjectForKey: [NSString stringWithFormat:@"%d",view.tag]];
	NSLog(@"%s- [%04d] object removed for tag", __PRETTY_FUNCTION__, __LINE__ );
}

- (void) removeBoundingBox {
	if(nil != boundingBox)
	{
		[boundingBox removeFromSuperview];
		boundingBox = nil;
	}
}

- (void) updateTrackingAreas {
	[self removeTrackingRect:trackingRectTag];
	trackingRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}


@end
