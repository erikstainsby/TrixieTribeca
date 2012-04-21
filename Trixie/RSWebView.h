//
//  RSWebView.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-18.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "RSBoundingBox.h"
#import "RSLocatorViewController.h"

@class RSTrixieController;

@interface RSWebView : WebView
{
	id _delegate;
}

@property (retain) IBOutlet RSTrixieController * trixie;
@property (retain) IBOutlet NSMutableDictionary * locators;
@property (retain) RSBoundingBox * boundingBox;
@property (assign) NSTrackingRectTag trackingRectTag;
@property (retain) IBOutlet NSMutableDictionary * taggedNodes;

- (BOOL) acceptsFirstResponder;
- (void) removeBoundingBox;
- (RSBoundingBox*) boundingBoxForNodeTag:(NSString*)tag;
- (NSRect) frameRelativeTo:(RSBoundingBox*) bbox;
- (NSRect) frameRelativeForTag:(NSString *) tag;
- (IBAction) removeLocatorFromDict:(id)sender;
- (void) repositionLocatorViews;
- (void) tagElement:(NSNotification*)notification;
- (void) updateTrackingAreas;

@end
