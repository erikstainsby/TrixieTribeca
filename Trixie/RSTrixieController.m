//
//  RSTrixieWindowController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-13.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixieController.h"

@interface RSTrixieController ()
{
	DOMDocument * domDoc;
}

@end

@implementation RSTrixieController

@synthesize resourceCache;
@synthesize history;
@synthesize urlLocationBox;
@synthesize webview;
@synthesize pageDict;

- (id)init {
	
    self = [super initWithWindowNibName:@"RSTrixieWindow" owner:self];
    if (self) {
		[webview setMaintainsBackForwardList:YES];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
}

#pragma mark - WebView Browser methods

- (IBAction)	goForwardOrBack:(id)sender {
	if( [sender selectedSegment] == 0 && [webview canGoBack] ) 
	{
		[webview goBack];
	}
	else if( [sender selectedSegment] == 1 && [webview canGoForward] ) 
	{
		[webview goForward];
	}
	
	[urlLocationBox setStringValue:[webview mainFrameURL]];
	
		// update history
	WebHistoryItem * item = [[webview backForwardList] currentItem];
	if( ! [history containsObject:item]) {
		[history addObject:item];
	}
}

- (BOOL)		scanCacheForResourceWithName:(NSString*)resourceName {
	
	for(WebResource * wr in resourceCache) {
		if( [[[wr URL] lastPathComponent] hasPrefix:resourceName] ) 
		{
				//		NSLog(@"%s- [%04d] identified resource: %@ in URL: %@", __PRETTY_FUNCTION__, __LINE__, resourceName, [[wr URL] path]);
			return YES;
		}
	}
	return NO;
}

- (void)		webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
	if( [sender mainFrame] == frame )
	{
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
		resourceCache = [[[sender mainFrame] dataSource] subresources];
		
		_hasJQuery = [self scanCacheForResourceWithName:@"jquery"];
		_hasJQueryUI = [self scanCacheForResourceWithName:@"jqueryui"];
		_hasJQueryUI = [self scanCacheForResourceWithName:@"jquery-ui"];
		
		NSString * urlString = [webview mainFrameURL];
		
		DOMDocument * doc = [webview mainFrameDocument];
		domDoc = doc;
		NSString * doctype = [self doctypeString:[doc doctype]];
		
		DOMNode * html = [(DOMNodeList *)[doc getElementsByTagName:@"html"] item:0];
		NSString * htmlTag = [self selectorForDOMNode:html];
		
		DOMNodeList * list = [doc getElementsByTagName:@"head"];
		DOMHTMLElement * head = (DOMHTMLElement*)[list item:0]; 
		NSString * headString = [head innerHTML];
		
		list = [doc getElementsByTagName:@"body"];
		DOMNode * body = [list item:0];
		
		[self annotateDOMNodes:body];
		
		NSString * bodyTag = [self selectorForDOMNode:body];
		NSString * bodyString = [(DOMHTMLElement *)body innerHTML];
		
		pageDict = [NSDictionary dictionaryWithObjectsAndKeys:urlString,@"url",
					doctype,@"doctype",
					htmlTag,@"htmlTag",
					headString,@"head",  
					bodyTag,@"bodyTag",
					bodyString,@"body", 
					nil];
		
		[[NSNotificationCenter defaultCenter] postNotificationName: RSWebViewFrameDidFinishLoadNotification object:pageDict];
		
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"doctype"]);
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"htmlTag"]);
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"head"]);
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"bodyTag"]);
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [pageDict valueForKey:@"body"]);
	}
}
- (void)		webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
	if( [[sender mainFrame] isEqual: frame] )
	{
		[[sender window] setTitle: title];
	}
}
- (void)		webView:(WebView*) sender makeFirstResponder:(NSResponder *)responder { 
	if( [responder respondsToSelector:@selector(acceptsFirstResponder:)] )
	{
		[responder becomeFirstResponder];
	}
}

- (NSString *)	doctypeString:(DOMDocumentType*)doctype {
	NSString * string = @"<!doctype";
	
	if([[doctype name] length] > 0) string = [string stringByAppendingFormat:@" %@",[doctype name]];
	if([[doctype publicId] length] > 1) string = [string stringByAppendingFormat:@" \"%@\"",[doctype publicId]];
	if([[doctype systemId] length] > 1) string = [string stringByAppendingFormat:@" \"%@\"",[doctype systemId]];
	
	string = [string stringByAppendingString:@">"];
	
	return string;
}
- (NSString *)	selectorForDOMNode:(DOMNode*)node {
	
	NSString * selector = @"";
	DOMElement * el = nil;
	if( [node nodeType] == DOM_ELEMENT_NODE) 
	{
		el = (DOMElement *)node;
	}
	else if( [node nodeType] == DOM_TEXT_NODE)  
	{
		el = [(DOMElement *)node parentElement];	
	}	
	if( el != nil ) {
		selector = [el tagName]; 
		if([el hasAttribute:@"id"]) {
			selector = [selector stringByAppendingFormat:@"#%@",[el getAttribute:@"id"]];
		}
		if( ! [[el className] isEqualToString:@""] ) {
				// classes may be multiple
			NSString * classes = [[[el className] componentsSeparatedByString:@" "] componentsJoinedByString:@"."];
			selector = [selector stringByAppendingFormat:@".%@",classes];
		}
		
			//		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, selector );
	}
	return selector;
}
- (void)		annotateDOMNodes:(DOMNode *)parent {
	
	//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, [parent nodeName]);
	
	if( DOM_ELEMENT_NODE == [parent nodeType]) {
		//	NSLog(@"%s- [%04d] tagging: %@", __PRETTY_FUNCTION__, __LINE__, [(DOMElement *)parent tagName]);
		[(DOMElement*)parent setAttribute:@"data-trixie-id" value:[NSString stringWithFormat:@"%i",idnum++]];
	}
	
	DOMNodeList * list = [parent childNodes];
	for( int i=0;i<[list length];i++) 
	{
		DOMNode * node = [list item:i];
		if([node hasChildNodes]) 
		{
			[self annotateDOMNodes:node];
		}
	}		
}

#pragma mark - NSComboBox datasource methods 

- (NSInteger)	numberOfItemsInComboBoxCell:(NSComboBoxCell *)aComboBox {
	return [history count];
}

- (id)			comboBoxCell:(NSComboBoxCell *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
	WebHistoryItem * item = [history objectAtIndex:index];
	return [item URLString];
}

/**
- (NSArray *)	webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element defaultMenuItems:(NSArray *)defaultMenuItems {
	
	NSString * nodeSelector = [self selectorForDOMNode:[element objectForKey:WebElementDOMNodeKey]];
	
		//	NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, nodeSelector);
	
	NSMenuItem * item1 = [[NSMenuItem alloc] initWithTitle:@"Set Action selector" 
													action:@selector(quickSetActionSelector:) 
											 keyEquivalent:@""];
	NSMenuItem * item2 = [[NSMenuItem alloc] initWithTitle:@"Set Reaction selector" 
													action:@selector(quickSetReactionSelector:) 
											 keyEquivalent:@""];
	NSMenuItem * item3 = [[NSMenuItem alloc] initWithTitle:@"Set filter selector" 
													action:@selector(quickSetfilterSelector:) 
											 keyEquivalent:@""];
	
	if([[self activeActionPlugin] hasSelectorField] ) {
		[item1 setTarget:self];
		[item1 setEnabled:YES];
		[item1 setRepresentedObject:nodeSelector];
	}
	else {
		[item1 setEnabled:NO];
	}
	if([[self activeReactionPlugin] hasSelectorField]) {
		[item2 setTarget:self];
		[item2 setEnabled:YES];
		[item2 setRepresentedObject:nodeSelector];
	}
	else {
		[item2 setEnabled:NO];
	}
	if([[self activeFilterPlugin] hasSelectorField]) {
		[item3 setTarget:self];
		[item3 setEnabled:YES];
		[item3 setRepresentedObject:nodeSelector];
	}
	else {
		[item3 setEnabled:NO];
	}
	
	NSMutableArray * myMenu = [NSMutableArray arrayWithObjects:item1,item2,item3,nil];
	return [myMenu arrayByAddingObjectsFromArray:defaultMenuItems];
}
*/


@end
