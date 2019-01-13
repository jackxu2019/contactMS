//
//  UIView+util.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "UIView+util.h"

@implementation UIView (util)
+ (void)installSubView:(UIView*)subView toFillSuperView:(UIView*)superView {
    [ superView addSubview:subView ];
    UIView* cv = subView;
    [ cv setTranslatesAutoresizingMaskIntoConstraints:NO ];
    NSArray* constraintH = [ NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cv]-0-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings( cv )];
    NSArray* constraintV = [ NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[cv]-0-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings( cv )];
    [ superView addConstraints:constraintH ];
    [ superView addConstraints:constraintV ];
}
@end
