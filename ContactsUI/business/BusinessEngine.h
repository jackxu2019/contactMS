//
//  BusinessEngine.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ContactPartInEngine.h"
#define defualtBusinessEngine   ([BusinessEngine defaultEngine])
NS_ASSUME_NONNULL_BEGIN

@interface BusinessEngine : NSObject
@property(nonatomic)ContactPartInEngine*    contact;
+ (instancetype)defaultEngine;
@end

NS_ASSUME_NONNULL_END
