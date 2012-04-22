//
//  RSLocatorViewController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-14.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSLocatorViewController.h"


@interface RSLocatorViewController ()

@end

@implementation RSLocatorViewController

@synthesize button;
@synthesize node = _node;

- (id)init
{
    self = [super initWithNibName:@"RSLocatorView" bundle:nil];
    if (self) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
    }
    return self;
}


- (DOMElement*) node {
	return _node;
}

- (void) setNode: aNode {
	if( DOM_TEXT_NODE == [aNode nodeType]) {
		_node = [aNode parentElement];
	}
	else {
		_node = aNode;
	}
	
	[(RSLocatorView*)[self view] setNode: _node];
}


@end
