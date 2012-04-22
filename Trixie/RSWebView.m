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
@synthesize locators; 
@synthesize taggedNodes;

- (void) awakeFromNib {
	
	trixie = [[NSApp delegate] windowController];
	locators = [NSMutableDictionary dictionary];
	taggedNodes = [NSMutableDictionary dictionary];
		
	boundingBox = nil;
	NSRect inset = NSInsetRect([self bounds], 3, 3);
	trackingRectTag = [self addTrackingRect:inset owner:self userData:nil assumeInside:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tagElement:) name:RSWebViewLeftMouseUpEventNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLocatorFromDict:) name:RSRemoveLocatorNotification object:nil];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}

- (DOMNode*) nodeForTag:(NSString*)tag {
	return [taggedNodes objectForKey:tag];
}

- (RSBoundingBox*) boundingBoxForNodeTag:(NSString*)tag {
	DOMNode * node = [self nodeForTag:tag];
	return [[RSBoundingBox alloc] initWithFrame:[node boundingBox]];
}

- (NSRect) frameRelativeTo:(RSBoundingBox*)bbox {
	return NSMakeRect(bbox.frame.origin.x-20, bbox.frame.origin.y + bbox.frame.size.height - 20, 20, 20);
}

- (NSRect) frameRelativeForTag:(NSString *) tag {
	RSBoundingBox * bbox = [self boundingBoxForNodeTag: tag];
	return [self frameRelativeTo: bbox];
}

- (void) repositionLocatorViews {
	
	// clean up
	[self removeBoundingBox];
		
	for(NSString * idtag in [taggedNodes allKeys]) 
	{
		//	NSLog(@"%s- [%04d] repositioning: %@", __PRETTY_FUNCTION__, __LINE__, idtag);
		
		DOMElement * node = [taggedNodes objectForKey:idtag];
		RSBoundingBox * bbox = [[RSBoundingBox alloc] initWithFrame:[node boundingBox]];
		NSRect newBox = [self flipBoundingBox:[bbox frame] fromWebView:self];
		[bbox setFrame:newBox];
		RSLocatorViewController * lv = [locators objectForKey:idtag];
		[[lv view]setFrame: [self frameRelativeTo:bbox]];
	}
} 

- (void) tagElement:(NSNotification*) notification {
	
	NSEvent * event = [notification object];
	NSPoint pt = [event locationInWindow];
	NSDictionary * dict = [self elementAtPoint:pt];
	DOMElement * node = [dict objectForKey:WebElementDOMNodeKey];
	
	RSBoundingBox * temp = [[RSBoundingBox alloc] initWithFrame:[node boundingBox]];
	
	NSPoint converted = NSMakePoint(temp.frame.origin.x, [self superview].frame.size.height - temp.frame.origin.y - temp.frame.size.height);
	[temp setFrameOrigin:converted];
	 
	RSLocatorViewController * ctlr = [[RSLocatorViewController alloc] init];
	RSLocatorView * tempLocator = (RSLocatorView*)[ctlr view];
	
	// 20 x 20 at top-left of bounding box
	NSRect tempFrame = [self frameRelativeTo:temp];
	//	NSLog(@"%s- [%04d] tempFrame: %@", __PRETTY_FUNCTION__, __LINE__, NSStringFromRect(tempFrame));
	[tempLocator setFrame: tempFrame];

	if( DOM_ELEMENT_NODE == [node nodeType]) 
	{
		if( [[node tagName] isEqualToString:@"IMG"])  
		{
			NSString * idNumber =  [(DOMElement*)node getAttribute:kRSTrixieIdKeyName];
			
			if( [idNumber length] > 0 && [idNumber integerValue]>-1) {
				//NSLog(@"%s- [%04d] found %@", __PRETTY_FUNCTION__, __LINE__, [(DOMElement*)node getAttribute:@"data-trixie-id"]);
			}
			else {
				[(DOMElement*)node setAttribute:kRSTrixieIdKeyName value:[NSString stringWithFormat:@"%d",idnum++]];
			}
			//	NSLog(@"%s- [%04d] %@: data-trixie-img-id: %@", __PRETTY_FUNCTION__, __LINE__, [node tagName],[(DOMElement*)node getAttribute:@"data-trixie-id"]);
			[tempLocator setTag: [[(DOMElement*)node getAttribute:kRSTrixieIdKeyName] integerValue]];
		}
		else {
			//	NSLog(@"%s- [%04d] %@: data-trixie-id: %@", __PRETTY_FUNCTION__, __LINE__, [node tagName],[(DOMElement*)node getAttribute:@"data-trixie-id"]);
			[tempLocator setTag: [[(DOMElement*)node getAttribute:kRSTrixieIdKeyName] integerValue]];
		}
		NSLog(@"%s- [%04d] %lu", __PRETTY_FUNCTION__, __LINE__, [tempLocator tag]);
	}
	else {
		// DOM_TEXT_NODE - use parent node
		DOMElement * parent = (DOMElement*)[node parentNode];
		[tempLocator setTag: [[parent getAttribute:kRSTrixieIdKeyName] integerValue]];
		NSLog(@"%s- [%04d] %@: data-trixie-id: %@", __PRETTY_FUNCTION__, __LINE__, [parent tagName],[parent getAttribute:@"data-trixie-id"]);
	}
	
	
	if(nil != boundingBox)
	{
		[[self superview] replaceSubview:boundingBox with: temp];
	}
	else {
		[[self superview] addSubview:temp];
	}

	
	id obj = [taggedNodes objectForKey:[NSString stringWithFormat:@"%d",tempLocator.tag]];
	if( obj != nil ){
		//
		// the object is already in our cache
		//
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @" already cached node - ");
		
	}
	else {
	
		//	NSLog(@"%s- [%04d] templocator.tag: %lu", __PRETTY_FUNCTION__, __LINE__, tempLocator.tag);
		

		if( ! [[self superview] viewWithTag: tempLocator.tag]) 
		{
			[[self superview] addSubview:tempLocator];
			[tempLocator setNeedsDisplay:YES];
			[locators setObject: ctlr forKey:[NSString stringWithFormat:@"%d",tempLocator.tag]];
			if( DOM_TEXT_NODE == [(DOMElement*)node nodeType]) {
				[taggedNodes setObject:[(DOMElement*)node parentNode] forKey:[NSString stringWithFormat:@"%d",tempLocator.tag]];
			}
			else {
				[taggedNodes setObject: node forKey:[NSString stringWithFormat:@"%d",tempLocator.tag]];
			}
		}
		tempLocator = nil;
	}
	
	boundingBox = temp;
	[boundingBox setDisplayCoordinates:YES];
	[boundingBox setNeedsDisplay:YES];
}

- (IBAction) removeLocatorFromDict:(id)sender { 
	RSLocatorView * view = sender;
	[self removeBoundingBox];
	[locators removeObjectForKey: [NSString stringWithFormat:@"%d",view.tag]];
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
