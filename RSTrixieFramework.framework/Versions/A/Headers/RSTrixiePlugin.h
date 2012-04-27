//
//  RSTrixiePlugin.h
//  RSTrixiePlugin
//
//  Created by Erik Stainsby on 12-02-15.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSTrixieRule.h"


@interface RSTrixiePlugin : NSViewController

@property (retain) NSString * pluginName;

- (BOOL) hasSelectorField;

@end
