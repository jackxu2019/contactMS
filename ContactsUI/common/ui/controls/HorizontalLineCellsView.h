//
//  HorizontalLineCellsView.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/10.
//  Copyright © 2019 xu54. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "GlobalHeader.h"
#import "ScrollSnapHelper.h"
#import "UIView+util.h"

NS_ASSUME_NONNULL_BEGIN

@class HorizontalLineCell;
@protocol HorizontalLineCellsViewDelegate;

/*
 --------- 设计说明：-----------
 
 ● HorizontalLineCellsView是为了实现一行滚动的CollectionView。
 它具有以下功能：
 1: 具有滚动snap功能，可以自动吸附到某个固定步长
 2: 不需要设置DataSource和CollectionViewDelegate ，直接指定cell个数和大小后，即可快速呈现
 3: 可以随意定义任何UIView作为cell内容
 4: 可以定义任何装饰视图覆盖在cell上
 5: 考虑到各种设计模式中的应用（比如MVC, MVVM, MVP等 ）， 既可以简单的通过继承来设置每一个cell内容（比如单元测试），也可以通过设置delegate实现和设计模式中其他层的对接。
 
 
 ● 为什么不直接继承UICollectionView ?
 1: 因为UICollectionView的构造必须要传入视图大小和内部cell的大小，这样在自动布局过程中就非常被动，使用起来非常不方便。
 2: 因为本控件必须要内部实现dataSource和collectionViewDelegate,如果直接继承UICellectionView, 使用者有可能会不小心重新设置dataSource和delegate,造成重大错误。
 
 ● 为什么不发送Notification ?
 考虑到很多计算在scroll滚动过程中需要密集调用，大量的Notification发送和NSNotificationCenter中查找需要消耗大量的资源，严重影响效率。
 
 */
@interface HorizontalLineCellsView : UIView <UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic,weak)id<HorizontalLineCellsViewDelegate>    delegate;
@property(nonatomic)CGSize      cellSize;
@property(nonatomic)CGFloat     cellSpacing;
@property(nonatomic)UIEdgeInsets    insets;
@property(nonatomic)BOOL        snapOn;
@property(nonatomic,nullable)Class       cellContentViewClass;
@property(nonatomic)NSInteger     cellsNumber;
@property(nonatomic)BOOL          cellHasDecoratorView;
@property(nonatomic)BOOL          allowsMultipleSelection;
@property(nonatomic)UIColor*      lineBgColor;

- (void)buildContents_mustInvokeAfterSetFrameSizeAndCellSpacing;
- (void)setFirstCellCenterCanAlignToX:(CGFloat)x;
- (void)setLastCellCenterCanAlignToX:(CGFloat)x;
- (void)setFirstCellCenterCanAlignToCenterX;
- (void)setLastCellCenterCanAlignToCenterX;
- (void)scrollOffset:(CGFloat)offset withAnimation:(BOOL)animate;
- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animate scrollPosition:(UICollectionViewScrollPosition)pos;
- (ScrollSnapHelper*)scrollSnapHelper;
- (HorizontalLineCell*)cellAtIndex:(NSInteger)index;
- (void)reloadData;


_overridable -(void)onSettingCellViewContents:(UIView*)cellView atIndex:(NSInteger)cellIndex;
_overridable -(void)onSelectedCell:(HorizontalLineCell*)cell atIndex:(NSInteger)cellIndex;
_overridable -(void)onCreateNewCell:(HorizontalLineCell*)cell atIndex:(NSInteger)cellIndex;
_overridable -(void)onSetSelectedAttributeOfCell:(HorizontalLineCell*)cell isSelected:(BOOL)isSel;
_overridable -(void)onScrolling:(UIScrollView*)scrollView;
@end


@interface HorizontalLineCell : UICollectionViewCell
@property(nonatomic,readonly)UIView*     cellContentView;
@property(nonatomic,readonly)UIView*     decoratorView;
@property(nonatomic,weak)HorizontalLineCellsView*   lineContainerView;
- (void)createContentViewWithClass:(Class)cls;
- (void)createDecoratorView;
@end


@protocol HorizontalLineCellsViewDelegate <UIScrollViewDelegate>
@optional
- (void)horizontalLineCellsView:(HorizontalLineCellsView*)sender createdCell:(HorizontalLineCell*)cell atIndex:(NSInteger)index;
- (void)horizontalLineCellsView:(HorizontalLineCellsView*)sender setContentOfCell:(HorizontalLineCell*)cell atIndex:(NSInteger)index;
- (void)horizontalLineCellsView:(HorizontalLineCellsView*)sender selectedCell:(HorizontalLineCell*)cell atIndex:(NSInteger)index isByTap:(BOOL)byTap;

@end

NS_ASSUME_NONNULL_END
