//
//  CortitoPreferences.h
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CortitoPreferences : NSObject {

}

+ (void)install;
+ (NSString *)preferencesPanelName;
+ (CortitoPreferences *)sharedInstance;

- (NSImage *)imageForPreferenceNamed:(id)sender;
- (id)viewForPreferenceNamed:(id)sender;
- (BOOL)moduleCanBeRemoved;
- (void)initializeFromDefaults;
- (void)willBeDisplayed;
- (void)moduleWillBeRemoved;

@end


@interface NSObject (CortitoPreferencesMethods)
+ (id)cortito_sharedPreferencesFromAppKitSwizzled;
+ (id)cortito_sharedPreferences;
@end

