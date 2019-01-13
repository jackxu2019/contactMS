//
//  HorizontalLineCellsView.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/10.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "HorizontalLineCellsView.h"
#import "ScrollSnapHelper.h"
#define REUSE_CELL_ID       @"HLineCell"
#import "HorizontalLineCellsView+scrollDelegate.h"
@implementation HorizontalLineCellsView {
    UICollectionView*   _collectionView;
    ScrollSnapHelper*   _snapHelper;
    
}

- (void)privateInitHorizontalLineCellsView {
    _cellSpacing = 5;
    _cellsNumber = 20;
    _cellContentViewClass = [ UIView class ];
    _cellHasDecoratorView = YES;
    _allowsMultipleSelection = NO;
    _snapOn = YES;
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
        [ self privateInitHorizontalLineCellsView ];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [ self privateInitHorizontalLineCellsView ];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    
    self = [super initWithCoder:coder];
    if (self) {
        [ self privateInitHorizontalLineCellsView ];
    }
    return self;
}


- (void)buildContents_mustInvokeAfterSetFrameSizeAndCellSpacing {
    
    [self layoutIfNeeded];
    NSAssert(self.bounds.size.width > 0.01 && self.bounds.size.height > 0.01 , @"Must setting frame size of HorizontalLineCellsView before buildSubViewsWithCellSize" );
    NSAssert( _collectionView == Nil , @"buildSubViewswithCellSize can be invoked only once" );
    
    UICollectionViewFlowLayout* layout = [ UICollectionViewFlowLayout new ];
    layout.minimumLineSpacing = _cellSpacing;
    layout.minimumInteritemSpacing = _cellSpacing;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[ UICollectionView alloc ] initWithFrame:self.bounds  collectionViewLayout:layout ];
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
    _collectionView.frame = self.bounds;
    
    _snapHelper = [ ScrollSnapHelper new ];
    _snapHelper.snapOn = _snapOn;
    _snapHelper.scrollView = _collectionView;
    _snapHelper.snapUnitLengthForOffset = _cellSize.width + _cellSpacing;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.allowsMultipleSelection = _allowsMultipleSelection;
    [_collectionView registerClass:[ HorizontalLineCell class ] forCellWithReuseIdentifier:REUSE_CELL_ID ];
    _collectionView.backgroundColor = [UIColor clearColor];

}

- (void)selectItemAtIndex:(NSInteger)index animated:(BOOL)animate scrollPosition:(UICollectionViewScrollPosition)pos{
    [_collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:index  inSection:0 ] animated:animate scrollPosition:pos ];
}
_overridable -(void)onSettingCellViewContents:(UIView*)cellView atIndex:(NSInteger)cellIndex {
    
}

_overridable -(void)onSelectedCell:(HorizontalLineCell*)cell atIndex:(NSInteger)cellIndex {
    
}

_overridable -(void)onCreateNewCell:(HorizontalLineCell *)cell atIndex:(NSInteger)cellIndex {
    
}

_overridable -(void)onSetSelectedAttributeOfCell:(HorizontalLineCell*)cell isSelected:(BOOL)isSel {
    
}

_overridable -(void)onScrolling:(UIScrollView *)scrollView {

}

- (void)setSnapOn:(BOOL)snapOn {
    _snapOn = snapOn;
    if( _snapHelper )
        _snapHelper.snapOn = _snapOn;
}

- (void)scrollOffset:(CGFloat)offset withAnimation:(BOOL)animate {
    CGPoint contentOffset = _collectionView.contentOffset;
    contentOffset.x += offset;
    [ _collectionView setContentOffset:contentOffset animated:animate ];
}


- (void)setFirstCellCenterCanAlignToX:(CGFloat)x {
    _insets.left = x - _cellSize.width/2;
}


- (void)setLastCellCenterCanAlignToX:(CGFloat)x {
    _insets.right = x - _cellSize.width/2;
}


- (void)setFirstCellCenterCanAlignToCenterX {
    [self setFirstCellCenterCanAlignToX:self.bounds.size.width/2 ];
}


- (void)setLastCellCenterCanAlignToCenterX {
    [self setLastCellCenterCanAlignToX:self.bounds.size.width/2 ];
}

- (ScrollSnapHelper*)scrollSnapHelper {
    return _snapHelper;
}

- (void)setLineBgColor:(UIColor *)lineBgColor {
    self.backgroundColor = lineBgColor;
}

- (UIColor*)lineBgColor {
    return self.backgroundColor;
}

#pragma mark --implement scrollViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _cellsNumber;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    HorizontalLineCell*   cell = (HorizontalLineCell*)[ collectionView dequeueReusableCellWithReuseIdentifier:REUSE_CELL_ID forIndexPath:indexPath ];
    cell.lineContainerView = self;

    if( !cell.cellContentView ) {
        [ cell createContentViewWithClass: _cellContentViewClass ];
        if( _cellHasDecoratorView )
            [ cell createDecoratorView ];
        [ self onCreateNewCell:cell atIndex:indexPath.item ];
        if( _delegate && [ _delegate respondsToSelector:@selector(horizontalLineCellsView:createdCell:atIndex:)] ) {
            [ _delegate horizontalLineCellsView:self createdCell:cell atIndex:indexPath.item ];
        }
    }

    [ self onSettingCellViewContents:cell.subviews[0] atIndex:indexPath.item ];
    if( _delegate && [ _delegate respondsToSelector:@selector(horizontalLineCellsView:setContentOfCell:atIndex:)] ) {
        [ _delegate horizontalLineCellsView:self setContentOfCell:cell  atIndex:indexPath.item ];
    }

    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return _cellSize;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return _insets;
}

-(HorizontalLineCell*)cellAtIndex:(NSInteger)index {
    return (HorizontalLineCell*)[ _collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0 ] ];
}

- (void)reloadData {
    [_collectionView reloadData];
}
#pragma mark --UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    HorizontalLineCell * cell = (HorizontalLineCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [ self onSelectedCell:cell atIndex:indexPath.item ];
    if( _delegate && [ _delegate respondsToSelector:@selector(horizontalLineCellsView:selectedCell:atIndex:isByTap:)] ) {
        [ _delegate horizontalLineCellsView:self selectedCell:cell atIndex:indexPath.item isByTap:YES ];
    }
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



@end


@implementation HorizontalLineCell

- (instancetype)init{
    
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)createContentViewWithClass:(Class)cls {
    
    if( _cellContentView )
        [_cellContentView removeFromSuperview ];
    _cellContentView = [ self createSubViewWithClass:cls ];
    _cellContentView.backgroundColor = [ UIColor grayColor ];
    
}

- (void)createDecoratorView {
    if( _decoratorView )
        return;
    _decoratorView = [ self createSubViewWithClass:[ UIView class ] ];
}

- (void)setSelected:(BOOL)selected {
    [ super setSelected:selected ];
    if( _lineContainerView )
        [ _lineContainerView onSetSelectedAttributeOfCell:self isSelected:selected ];
}



- (UIView*)createSubViewWithClass:(Class)cls {
    UIView* cv = [ cls new ];
    [ UIView installSubView:cv toFillSuperView:self.contentView ];
    return cv;
}
@end
