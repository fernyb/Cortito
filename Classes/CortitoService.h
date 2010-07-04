//
//  CortitoService.h
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class ASIHTTPRequest;

@interface CortitoService : NSObject {

}

+ (NSString *)server_url;
- (void)shorten:(NSURL *)originalURL;

- (void)requestFinished:(ASIHTTPRequest *)request;
- (void)requestFailed:(ASIHTTPRequest *)request;

@end
