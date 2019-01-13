//
//  AvatarsLine.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/12.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "AvatarsLine.h"

@implementation AvatarsLine {
    BOOL _isBtmLineShowing;
}


- (void)setStyles {
    self.selectedBorderThick = 4;
    self.selectedBorderColor = [ UIColor colorWithRed:196.0/255 green:224.0/255 blue:245.0/255 alpha:1.0 ];
    self.circleR = 35;
    self.autoResizeImg = NO;
    self.autoCircularImg = NO;
    self.lineBgColor = [ UIColor whiteColor ];
    self.cellSpacing = 21;
    self.backgroundColor = [ UIColor whiteColor ];
    self.insets = UIEdgeInsetsMake( 5, 0, 0, 0 );
    
}

- (void)layoutInView:(UIView*)view {
    CGFloat     height = 128;
    [ self setTranslatesAutoresizingMaskIntoConstraints:NO ];
    NSLayoutConstraint *viewLeftConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                          attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view
                                                                          attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *viewRightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view
                                                                           attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    NSLayoutConstraint *viewTopConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:view
                                                                         attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    
    
    
    NSLayoutConstraint *viewHeightConstaint = [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeHeight
                                                                           relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                              toItem:nil
                                                                           attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
    
    [view addConstraints:@[viewLeftConstraint,viewTopConstraint,viewRightConstraint,viewHeightConstaint]];
}


- (void)createDecorateLineView {
    _decorateBtmLineImgView = [ UIImageView new ];
    _decorateBtmLineImgView.contentMode = UIViewContentModeTop;
    [self addSubview:_decorateBtmLineImgView];
    UIImage* img = [ UIImage imageNamed:@"shadowLine"];
    _decorateBtmLineImgView.image = img;
    UIView* cv = _decorateBtmLineImgView;
    UIView* sv = self;
    [ cv setTranslatesAutoresizingMaskIntoConstraints:NO ];
    NSArray* constraintH = [ NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[cv]-0-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings( cv )];
    NSArray* constraintV = [ NSLayoutConstraint constraintsWithVisualFormat:@"V:[sv]-0-[cv(==15)]" options:0 metrics:nil views: NSDictionaryOfVariableBindings( cv,sv )];
    [ self addConstraints:constraintH ];
    [ self addConstraints:constraintV ];
    _decorateBtmLineImgView.layer.opacity = 0;
    
}

- (void)showBtmShadowLine:(BOOL)show animated:(BOOL)animated {
    if( show && _isBtmLineShowing )
        return;
    _isBtmLineShowing = show;
    CGFloat opacity = 0;
    if( show )
        opacity = 1;
    if( animated ) {
        AvatarsLine* wself = self;
        [UIView animateWithDuration:EFFECT_ANIMATION_DURATION animations:^{
            AvatarsLine* sself = wself;
            sself.decorateBtmLineImgView.layer.opacity = opacity;
        }];
    }
    else {
        self.decorateBtmLineImgView.layer.opacity = opacity;
    }
}


- (void)privateInitAvatarsLine {
    [ self createDecorateLineView ];
    [self setStyles];
    
}


- (instancetype)init{
    self = [super init];
    if (self) {
        [self privateInitAvatarsLine ];
    }
    return self;
}

- (void)setCellImage:(UIImage *)img atItemIndex:(NSInteger)index {
    HorizontalLineCell* cell = [ self cellAtIndex:index ];
    if( cell && !( cell.hidden ) ) {
        UIImageView* imgView = ( UIImageView* )( cell.cellContentView );
        imgView.image = img;
    }
}


#pragma mark --implements HorizontalLineCellsView
_override -(void)onSettingCellViewContents:(UIView*)cellView atIndex:(NSInteger)cellIndex {
    [ super onSettingCellViewContents:cellView atIndex:cellIndex ];
    
}

_override -(void)onSelectedCell:(HorizontalLineCell*)cell atIndex:(NSInteger)cellIndex {
    [ super onSelectedCell:cell atIndex:cellIndex ];
    [self selectItemAtIndex:cellIndex animated:YES  scrollPosition:UICollectionViewScrollPositionCenteredHorizontally ];
    self.scrollSnapHelper.isScrollingByBindedHelper = NO;
    [self showBtmShadowLine:NO animated:NO ];
}

_override -(void)onCreateNewCell:(HorizontalLineCell *)cell atIndex:(NSInteger)cellIndex {
    [ super onCreateNewCell:cell atIndex:cellIndex ];
    UIImageView* imgView = (UIImageView*)(cell.contentView);
    imgView.backgroundColor = nil;
}

_override - (void)buildContents_mustInvokeAfterSetFrameSizeAndCellSpacing {
    [ super buildContents_mustInvokeAfterSetFrameSizeAndCellSpacing ];
    self.scrollSnapHelper.delegate = self;
    [ self setFirstCellCenterCanAlignToCenterX ];
    [ self setLastCellCenterCanAlignToCenterX ];
}

#pragma mark --implements ScrollSnapHelper
- (void)scrollSnapHelper:(ScrollSnapHelper *)helper snapPositionReachedAtIndex:(NSInteger)index {
    if( index >= 0 && index < self.cellsNumber ) {
        [self selectItemAtIndex:index animated:NO scrollPosition:UICollectionViewScrollPositionNone ];
    }
}

- (void)scrollSnapHelper:(ScrollSnapHelper *)helper beginScrollByOtherHelper:(ScrollSnapHelper *)other {
    [ self showBtmShadowLine:YES animated:YES ];
}

- (void)scrollSnapHelper:(ScrollSnapHelper *)helper endedScrollByOtherHelper:(ScrollSnapHelper *)other {
    [ self showBtmShadowLine:NO animated:YES ];
}

#pragma mark --ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [ super scrollViewWillBeginDragging:scrollView ];
    self.scrollSnapHelper.isScrollingByBindedHelper = NO;
    [self showBtmShadowLine:NO animated:YES ];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [ super scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset ];
    self.scrollSnapHelper.isScrollingByBindedHelper = NO;
    [self showBtmShadowLine:NO animated:YES ];
}
@end
