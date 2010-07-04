//
//  CortitoPlugin.h
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class CortitoService;

@interface CortitoPlugin : NSObject {
  CortitoService * service;
  NSString * keyURL;
}

+ (CortitoPlugin *)sharedInstance;
- (void)installMenu;
- (void)disableCreateShortURL;
- (void)enableCreateShortURL;
- (void)registerNotifications;

- (void)createShortURL:(id)sender;
- (void)didCreateShortURL:(NSNotification *)aNotification;
- (void)didFailToCreateShortURL:(NSNotification *)aNotification;

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;
- (void)applicationWillTerminate:(NSNotification *)aNotification;

@end
