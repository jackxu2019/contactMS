//
//  ViewController.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/9.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "ContactViewController.h"
#import "AvatarsLine.h"
#import "BusinessEngine.h"
#import "ContactInfoTable.h"

@interface ContactViewController ()
@property(nonatomic)AvatarsLine*  avatarsLine ;
@property(nonatomic)ContactInfoTable* infoTable;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _avatarsLine = [ AvatarsLine new ];
    _infoTable = [ ContactInfoTable new ];
    [ self.view addSubview:_infoTable ];
    [ self.view addSubview:_avatarsLine ];
    self.navigationController.navigationBar.translucent = NO;
    [_avatarsLine layoutInView:self.view ];
    [_avatarsLine buildContents_mustInvokeAfterSetFrameSizeAndCellSpacing];
    _avatarsLine.delegate = self;
    [ _infoTable layoutInView:self.view below:_avatarsLine gap:0 ];
    [ _infoTable layoutIfNeeded ];
    _infoTable.cellHeight = _infoTable.bounds.size.height;
    [ self bindScrollOfAvatarsLineAndInfoTable ];
    defualtBusinessEngine.contact.delegate = self;
    [defualtBusinessEngine.contact loadAllContactsAsync];
    _infoTable.dataSourceArray = defualtBusinessEngine.contact.contactsArray;

    
}

- (void)bindScrollOfAvatarsLineAndInfoTable {
    CGFloat avatarLineSnapLen = _avatarsLine.scrollSnapHelper.snapUnitLengthForOffset;
    [_infoTable layoutIfNeeded];
    CGFloat infoTableSnapLen = _infoTable.cellHeight;
    CGFloat snapRatio = avatarLineSnapLen / infoTableSnapLen;
    [ _avatarsLine.scrollSnapHelper bindScrollWithAnotherHelper:_infoTable.snapHelper scrollRatioToOther:snapRatio isDualBind:YES];
}

#pragma mark --implements contacts in BusinessEngine

- (void)contactPartInEngine:(ContactPartInEngine *)contact oneItemReceived:(ContactModel *)model atIndex:(NSInteger)itemIndex {
    [ _infoTable refreshCellContentAtIndex:itemIndex ];
}

- (void)contactPartInEngine:(ContactPartInEngine *)contact itemsCountReceived:(NSInteger)itemsCount {
    _avatarsLine.cellsNumber = itemsCount;
    [ _infoTable reloadData ];
    [ _avatarsLine reloadData];
    [ _avatarsLine selectItemAtIndex:0 animated:NO scrollPosition:UICollectionViewScrollPositionNone ];
}
- (void)contactPartInEngine:(ContactPartInEngine *)contact avatarImgIsReady:(nonnull UIImage *)img atIndex:(NSInteger)itemIndex {
    [ _avatarsLine setCellImage:img atItemIndex:itemIndex ];

}


- (void)horizontalLineCellsView:(HorizontalLineCellsView *)sender setContentOfCell:(HorizontalLineCell *)cell atIndex:(NSInteger)index {
    if( defualtBusinessEngine.contact.contactsArray.count > index ) {
        ContactModel* cm = defualtBusinessEngine.contact.contactsArray[ index ];
        UIImageView* imgV = ( UIImageView* )( cell.cellContentView );
        imgV.image = cm.avatarImg;
    }
}
@end
