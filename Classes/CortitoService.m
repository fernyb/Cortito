//
//  CortitoService.m
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import "CortitoService.h"
#import "ASIHTTPRequest.h"

@implementation CortitoService

+ (NSString *)server_url
{
  NSString * serviceurl = [[NSUserDefaults standardUserDefaults] objectForKey:@"cortitoServiceURL"];
  return serviceurl;
}

- (void)shorten:(NSURL *)originalURL
{
  CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                (CFStringRef)[originalURL absoluteString],
                                                                NULL, 
                                                                (CFStringRef)@";/?:@&=+$,", 
                                                                kCFStringEncodingUTF8);
  
  NSString * url = [[self class] server_url];
  if([url hasPrefix:@"http://"] == NO) {
    NSMutableDictionary * errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:@"Invalid Web Service URL" forKey:NSLocalizedDescriptionKey];
    
    NSError * error = [NSError errorWithDomain:@"net.fernyb.cortito" code:100 userInfo:errorDetail];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kCorititoDidFailToCreateShortUrl object:error];
    return;
  }
  
  NSString *completeString = [NSString stringWithFormat:@"%@?url=%@", url, encoded];
  CFRelease(encoded);
  
  ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:completeString]];
  
  NSMutableDictionary * headers = [NSMutableDictionary dictionary];
  [headers setObject:@"application/javascript" forKey:@"Accept"];
  
  [request setRequestHeaders:headers];
  [request setDelegate:self];
  [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
  NSString * resp = [request responseString];
  [[NSNotificationCenter defaultCenter] postNotificationName:kCorititoDidCreateShortUrl object:[NSURL URLWithString:resp]];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
  NSError * error = [request error];
  [[NSNotificationCenter defaultCenter] postNotificationName:kCorititoDidFailToCreateShortUrl object:error];
}


@end
