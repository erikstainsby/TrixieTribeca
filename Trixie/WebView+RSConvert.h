//
//  WebView+RSConvert.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-21.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <WebKit/WebKit.h>

@interface WebView (RSConvert)

- (NSRect) flipBoundingBox:(NSRect)htmlBox fromWebView:(WebView*)webView;

@end
