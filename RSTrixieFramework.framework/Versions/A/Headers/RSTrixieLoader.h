//
//  RSTrixieLoader.h
//  RSTrixiePluginFramework
//
//  Created by Erik Stainsby on 12-03-03.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RSTrixie.h"


@interface RSTrixieLoader : NSObject

- (NSArray*) loadPluginsWithPrefix:(NSString*)prefix ofType:(NSString*)fileExt;

@end
