//
//  RSTrixie-constants.h
//  RSTrixieEditor
//
//  Created by Erik Stainsby on 12-02-23.
//  Copyright (c) 2012 Roaring Sky. All rights reserved.
//

#ifndef RSTrixieEditor_RSTrixie_constants_h
#define RSTrixieEditor_RSTrixie_constants_h

extern NSString * const RSTrixieReloadJavascriptNotification;
extern NSString * const RSTrixieStoreNewRuleNotification;

extern NSString * const RSWebViewFrameDidFinishLoadNotification;
extern NSString * const RSWebViewLeftMouseDownEventNotification;
extern NSString * const RSWebViewLeftMouseUpEventNotification;

extern NSString * const RSTRIXIE_APP_SUPPORT_DIR;
extern NSString * const RSTRIXIE_WORKING_DIR;

extern NSString * const RSPopoverRequestedNotification;
extern NSString * const RSMouseEnteredLocatorNotification;
extern NSString * const RSMouseExitedLocatorNotification;
extern NSString * const RSRemoveLocatorNotification;

extern NSString * const kRSTrixieIdKeyName;

extern int const RSLocatorStyleNone;
extern int const RSLocatorStyleActionPending;
extern int const RSLocatorStyleReactionPending;
extern int const RSLocatorStyleFilterPending;
extern int const RSLocatorStyleActionComplete;
extern int const RSLocatorStyleReactionComplete;
extern int const RSLocatorStyleFilterComplete;

static NSInteger  idnum;

#endif