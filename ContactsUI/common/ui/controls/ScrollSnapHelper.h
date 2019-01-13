//
//  ScrollHelper.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/10.
//  Copyright © 2019 xu54. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ScrollHelperDirection)
{
    ScrollHelperDirection_Horizontal,
    ScrollHelperDirection_Vertical
};

NS_ASSUME_NONNULL_BEGIN
@protocol ScrollSnapHelperDelegate;

/*
 --------- 设计说明：-----------
 ● ScrollSnapHelper是为了实现对UIScrollView的吸附snap功能。
 它具有以下功能：
 1: 在attach到任何一个UIScrollView后，就可以让这个scrollView具有滚动snap功能，可以自动吸附到某个固定步长。
 2: 打开snap功能后，无论用什么方式滚动视图，都只能滚动指定步长的整数倍。
 3: 具有最小位移限位功能，在最小位移内的移动，都会回到原来的位置。
 4: 可以支持横向或竖向的滚动。
 
 ● 使用方法
 1: 实例化一个ScrollSnapHelper对象。
 2: [ helper attachScrollView: scrollV ] 关联一个scrollView，并设置snap的步长
 3: 把所有带_mustInvoke_inXXX前缀的方法在scrollView的xxx方法中调用
 4: 如果需要两个scrollView互相关联滚动，可以使用[ helper1 bindScrollWithAnotherHelper:helper2 scrollRatioToOther:ratio isDual:YES ]
 ( isDual 表示是否需要双向绑定滚动 ，ratio 是help1对help2的滚动速度比)
 
 ● 后续的扩展功能 （ 尚未开发 ）
 1: AOP切片设计，可以在包含头文件后，自动侵入UIScrollView的各方法（通过swizzle)，使用更简洁。
 2: 不同helper之间可以联动，可以让N个helper发生联动，一个发生滚动，则其他都一起按给定比例滚动。
 比如： [ helper1 connect:helper2 withStepRatio:2.5 ] //help1滚动时，help2也会滚动，滚动位移比例为2.5

 */
@interface ScrollSnapHelper : NSObject
@property(nonatomic,weak)id<ScrollSnapHelperDelegate>    delegate;
@property(nonatomic)CGFloat     snapUnitLengthForOffset;
@property(nonatomic)CGFloat     snapTolerance;
@property(nonatomic)CGFloat     minDistanceToMove;
@property(nonatomic,weak)UIScrollView*      scrollView;
@property(nonatomic)ScrollHelperDirection   scrollDirection;
@property(nonatomic)BOOL        snapOn;
@property(nonatomic,readonly)NSInteger      snappedIndex;
@property(nonatomic)BOOL                    isScrollingByBindedHelper;

- (void)attachScrollView:(UIScrollView*)scrollView;
- (void)detachScrollView;
- (void)bindScrollWithAnotherHelper:(ScrollSnapHelper*)other scrollRatioToOther:(CGFloat)ratio isDualBind:(BOOL)isDual;
- (void)unbindScrollWithAnotherHelper_isDualUnbind:(BOOL)isDual;
- (void)scrollWithTotalOffset:(CGFloat)offset animated:(BOOL)animated;
- (ScrollSnapHelper*)bindedHelper;

#pragma mark -- methods must invoked in scrollView
- (void)_mustInvoke_inBeginDrag;
- (void)_mustInvoke_in_scrollViewWillEndDraggingWithVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)_mustInvoke_in_scrollViewDidScroll;
- (void)_mustInvoke_in_scrollViewDidEndDecelerating;

@end

@protocol ScrollSnapHelperDelegate <NSObject>
@optional
- (void)scrollSnapHelper:(ScrollSnapHelper*)helper  snapPositionReachedAtIndex:(NSInteger)index;
- (void)scrollSnapHelper:(ScrollSnapHelper *)helper beginScrollByOtherHelper:(ScrollSnapHelper*)other;
- (void)scrollSnapHelper:(ScrollSnapHelper *)helper endedScrollByOtherHelper:(ScrollSnapHelper *)other;

@end

NS_ASSUME_NONNULL_END
