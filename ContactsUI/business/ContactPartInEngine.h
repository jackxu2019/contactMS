//
//  ContactPartInEngine.h
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ContactModel.h"
NS_ASSUME_NONNULL_BEGIN

@protocol ContactPartInEngineDelegate;


@interface ContactPartInEngine : NSObject
@property(nonatomic)id<ContactPartInEngineDelegate>     delegate;
@property(nonatomic)NSMutableArray<ContactModel*>*      contactsArray;
@property(nonatomic)UIColor*        avatarImgBgColor;
- (void)loadAllContactsAsync;
@end


@protocol ContactPartInEngineDelegate <NSObject>
@optional
- (void)contactPartInEngine:(ContactPartInEngine*)contact   beginLoadWithTaskID:(NSInteger)taskId;
- (void)contactPartInEngine:(ContactPartInEngine *)contact  itemsCountReceived:(NSInteger)itemsCount;
- (void)contactPartInEngine:(ContactPartInEngine *)contact  oneItemReceived:(ContactModel*)model atIndex:(NSInteger)itemIndex;
- (void)contactPartInEngine:(ContactPartInEngine *)contact  avatarImgIsReady:(UIImage*)img  atIndex:(NSInteger)itemIndex;
- (void)contactPartInEngine:(ContactPartInEngine *)contact  endedLoadWithTaskID:(NSInteger)taskId;

@end
NS_ASSUME_NONNULL_END
