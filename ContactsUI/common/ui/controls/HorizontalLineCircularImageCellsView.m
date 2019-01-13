//
//  HorizontalLineCircularImageCellsView.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "HorizontalLineCircularImageCellsView.h"

@implementation HorizontalLineCircularImageCellsView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.circleR = 20;
        self.selectedBorderColor = [ UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1 ];
        self.selectedBorderThick = 3;
        _autoCircularImg = YES;
        _autoResizeImg = YES;
        self.cellContentViewClass = [ UIImageView class ];
    }
    return self;
}
- (void)setCircleR:(CGFloat)circleR {
    self.cellSize = CGSizeMake( circleR*2, circleR*2 );
}

- (CGFloat)circleR {
    return self.cellSize.width / 2;
}

- (void)setStyleOfImageView:(UIImageView*)imgV {

    if( _autoResizeImg )
        imgV.contentMode = UIViewContentModeScaleToFill;
    else
        imgV.contentMode = UIViewContentModeCenter;
    if( _autoCircularImg ) {
        imgV.layer.cornerRadius = self.circleR;
        imgV.clipsToBounds = YES;
    }
}

- (void)setStyleOfRingView:(CellRingView*)ringView
{
    ringView.ringShapeLayer.lineWidth = _selectedBorderThick;
    ringView.ringShapeLayer.strokeColor = _selectedBorderColor.CGColor;
    ringView.ringShapeLayer.fillColor = [ UIColor clearColor ].CGColor;
}



#pragma mark --implements HorizontalLineCellsView
_override -(void)onSettingCellViewContents:(UIView*)cellView atIndex:(NSInteger)cellIndex {
    [ super onSettingCellViewContents:cellView atIndex:cellIndex ];
    
}

_override -(void)onSelectedCell:(HorizontalLineCell*)cell atIndex:(NSInteger)cellIndex {
    [ super onSelectedCell:cell atIndex:cellIndex ];
}

_overridable -(void)onCreateNewCell:(HorizontalLineCell *)cell atIndex:(NSInteger)cellIndex {
    [super onCreateNewCell:cell atIndex:cellIndex ];
    UIImageView* imgView = (UIImageView*)(cell.contentView);
    [self setStyleOfImageView:imgView ];
    imgView.backgroundColor = [ UIColor grayColor ];
    
    CellRingView* ringView = [ CellRingView new ];
    [ ringView buildContentWithR:self.circleR andThick:_selectedBorderThick ];
    [ UIView installSubView:ringView toFillSuperView:cell.decoratorView ];
    [ self setStyleOfRingView:ringView ];
    cell.decoratorView.hidden = YES;
    cell.cellContentView.backgroundColor = [ UIColor clearColor ];
}

_override -(void)onSetSelectedAttributeOfCell:(HorizontalLineCell *)cell isSelected:(BOOL)isSel {

        cell.decoratorView.hidden = !isSel;
}
@end


@implementation CellRingView

- (instancetype)init {
    self = [super init];
    if (self) {
        _ringShapeLayer = [ CAShapeLayer new ];
        
        [ self.layer addSublayer:_ringShapeLayer ];
    }
    return self;
}

- (void)buildContentWithR:(CGFloat)r andThick:(CGFloat)thick {
    r += thick/2;
    CGRect rt = CGRectMake( -thick/2 , -thick/2 , r*2, r*2 );
    CGPathRef path = CGPathCreateWithEllipseInRect( rt , nil );
    _ringShapeLayer.path = path;
    CGPathRelease( path );
}


@end
