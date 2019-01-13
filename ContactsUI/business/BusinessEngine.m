//
//  BusinessEngine.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "BusinessEngine.h"

@implementation BusinessEngine

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contact = [ ContactPartInEngine new ];
    }
    return self;
}
+ (instancetype)defaultEngine
{
    static BusinessEngine* engine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [ BusinessEngine new ];
    });
    return engine;
}
@end
