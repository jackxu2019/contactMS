//
//  ScrollHelper.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/10.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "ScrollSnapHelper.h"

@implementation ScrollSnapHelper {

    CGFloat             _lastScrollPosition;
    __weak ScrollSnapHelper*    _bindedHelper;
    CGFloat             _bindedScrollRatio;
    
    
}

- (void)privateInit_ScrollSnapHelper {
    
    _minDistanceToMove = 20;
    _scrollDirection = ScrollHelperDirection_Horizontal;
    _snapOn = YES;
    _snapTolerance = 27;

}

- (instancetype)init{
    
    self = [super init];
    if (self) {
        [self privateInit_ScrollSnapHelper];
    }
    return self;
}

/**
 return : TRUE - snap occured
 return :the index at snap occuring.
 */
- (BOOL)snapIndexWithTotalOffset:(CGFloat)offset tolerance:(CGFloat)tolerance returnIndex:(NSInteger*)returnIndex {
    if( _snapUnitLengthForOffset < 1 )
        return NO;
    NSInteger   index = -1;
    CGFloat     cellNumFloat = ABS( offset / _snapUnitLengthForOffset );
    NSInteger   cellNumInt = (NSInteger)cellNumFloat;
    CGFloat     remainder = ABS( offset ) - cellNumInt * _snapUnitLengthForOffset;
    BOOL occured = NO;
    if( remainder < tolerance ) {
        occured = YES;
        index = cellNumInt;
    }
    else if( _snapUnitLengthForOffset - remainder < tolerance ) {
        occured = YES;
        index = cellNumInt + 1;
    }
    if( occured ) {
        if( offset < 0 )
            index = -index;
        *returnIndex = index;
        return YES;
    }
    return NO;
}


- (CGFloat)forceSnapeOffsetWithCurrentOffset:(CGFloat)offset {
    CGFloat resultOffset = offset;
    if( _snapUnitLengthForOffset < 1 )
        return resultOffset;
    CGFloat     cellNumFloat = ABS( offset / _snapUnitLengthForOffset );
    NSInteger   cellNumInt = (NSInteger)cellNumFloat;
    if( cellNumFloat - cellNumInt < 0.5 )
        resultOffset = cellNumInt * _snapUnitLengthForOffset;
    else
        resultOffset = ( cellNumInt + 1 ) * _snapUnitLengthForOffset;
    if( offset < 0 )
        resultOffset = -resultOffset;
    return resultOffset;
}

- (void)scrollWithTotalOffset:(CGFloat)offset animated:(BOOL)animated {
    CGPoint pt = _scrollView.contentOffset;
    if( _scrollDirection == ScrollHelperDirection_Horizontal )
        pt.x = offset;
    else
        pt.y = offset;
    [ _scrollView setContentOffset:pt animated:animated ];
}

#pragma mark -- methods must invoked in scrollView
- (void)_mustInvoke_inBeginDrag {
    if( !_scrollView || !_snapOn )
        return;
    if( _scrollDirection == ScrollHelperDirection_Horizontal )
        _lastScrollPosition = _scrollView.contentOffset.x;
    else
        _lastScrollPosition = _scrollView.contentOffset.y;
}

- (void)_mustInvoke_in_scrollViewDidScroll {
    [self accessBindedHelperIfNeed ];
    if( !_snapOn )
        return;
    if( ABS( _snapUnitLengthForOffset ) < 1 )
        return;

    CGFloat offset = _scrollView.contentOffset.x;
    if( _scrollDirection == ScrollHelperDirection_Vertical )
        offset = _scrollView.contentOffset.y;
    NSInteger index = 0;
    BOOL snapOccured = [ self snapIndexWithTotalOffset:offset tolerance:_snapTolerance returnIndex:&index ];
    if( snapOccured && index != _snappedIndex ) {
        if( _delegate && [_delegate respondsToSelector:@selector(scrollSnapHelper:snapPositionReachedAtIndex:) ]
           )
            [ _delegate scrollSnapHelper:self snapPositionReachedAtIndex:index ];
        _snappedIndex = index;
    }
    
}

- (void)_mustInvoke_in_scrollViewDidEndDecelerating {
    _isScrollingByBindedHelper = NO;
    if( !_bindedHelper )
        return;
    if(   _bindedHelper.isScrollingByBindedHelper ) {
        if( _bindedHelper.delegate &&  [_bindedHelper.delegate respondsToSelector:@selector(scrollSnapHelper:endedScrollByOtherHelper:) ] ) {
            [ _bindedHelper.delegate scrollSnapHelper:self endedScrollByOtherHelper:_bindedHelper ];
        }
        //解决误差累计
        CGFloat scrollTo = self.snappedIndex * _bindedHelper.snapUnitLengthForOffset;
        [_bindedHelper scrollWithTotalOffset:scrollTo animated:NO ];
        
    }
    _bindedHelper.isScrollingByBindedHelper = NO;
    
}

- (void)_mustInvoke_in_scrollViewWillEndDraggingWithVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if( !_scrollView || !_snapOn )
        return;
    CGFloat snapUnit = _snapUnitLengthForOffset;
    if( snapUnit < 0.01 )
        return;
    CGFloat v = velocity.x;
    CGFloat currentOffset = targetContentOffset->x;
    CGFloat newOffset = 0;
    if( _scrollDirection == ScrollHelperDirection_Vertical ) {
        
        v = velocity.y;
        currentOffset = targetContentOffset->y;
    }
    newOffset = currentOffset;
    
    
    //Very small velocity means that there's only drag-stop gesture without swipe.
    //That means the scroll view stopped as soon as user end dragging.
    BOOL needCalculateNewOffset = YES;
    if( ABS( v ) < 0.01 ) {
        
        CGFloat offset = currentOffset - _lastScrollPosition;
        if( ABS( offset ) > _minDistanceToMove && ABS( offset ) < snapUnit ) {
            newOffset = floor( ABS(currentOffset) / snapUnit)*snapUnit;
            if( offset < 0 )
                newOffset -= snapUnit;
            else
                newOffset += snapUnit;
            needCalculateNewOffset = NO;
        }
        
        

    }
    if( needCalculateNewOffset ) {
        
        newOffset = ceil( ABS(currentOffset) / snapUnit)*snapUnit;
        if( currentOffset < 0 )
            newOffset = -newOffset;

    }

    newOffset = [self forceSnapeOffsetWithCurrentOffset:currentOffset ];
    if( _scrollDirection == ScrollHelperDirection_Horizontal ) {
        
        targetContentOffset->x = newOffset;
    }
    else {
        
        targetContentOffset->y = newOffset;
    }
    
    _lastScrollPosition = currentOffset;
    
    
}

- (void)attachScrollView:(UIScrollView*)scrollView {
    _scrollView = scrollView;
}
- (void)detachScrollView {
    _scrollView = nil;
}

#pragma mark -- access binded scrolling
- (void)accessBindedHelperIfNeed {
    if( !_bindedHelper )
        return;
    if( _isScrollingByBindedHelper )
        return;
    if( ABS( _bindedScrollRatio ) < 0.0001 )
        return;
    if( !_bindedHelper.isScrollingByBindedHelper ) {
        _bindedHelper.isScrollingByBindedHelper = YES;
        if( _bindedHelper.delegate && [ _bindedHelper.delegate respondsToSelector:@selector(scrollSnapHelper:beginScrollByOtherHelper:)] )
            [ _bindedHelper.delegate scrollSnapHelper:self beginScrollByOtherHelper:_bindedHelper ];
    }
    
    CGFloat offset = _scrollView.contentOffset.x;
    if( _scrollDirection == ScrollHelperDirection_Vertical )
        offset = _scrollView.contentOffset.y;
    CGFloat otherOffset = offset / _bindedScrollRatio;
    UIScrollView* otherScrollView = _bindedHelper.scrollView;
    CGPoint newOffset = otherScrollView.contentOffset;
    if( _bindedHelper.scrollDirection == ScrollHelperDirection_Horizontal )
        newOffset.x = otherOffset;
    else
        newOffset.y = otherOffset;
    [otherScrollView setContentOffset:newOffset animated:NO ];
    
}
- (void)bindScrollWithAnotherHelper:(nonnull ScrollSnapHelper *)other scrollRatioToOther:(CGFloat)ratio isDualBind:(BOOL)isDual {
    if( ABS(ratio) < 0.0001 )
        return;
    _bindedHelper = other;
    _bindedScrollRatio = ratio;
    if( isDual )
        [ other bindScrollWithAnotherHelper:self scrollRatioToOther:1/ratio isDualBind:NO ];
}

- (void)unbindScrollWithAnotherHelper_isDualUnbind:(BOOL)isDual{
    
    if( isDual && _bindedHelper )
        [ _bindedHelper unbindScrollWithAnotherHelper_isDualUnbind:NO ];
    _bindedHelper = Nil;
}

- (ScrollSnapHelper*)bindedHelper {
    return _bindedHelper;
}
@end
