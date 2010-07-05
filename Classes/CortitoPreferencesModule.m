//
//  CortitoPreferences.m
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <objc/runtime.h>
#import "CortitoPreferencesModule.h"


@implementation CortitoPreferencesModule

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

+ (CortitoPreferencesModule *)sharedInstance
{
  static CortitoPreferencesModule * instance;
  if(!instance) {
    instance = [[[self class] alloc] init];
  }
  return instance;
}

- (id) init
{
  self = [super init];
  if (self != nil) {
    [NSBundle loadNibNamed:@"PreferenceView" owner:self];
  }
  return self;
}

- (NSImage *)imageForPreferenceNamed:(NSString *)sender
{
  NSURL * url    = [[NSBundle bundleForClass:[self class]] URLForImageResource:@"cortito.png"];
  NSImage * icon = [[NSImage alloc] initWithContentsOfURL:url];
  
  return [icon autorelease];
}

- (NSView *)viewForPreferenceNamed:(NSString *)sender
{
  return prefview;
}

- (BOOL)moduleCanBeRemoved
{
  return YES;
}

- (void)initializeFromDefaults
{
  serviceURL = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_SERVICE_URL_KEY];
  if(!serviceURL) {
    [[NSUserDefaults standardUserDefaults] setObject:DEFAULT_SERVICE_URL forKey:DEFAULT_SERVICE_URL_KEY];
    serviceURL = [[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_SERVICE_URL_KEY];
  }
  
  if(![NSURL URLWithString:serviceURL]) {
    serviceURL = @"";
  }
  
  if(serviceTextField) {
    [serviceTextField setStringValue:serviceURL];
  }
}

- (void)willBeDisplayed
{
  
}

- (void)moduleWillBeRemoved
{
  
}

- (BOOL)hasChangesPending
{
  if([[serviceTextField stringValue] isEqualToString:serviceURL]) {
    return NO;
  }
  return YES;
}

- (void)saveChanges
{
  [[NSUserDefaults standardUserDefaults] setObject:[serviceTextField stringValue] forKey:DEFAULT_SERVICE_URL_KEY];
}

- (NSSize)minSize
{
  return NSSizeFromCGSize(CGSizeMake(668.0, 150.0));
}

- (BOOL)isResizable
{
  return NO;
}

- (BOOL)preferencesWindowShouldClose
{
  return YES;
}

- (void)dealloc
{
  [prefview release];
  [serviceTextField release];
  [serviceURL release];
  [super dealloc];
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
                      withObject:[CortitoPreferencesModule preferencesPanelName]
                      withObject:[CortitoPreferencesModule sharedInstance]];
  }
  
  return preferences;
}

@end