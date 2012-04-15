//
//  RSBoundingBox.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-14.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSBoundingBox.h"

@implementation RSBoundingBox

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
	NSRect r = [self bounds];
	
	NSBezierPath * path = [NSBezierPath bezierPathWithRect:NSInsetRect(r, 0, 0)];
	[[NSColor blueColor] set];
	[path stroke];
	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(ctx);
	
	CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.9, 0.1);
	CGContextFillRect(ctx, r);
	
	CGContextRestoreGState(ctx);
}

@end
