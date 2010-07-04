//
//  CortitoPlugin.m
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <Sparkle/Sparkle.h>
#import "CortitoPlugin.h"
#import "CortitoService.h"
#import "CortitoPreferencesModule.h"

#define CORTITO_MENU_ITEM_TAG 1000


@implementation CortitoPlugin

+ (void)load
{
  CortitoPlugin * plugin = [[self class] sharedInstance];
  [plugin installMenu];
  [plugin registerNotifications];
  [CortitoPreferencesModule install];
}


+ (CortitoPlugin *)sharedInstance
{
  static CortitoPlugin * plugin;
  if(!plugin) {
    plugin = [[[self class] alloc] init];
  }
  return plugin;
}

- (void)registerNotifications
{
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didCreateShortURL:) name:kCorititoDidCreateShortUrl object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFailToCreateShortURL:) name:kCorititoDidFailToCreateShortUrl object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:NSApplicationWillTerminateNotification object:nil];
}

- (void)installMenu
{
  NSMenuItem * newItem;
  NSMenu * newMenu;
  
  newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Cortito" action:NULL keyEquivalent:@""];
  [newItem setTag:CORTITO_MENU_ITEM_TAG];
  
  newMenu = [[NSMenu allocWithZone:[NSMenu menuZone]] initWithTitle:@"Cortito"];
  [newMenu setAutoenablesItems:NO];
  [newItem setSubmenu:newMenu];
  [newMenu release];
  
  NSInteger menuItemCount = [[[NSApp mainMenu] itemArray] count] - 1;
  [[NSApp mainMenu] insertItem:newItem atIndex:menuItemCount];
  [newItem release];
  
  // Add Items to the menu
  newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Create Short URL" action:NULL keyEquivalent:@""];
  [newItem setTarget:self];
  [newItem setAction:@selector(createShortURL:)];
  [newMenu addItem:newItem];
  [newItem release];
  
  newItem = [[NSMenuItem allocWithZone:[NSMenu menuZone]] initWithTitle:@"Check For Updates" action:NULL keyEquivalent:@""];
  [newItem setTarget:self];
  [newItem setAction:@selector(checkForUpdates:)];
  [newMenu addItem:newItem];
  
  [newItem release];
}

- (void)checkForUpdates:(id)sender
{
  SUUpdater * sparkle = [SUUpdater updaterForBundle:[NSBundle bundleForClass:[self class]]];
  [sparkle resetUpdateCycle];
}

- (void)disableCreateShortURL
{
  NSMenuItem * menuItem = [[NSApp mainMenu] itemWithTag:CORTITO_MENU_ITEM_TAG];
  NSMenuItem * subMenuItem = [[menuItem submenu] itemAtIndex:0];
  [subMenuItem setEnabled:NO];
}

- (void)enableCreateShortURL
{
  NSMenuItem * menuItem = [[NSApp mainMenu] itemWithTag:CORTITO_MENU_ITEM_TAG];
  NSMenuItem * subMenuItem = [[menuItem submenu] itemAtIndex:0];
  [subMenuItem setEnabled:YES];
}

- (void)createShortURL:(id)sender
{
  id browserWindow = [NSApp keyWindow];
  if (browserWindow) {
    id browserWindowController = [browserWindow performSelector:@selector(delegate)];
    id locationTextField = [browserWindowController performSelector:@selector(locationField)];
    
    if(keyURL) [keyURL release];
    keyURL = [[locationTextField performSelector:@selector(stringValue)] copy];
    
    if (!service) service = [[CortitoService alloc] init];
    
    [self disableCreateShortURL];
    [service shorten:[NSURL URLWithString:keyURL]];
  }
}

- (void)didCreateShortURL:(NSNotification *)aNotification
{
  NSURL * url = [aNotification object];
  
  NSPasteboard * pasteBoard = [NSPasteboard generalPasteboard];
  [pasteBoard declareTypes:[NSArray arrayWithObjects:NSStringPboardType, nil] owner:nil];
  [pasteBoard setString:[url absoluteString] forType:NSStringPboardType];
  
  NSAlert * alert = [[[NSAlert alloc] init] autorelease];
  [alert addButtonWithTitle:@"OK"];
  [alert setMessageText:@"Cortito Short URL"];
  [alert setInformativeText:[NSString stringWithFormat:@"%@\n\nShorten to:\n%@", keyURL, [url absoluteString]]];
  [alert setAlertStyle:NSWarningAlertStyle];
  
  [[NSSound soundNamed:@"Glass"] play];
 
  [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)didFailToCreateShortURL:(NSNotification *)aNotification
{
  NSError * error = [aNotification object];
  
  NSAlert * alert = [[[NSAlert alloc] init] autorelease];
  [alert addButtonWithTitle:@"OK"];
  [alert setMessageText:@"Error Trying to create Short URL"];
  [alert setInformativeText:[error localizedDescription]];
  [alert setAlertStyle:NSCriticalAlertStyle];
  
  NSBeep();
  
  [alert beginSheetModalForWindow:[NSApp keyWindow] modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
  [self enableCreateShortURL];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification
{
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [[CortitoPreferencesModule sharedInstance] release];
  [[[self class] sharedInstance] release];
}

- (void)dealloc
{
  [service release];
  [keyURL release];
  [super dealloc];
}


@end
