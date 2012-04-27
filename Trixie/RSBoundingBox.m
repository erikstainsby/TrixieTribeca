//
//  RSBoundingBox.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-14.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSBoundingBox.h"

@implementation RSBoundingBox

@synthesize displayCoordinates = _displayCoordinates;
@synthesize attr;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		// default
		[self setDisplayCoordinates:NO];
		
		NSFont * font = [[NSFontManager sharedFontManager] fontWithFamily:@"Menlo" traits:NSUnboldFontMask weight:7 size:9];
		NSColor * fgColor = [NSColor blueColor];
		attr = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, fgColor, NSForegroundColorAttributeName, nil];
    }
    return self;
}


- (void)drawRect:(NSRect)dirtyRect
{
	NSRect r = [self bounds];
	
	NSBezierPath * path = [NSBezierPath bezierPathWithRect:NSInsetRect(r, 0, 0)];

	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(ctx);
	
	CGContextSetRGBStrokeColor(ctx, 0.1, 0.1, 1, 0.3);
	[path stroke];
	
	CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.9, 0.04);
	CGContextFillRect(ctx, r);
	
	if(_displayCoordinates) {
		NSRect f = [self frame];
		NSAttributedString * str = [[NSAttributedString alloc] initWithString:NSStringFromRect(f) attributes:attr];
		NSSize ss = [str size];
		NSPoint pt = r.origin;
		float w = ss.width;
		pt.x = r.size.width - w;
		NSRect bb = NSMakeRect(pt.x,pt.y,w,ss.height);
		NSBezierPath * p = [NSBezierPath bezierPathWithRect:bb];
		[[NSColor whiteColor] set];
		CGContextFillRect(ctx, bb);
		CGContextSetRGBStrokeColor(ctx, 0.1, 0.1, 1, 0.3);
		[p stroke];
		[NSStringFromRect(f) drawAtPoint:pt withAttributes:attr];
	}

	CGContextRestoreGState(ctx);
}


@end
