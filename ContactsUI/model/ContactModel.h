//
//  ContactModel.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : NSObject
@property(nonatomic,copy)NSString*      first_name;
@property(nonatomic,copy)NSString*      last_name;
@property(nonatomic,copy)NSString*      avatar_filename;
@property(nonatomic,copy)NSString*      title;
@property(nonatomic,copy)NSString*      introduction;
@property(nonatomic)UIImage*            avatarImg;
@end

NS_ASSUME_NONNULL_END
