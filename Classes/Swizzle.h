//
//  Swizzle.h
//  Cortito
//
//  Created by fernyb on 7/3/10.
//  Copyright 2010 Fernando Barajas. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface Swizzle : NSObject {

}

+ (void)swizzleClass:(Class)targetClass targetSelector:(SEL)targetSel newSelector:(SEL)newSel;

@end
