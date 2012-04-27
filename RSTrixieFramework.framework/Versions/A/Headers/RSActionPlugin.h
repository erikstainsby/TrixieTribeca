//
//  RSActionPlugin.h
//  RSTrixiePluginFramework
//
//  Created by Erik Stainsby on 12-02-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixiePlugin.h"

@interface RSActionPlugin : RSTrixiePlugin
{
	NSString * _event;
}


@property (retain) NSString * event;
@property (retain) IBOutlet NSTextField * selectorField;
@property (retain) IBOutlet NSButton * preventDefaultButton;
@property (retain) IBOutlet NSButton * stopBubblingButton;

- (BOOL) hasPreventDefaultButton; 
- (BOOL) hasStopBubblingButton; 
- (BOOL) preventDefault; 
- (BOOL) stopBubbling; 

- (NSString *) trigger;

- (void) resetForm;

@end
