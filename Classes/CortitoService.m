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
  return @"http://localhost:3000/";
}

- (void)shorten:(NSURL *)originalURL
{
  CFStringRef encoded = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, 
                                                                (CFStringRef)[originalURL absoluteString],
                                                                NULL, 
                                                                (CFStringRef)@";/?:@&=+$,", 
                                                                kCFStringEncodingUTF8);
  
  NSString *completeString = [NSString stringWithFormat:@"%@?url=%@", [[self class] server_url], encoded];
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
