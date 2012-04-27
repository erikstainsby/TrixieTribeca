//
//  RSConditionPlugin.h
//  RSTrixiePluginFramework
//
//  Created by Erik Stainsby on 12-02-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSTrixiePlugin.h"

@interface RSFilterPlugin : RSTrixiePlugin

@property (retain) NSString * pluginName;

@property (retain) NSString * predicate;
@property (retain) IBOutlet NSTextField * selectorField;
@property (retain) IBOutlet NSTextField * valueOfField;

- (NSString *) expression;
- (void) resetForm;

@end
