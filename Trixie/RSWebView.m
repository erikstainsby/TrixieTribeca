//
//  RSWebView.m
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSWebView.h"

@implementation RSWebView

@synthesize boundingBox;
@synthesize locators; 
@synthesize locatorController;
@synthesize trackingRectTag;

static int idnum = 0;

- ( void) awakeFromNib {
	
	locators = [NSMutableArray array];
		
	boundingBox = nil;
	trackingRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tagElement:) name:RSWebViewLeftMouseUpEventNotification object:nil];
}

- (BOOL) acceptsFirstResponder {
	return YES;
}

- (void) tagElement:(NSNotification*)notification {
	
	NSEvent * event = [notification object];
	NSPoint pt = [event locationInWindow];
	NSDictionary * dict = [self elementAtPoint:pt];
	DOMElement * node = [dict objectForKey:WebElementDOMNodeKey];
	
	RSBoundingBox * temp = [[RSBoundingBox alloc] initWithFrame:[node boundingBox]];
	NSPoint converted = NSMakePoint(temp.frame.origin.x, [self superview].frame.size.height - temp.frame.origin.y - temp.frame.size.height);
	[temp setFrameOrigin:converted];
	 
	RSLocatorViewController * ctlr = [[RSLocatorViewController alloc] init];
	RSLocatorView * tempLocator = (RSLocatorView*)[ctlr view];
	NSRect tempFrame = NSMakeRect(temp.frame.origin.x-20, converted.y, 20, temp.frame.size.height);
	[tempLocator setFrame: tempFrame];

	if( DOM_ELEMENT_NODE == [node nodeType]) 
	{
		if( [[node tagName] isEqualToString:@"IMG"]) 
		{
			NSString * idNumber =  [(DOMElement*)node getAttribute:@"data-trixie-img-id"];
			if( [idNumber length] > 0 && [idNumber integerValue]>-1) {
					//	NSLog(@"%s- [%04d] found %@", __PRETTY_FUNCTION__, __LINE__, [(DOMElement*)node getAttribute:@"data-trixie-img-id"]);
			}
			else {
				[(DOMElement*)node setAttribute:@"data-trixie-img-id" value:[NSString stringWithFormat:@"%i",idnum++]];
			}
				//	NSLog(@"%s- [%04d] %@: data-trixie-img-id: %@", __PRETTY_FUNCTION__, __LINE__, [node tagName],[(DOMElement*)node getAttribute:@"data-trixie-img-id"]);
			[tempLocator setTag: [[(DOMElement*)node getAttribute:@"data-trixie-img-id"] integerValue]];
		}
		else {
				//	NSLog(@"%s- [%04d] %@: data-trixie-id: %@", __PRETTY_FUNCTION__, __LINE__, [node tagName],[(DOMElement*)node getAttribute:@"data-trixie-id"]);
			[tempLocator setTag: [[(DOMElement*)node getAttribute:@"data-trixie-id"] integerValue]];
		}
	}
	else {
		DOMElement * parent = (DOMElement*)[node parentNode];
		[tempLocator setTag: [[parent getAttribute:@"data-trixie-id"] integerValue]];
			//	NSLog(@"%s- [%04d] %@: data-trixie-id: %@", __PRETTY_FUNCTION__, __LINE__, [parent tagName],[parent getAttribute:@"data-trixie-id"]);
	}
		
	if(nil != boundingBox)
	{
		[[self superview] replaceSubview:boundingBox with: temp];
	}
	else {
		[[self superview] addSubview:temp];
	}
	[[self superview] addSubview:tempLocator];
	
	if( ! [[self superview] viewWithTag: tempLocator.tag]) 
	{
		[[self superview] addSubview:tempLocator];
		[tempLocator setNeedsDisplay:YES];
		[locators addObject:ctlr];
	}
	tempLocator = nil;
	
	boundingBox = temp;
	[boundingBox setNeedsDisplay:YES];
}

- (void) removeBoundingBox {
	if(nil != boundingBox)
	{
		[boundingBox removeFromSuperview];
		boundingBox = nil;
	}
}

- (IBAction) removeBoundingBox:(id)sender {
	[self removeBoundingBox];
}

- ( void) updateTrackingAreas {
	[self removeTrackingRect:trackingRectTag];
	trackingRectTag = [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

@end
