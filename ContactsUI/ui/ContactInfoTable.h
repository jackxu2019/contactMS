//
//  ContactInfoTable.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/12.
//  Copyright © 2019 xu54. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactModel.h"
#import "ScrollSnapHelper.h"
NS_ASSUME_NONNULL_BEGIN

@interface ContactInfoTable : UITableView<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic)NSMutableArray<ContactModel*>*          dataSourceArray;
@property(nonatomic,readonly)ScrollSnapHelper*              snapHelper;
@property(nonatomic)CGFloat                                 cellHeight;

- (void)refreshCellContentAtIndex:(NSInteger)index;
- (void)layoutInView:(UIView*)view below:(UIView*)bView gap:(CGFloat)gap;

@end

@interface ContactInfoTableCell : UITableViewCell
@property(nonatomic)UILabel* firstNameLabel , *lastNameLabel;
@property(nonatomic)UILabel* titleLabel;
@property(nonatomic)UILabel* introTitleLabel;
@property(nonatomic)UITextView* introTextView;

- (void)setContentWith:(ContactModel*)contactModel;

@end

NS_ASSUME_NONNULL_END
