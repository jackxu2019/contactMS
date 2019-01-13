//
//  AvatarsLine.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/12.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "HorizontalLineCircularImageCellsView.h"

#define EFFECT_ANIMATION_DURATION   0.2

NS_ASSUME_NONNULL_BEGIN


@interface AvatarsLine : HorizontalLineCircularImageCellsView<ScrollSnapHelperDelegate>
@property(nonatomic,readonly)UIImageView*   decorateBtmLineImgView;
- (void)setCellImage:(UIImage*)img  atItemIndex:(NSInteger)index;
- (void)showBtmShadowLine:(BOOL)show    animated:(BOOL)animated;
- (void)layoutInView:(UIView*)view;
@end

NS_ASSUME_NONNULL_END
