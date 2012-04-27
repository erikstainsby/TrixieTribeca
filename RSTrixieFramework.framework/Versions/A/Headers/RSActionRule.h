//
//  RSActionRule.h
//  RSTrixiePluginFramework
//
//  Created by Erik Stainsby on 12-02-25.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import "RSAbstractRule.h"

@interface RSActionRule : RSAbstractRule

@property (retain) NSString * event;
@property (retain) NSString * selector;
@property (assign) BOOL preventDefault;
@property (assign) BOOL stopBubbling;

- (NSString*) trigger;

@end
