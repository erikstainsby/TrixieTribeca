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


@interface RSWebView : WebView

@property (retain) IBOutlet NSMutableArray * locators;
@property (retain) IBOutlet RSLocatorViewController * locatorController;
@property (retain) RSBoundingBox * boundingBox;
@property (assign) NSTrackingRectTag trackingRectTag;

- (BOOL) acceptsFirstResponder;
- (void) removeBoundingBox;
- (IBAction) removeBoundingBox:(id)sender;
- (void) tagElement:(NSNotification*)notification;
- (void) updateTrackingAreas;

@end
