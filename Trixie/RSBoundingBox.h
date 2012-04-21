//
//  RSBoundingBox.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-14.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface RSBoundingBox : NSView

@property (assign) BOOL displayCoordinates;
@property (retain) IBOutlet NSDictionary * attr;

@end
