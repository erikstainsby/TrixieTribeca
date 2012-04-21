//
//  RSLocatorViewController.m
//  Trixie
//
//  Created by Erik Stainsby on 12-04-14.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSLocatorViewController.h"
#import "RSLocatorView.h"

@interface RSLocatorViewController ()

@end

@implementation RSLocatorViewController

@synthesize button;

- (id)init
{
    self = [super initWithNibName:@"RSLocatorView" bundle:nil];
    if (self) {
		NSLog(@"%s- [%04d] %@", __PRETTY_FUNCTION__, __LINE__, @"");
    }
    return self;
}



@end
