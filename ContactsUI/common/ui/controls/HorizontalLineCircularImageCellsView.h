//
//  HorizontalLineCircularImageCellsView.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//



#import "HorizontalLineCellsView.h"

NS_ASSUME_NONNULL_BEGIN
/*
 --------- 设计说明：-----------
 
 ● HorizontalLineCircularImageCellsView是为了实现一行滚动的圆形图片，除了拥有HorizontalLineCellsView所有功能外
 它还具有以下更多功能：
 1: 圆形的cell
 1: 直接设置某个cell上的图片。
 2: cell被选中后，图片周围会出现圆环。为了提高渲染效率，圆环是额外叠加在最上面的decorateView。
 
 
 ● 关于效率⚠️
 在cell非常多的情况下，还能保证滚动的流畅和丝滑，注意以下使用方法：
 1：建议关闭autoResizeImg，关闭自动缩放图片。在传入图片前，提前对图片缩放。
 2: autoCircularImg可以自动让图片成为圆形（通过设置ImageView的cornerRadius），为了提高效率，建议关闭，提前传入绘制好的圆形图片。
 
 */
@interface HorizontalLineCircularImageCellsView : HorizontalLineCellsView
@property(nonatomic)CGFloat     circleR;
@property(nonatomic)CGFloat     selectedBorderThick;
@property(nonatomic)UIColor*    selectedBorderColor;
@property(nonatomic)BOOL        autoResizeImg;
@property(nonatomic)BOOL        autoCircularImg;



@end


@interface CellRingView : UIView
@property(nonatomic)CAShapeLayer*   ringShapeLayer;
- (void)buildContentWithR:(CGFloat)r andThick:(CGFloat)thick;
@end

NS_ASSUME_NONNULL_END
