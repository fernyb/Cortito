//
//  CortitoPreferences.m
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <objc/runtime.h>
#import "CortitoPreferences.h"


@implementation CortitoPreferences

+ (void)install
{
  Class WBPreferencesClass = NSClassFromString(@"WBPreferences");
  if(!WBPreferencesClass) {
    NSLog(@"Could not install Cortito Preferences, WBPreferencesClass not available.");
    return;
  }
  
  Method sharedPreferencesFromAppKit = class_getClassMethod(WBPreferencesClass, @selector(sharedPreferences));
  if(!sharedPreferencesFromAppKit) {
    NSLog(@"Could not install Cortito, sharedPreferences not available.");
    return;
  }
  
  Method sharedPreferencesFromAppKitSwizzledByCortitoService = class_getClassMethod(self, @selector(cortito_sharedPreferencesFromAppKitSwizzled));
  Method sharedPreferencesForCortitoService = class_getClassMethod(self, @selector(cortito_sharedPreferences));
 
  method_exchangeImplementations(sharedPreferencesFromAppKit, sharedPreferencesFromAppKitSwizzledByCortitoService);
  method_exchangeImplementations(sharedPreferencesFromAppKit, sharedPreferencesForCortitoService);
}

+ (NSString *)preferencesPanelName
{
  return @"Cortito";
}

+ (CortitoPreferences *)sharedInstance
{
  static CortitoPreferences * instance;
  if(!instance) {
    instance = [[CortitoPreferences alloc] init];
  }
  return instance;
}

- (NSImage *)imageForPreferenceNamed:(id)sender
{
  NSLog(@"%@", sender);
  return [NSImage imageNamed:@"AdvancedPreferences.tiff"];
}

- (id)viewForPreferenceNamed:(id)sender
{
  return [[NSView new] autorelease];
}

- (BOOL)moduleCanBeRemoved
{
  return YES;
}

- (void)initializeFromDefaults
{
  
}

- (void)willBeDisplayed
{
  
}

- (void)moduleWillBeRemoved
{
  
}

@end

@implementation NSObject (CortitoPreferencesMethods)

+ (id)cortito_sharedPreferencesFromAppKitSwizzled
{
  return nil; 
}

+ (id)cortito_sharedPreferences
{
  static BOOL added = NO;
  id preferences = [self cortito_sharedPreferencesFromAppKitSwizzled];
  if (preferences && !added) {
    added = YES;
    [preferences performSelector:@selector(addPreferenceNamed:owner:) 
                      withObject:[CortitoPreferences preferencesPanelName]
                      withObject:[CortitoPreferences sharedInstance]];
  }
  
  return preferences;
}

@end