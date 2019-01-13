//
//  UIView+util.h
//  ContactsUI
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIView (util)

/**
把subView添加到superView上，并添加自动布局的约束代码，让subView充满superView
 */
+ (void)installSubView:(UIView*)subView toFillSuperView:(UIView*)superView;
@end

NS_ASSUME_NONNULL_END
