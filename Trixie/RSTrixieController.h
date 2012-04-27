//
//  RSTrixieWindowController.h
//  Trixie
//
//  Created by Erik Stainsby on 12-04-13.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>
#import <SFBPopovers/SFBPopoverWindow.h>
#import "RSWebView.h"

@interface RSTrixieController : NSWindowController < NSComboBoxDataSource, NSComboBoxDelegate >
{
	BOOL _hasJQuery;
	BOOL _hasJQueryUI;
}


#pragma mark - Web browser props

@property (retain) NSArray * resourceCache;
@property (retain) NSMutableArray * history;
@property (retain) IBOutlet NSComboBox * urlLocationBox;
@property (retain) IBOutlet RSWebView * webview;
@property (retain) NSDictionary * pageDict;

#pragma mark - WebView delegate methods & UIDelegate methods

- (IBAction)	goForwardOrBack:(id)sender;
- (void)		webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame;
- (void)		webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame;
- (void)		webView:(WebView*) sender makeFirstResponder:(NSResponder *)responder;
// - (NSArray *)	webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems;


#pragma mark - NSComboBox datasource methods

- (NSInteger)	numberOfItemsInComboBoxCell:(NSComboBox *)aComboBox;
- (id)			comboBoxCell:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index;

@end
