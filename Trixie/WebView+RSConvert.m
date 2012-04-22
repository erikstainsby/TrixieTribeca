//
//  WebView+RSConvert.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-21.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "WebView+RSConvert.h"

@implementation WebView (RSConvert)

/**
 *	Takes the bounding box of a DOMElement node expressing webView coordinates
 *	and inverts the Y-axis, returning the same box expressed in window coordinates.
 **/
- (NSRect) flipBoundingBox:(NSRect)htmlBox fromWebView:(WebView*)webView {
	NSRect bounds = [[[webView window] contentView] bounds];
	float newY = bounds.size.height - (htmlBox.size.height + htmlBox.origin.y);
	return NSMakeRect(htmlBox.origin.x,newY,htmlBox.size.width, htmlBox.size.height);
}


@end
