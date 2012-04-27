//
//  RSReactionPlugin.h
//  RSTrixiePluginFramework
//
//  Created by Erik Stainsby on 12-02-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixiePlugin.h"

@interface RSReactionPlugin : RSTrixiePlugin
{
	NSString * _action;
}

@property (retain) NSString * action;
@property (retain) NSString * pluginName;
@property (retain) IBOutlet NSTextField * targetField;
@property (retain) IBOutlet NSTextField * deltaField;
@property (retain) IBOutlet NSTextField * delayField;
@property (retain) IBOutlet NSTextField * periodField;
@property (retain) IBOutlet NSTextField * opacityField;
@property (retain) IBOutlet NSTextField * easingField;
@property (retain) IBOutlet NSTextField * callbackField;

- (BOOL) hasTargetField;
- (BOOL) hasDeltaField;
- (BOOL) hasDelayField;
- (BOOL) hasPeriodField;
- (BOOL) hasOpacityField;
- (BOOL) hasEasingField;
- (BOOL) hasCallbackField;

- (NSString *) emitScript;
- (void) resetForm;

@end 
