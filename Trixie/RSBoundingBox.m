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

	CGContextRef ctx = [[NSGraphicsContext currentContext] graphicsPort];
	CGContextSaveGState(ctx);
	
	CGContextSetRGBStrokeColor(ctx, 0.1, 0.1, 1, 0.3);
	[path stroke];
	
	CGContextSetRGBFillColor(ctx, 0.1, 0.1, 0.9, 0.04);
	CGContextFillRect(ctx, r);
	
	CGContextRestoreGState(ctx);
}


@end
