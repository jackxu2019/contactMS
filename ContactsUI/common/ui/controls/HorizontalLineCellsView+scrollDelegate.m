//
//  HorizontalLineCellsView+scrollDelegate.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "HorizontalLineCellsView+scrollDelegate.h"

@implementation HorizontalLineCellsView (scrollDelegate)

#pragma mark --ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self.scrollSnapHelper _mustInvoke_inBeginDrag];
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)] ) {
        [ self.delegate scrollViewWillBeginDragging:scrollView ];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    
    [self.scrollSnapHelper _mustInvoke_in_scrollViewWillEndDraggingWithVelocity:velocity targetContentOffset:targetContentOffset ];
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)] ) {
        [ self.delegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset ];
    }
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [ self.scrollSnapHelper _mustInvoke_in_scrollViewDidScroll ];
    [ self onScrolling:scrollView ];
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidScroll:)] ) {
        [ self.delegate scrollViewDidScroll:scrollView ];
    }
    
}


- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidZoom:)] ) {
        [ self.delegate scrollViewDidZoom:scrollView ];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)] ) {
        [ self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate ];
    }
}



- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)] ) {
        [ self.delegate scrollViewWillBeginDecelerating:scrollView ];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [ self.scrollSnapHelper _mustInvoke_in_scrollViewDidEndDecelerating ];
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)] ) {
        [ self.delegate scrollViewDidEndDecelerating:scrollView ];
    }
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [ self.scrollSnapHelper _mustInvoke_in_scrollViewDidEndDecelerating ];
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)] ) {
        [ self.delegate scrollViewDidEndScrollingAnimation:scrollView ];
    }
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(viewForZoomingInScrollView:)] ) {
        return [ self.delegate viewForZoomingInScrollView:scrollView ];
    }
    return Nil;
}


- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)] ) {
        [ self.delegate scrollViewWillBeginZooming:scrollView withView:view ];
    }
}


- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)] ) {
        [ self.delegate scrollViewDidEndZooming:scrollView withView:view atScale:scale ];
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)] ) {
        return [ self.delegate scrollViewShouldScrollToTop:scrollView ];
    }
    return NO;
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidScrollToTop:)] ) {
        [ self.delegate scrollViewDidScrollToTop:scrollView ];
    }
}

- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(scrollViewDidChangeAdjustedContentInset:)] ) {
        [ self.delegate scrollViewDidChangeAdjustedContentInset:scrollView ];
    }
}

@end
