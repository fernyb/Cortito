//
//  CortitoPreferences.h
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface CortitoPreferencesModule : NSObject {
  IBOutlet NSView * prefview;
  IBOutlet NSTextField * serviceTextField;
}

+ (void)install;
+ (NSString *)preferencesPanelName;
+ (CortitoPreferencesModule *)sharedInstance;

- (NSImage *)imageForPreferenceNamed:(NSString *)sender;
- (NSView *)viewForPreferenceNamed:(NSString *)sender;
- (BOOL)moduleCanBeRemoved;
- (void)initializeFromDefaults;
- (void)willBeDisplayed;
- (void)moduleWillBeRemoved;
- (BOOL)hasChangesPending;
- (NSSize)minSize;
- (BOOL)isResizable;
- (void)saveChanges;
- (BOOL)preferencesWindowShouldClose;

@end


@interface NSObject (CortitoPreferencesMethods)
+ (id)cortito_sharedPreferencesFromAppKitSwizzled;
+ (id)cortito_sharedPreferences;
@end

