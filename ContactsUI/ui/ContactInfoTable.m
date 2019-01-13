//
//  ContactInfoTable.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/12.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "ContactInfoTable.h"
#import "GlobalHeader.h"

#define REUSE_CELL_ID   @"ctIVC"
@implementation ContactInfoTable

- (void)privateInitContactInfoTable {
    [self registerClass:[ ContactInfoTableCell class ] forCellReuseIdentifier:REUSE_CELL_ID ];
    self.dataSource = self;
    self.delegate = self;
    _snapHelper = [ ScrollSnapHelper new ];
    [ _snapHelper attachScrollView:self ];
    _snapHelper.snapOn = YES;
    _snapHelper.scrollDirection = ScrollHelperDirection_Vertical;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [ self privateInitContactInfoTable ];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [ self privateInitContactInfoTable ];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [ self privateInitContactInfoTable ];
    }
    return self;
}


- (void)layoutInView:(UIView*)view below:(nonnull UIView *)bView gap:(CGFloat)gap{

    [ self setTranslatesAutoresizingMaskIntoConstraints:NO ];
    NSLayoutConstraint *viewLeftConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                          attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:view
                                                                          attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
    NSLayoutConstraint *viewRightConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                           attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:view
                                                                           attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
    
    NSLayoutConstraint *viewTopConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:bView
                                                                         attribute:NSLayoutAttributeBottom multiplier:1 constant:gap];
    NSLayoutConstraint *viewBtmConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                         attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:view
                                                                         attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    
    
    [view addConstraints:@[viewLeftConstraint,viewTopConstraint,viewRightConstraint,viewBtmConstraint ] ] ;
}


- (void)refreshCellContentAtIndex:(NSInteger)index {
    ContactInfoTableCell* cell = [ self cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index  inSection:0  ] ];
    if( cell && !( cell.hidden ) ) {
        if( _dataSourceArray.count > index ) {
            [ cell setContentWith:_dataSourceArray[ index ] ];
        }
    }
}


#pragma mark -- implements tableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSourceArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactInfoTableCell* cell = (ContactInfoTableCell*)[ tableView dequeueReusableCellWithIdentifier:REUSE_CELL_ID ];
    if( _dataSourceArray.count > indexPath.row ) {
        [ cell setContentWith:_dataSourceArray[ indexPath.row ] ];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat cellSize = _cellHeight;
    if( cellSize < 1 )
        cellSize = self.bounds.size.height;
    _snapHelper.snapUnitLengthForOffset = cellSize;
    return cellSize;
}


#pragma mark -- implements scroll view delegate for snapHelper

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_snapHelper _mustInvoke_inBeginDrag];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [_snapHelper _mustInvoke_in_scrollViewWillEndDraggingWithVelocity:velocity targetContentOffset:targetContentOffset ];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [ _snapHelper _mustInvoke_in_scrollViewDidScroll ];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [ _snapHelper _mustInvoke_in_scrollViewDidEndDecelerating ];
}


- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [ _snapHelper _mustInvoke_in_scrollViewDidEndDecelerating ];
}
@end



@implementation ContactInfoTableCell

- (void)privateInitContactInfoTableCell {
    if( _firstNameLabel )
        return;

    CGFloat     topMargin = 5;
    CGFloat     hMargin = 19;
    UIFont*     firstNameFont = [ UIFont systemFontOfSize:20 weight:UIFontWeightSemibold ];
    UIFont*     lastNameFont = [ UIFont systemFontOfSize:20 weight:UIFontWeightLight ];
    UIFont*     textFont = [ UIFont systemFontOfSize:14 weight:UIFontWeightLight ];
    UIFont*     titleFont = [ UIFont systemFontOfSize:14 weight:UIFontWeightSemibold ];
    UIColor*    textColor = [ UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1 ];
    UIView* nameView = [ UIView new ];
    [self.contentView addSubview:nameView];
    _firstNameLabel = [ UILabel new ];
    [ nameView addSubview:_firstNameLabel ];
    _lastNameLabel = [ UILabel new ];
    [ nameView addSubview:_lastNameLabel ];
    
    UILabel* firstN = _firstNameLabel;
    UILabel* lastN = _lastNameLabel;
    self.translatesAutoresizingMaskIntoConstraints = NO;
    firstN.translatesAutoresizingMaskIntoConstraints = NO;
    lastN.translatesAutoresizingMaskIntoConstraints = NO;
    nameView.translatesAutoresizingMaskIntoConstraints = NO;


    NSArray* constraintH = [ NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[firstN]-5-[lastN]-0-|" options:0 metrics:nil views: NSDictionaryOfVariableBindings( firstN,lastN )];
    NSArray* constraintV = [ NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[firstN]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views: NSDictionaryOfVariableBindings( firstN )];
    [ nameView addConstraints:constraintH ];
    [ nameView addConstraints:constraintV ];
    constraintV = [ NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[lastN]-0-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views: NSDictionaryOfVariableBindings( lastN )];
    [ nameView addConstraints:constraintV ];
    
    [nameView addConstraint:[NSLayoutConstraint constraintWithItem:nameView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:firstN attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0] ];
    [nameView addConstraint:[NSLayoutConstraint constraintWithItem:nameView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:lastN attribute:NSLayoutAttributeRight multiplier:1.0 constant:0] ];
    [nameView addConstraint:[NSLayoutConstraint constraintWithItem:nameView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:firstN attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0] ];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:nameView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:topMargin] ];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:nameView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0] ];
    
    _titleLabel = [ UILabel new ];
    [self.contentView addSubview:_titleLabel];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:nameView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0] ];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:nameView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5] ];
    
    _introTitleLabel = [ UILabel new ];
    [self.contentView addSubview:_introTitleLabel];
    _introTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_introTitleLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:hMargin] ];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_introTitleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_titleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:33] ];
    
    _introTextView = [ UITextView new ];
    [self.contentView addSubview:_introTextView];
    _introTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_introTextView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:hMargin] ];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_introTextView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_introTitleLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:5] ];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_introTextView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-hMargin] ];
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_introTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0] ];
    
    
    firstN.font = firstNameFont;
    lastN.font = lastNameFont;
    firstN.textColor = [ UIColor blackColor ];
    lastN.textColor = [ UIColor blackColor ];
    _titleLabel.font = textFont;
    _titleLabel.textColor = textColor;
    _introTitleLabel.font = titleFont;
    _introTitleLabel.textColor = [ UIColor blackColor ];
    _introTextView.font = textFont;
    _introTextView.textColor = textColor;
    _introTextView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0 );
    _introTextView.textContainer.lineFragmentPadding = 0;
    _introTextView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0  );
    _introTextView.editable = NO;
    
}

- (void)didMoveToSuperview {
    
}
- (instancetype)init {
    self = [super init];
    if (self) {
        [ self privateInitContactInfoTableCell ];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if( self = [ super initWithStyle:style reuseIdentifier:reuseIdentifier ] ) {
        [self privateInitContactInfoTableCell ];
    }
    return self;
}


- (void)setContentWith:(ContactModel *)contactModel {
    _firstNameLabel.text = contactModel.first_name;
    _lastNameLabel.text = contactModel.last_name;
    _titleLabel.text = contactModel.title;
    _introTitleLabel.text = STR( @"AboutMe" );
    _introTextView.text = contactModel.introduction;
    
}

@end
