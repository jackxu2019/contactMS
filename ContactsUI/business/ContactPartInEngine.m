//
//  ContactPartInEngine.m
//  ContactsUI
//
//  Created by xu54 on 2019/1/11.
//  Copyright © 2019 xu54. All rights reserved.
//

#import "ContactPartInEngine.h"

@implementation ContactPartInEngine
{
    dispatch_queue_t    _queryQueue;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contactsArray = [ NSMutableArray new ];
        _queryQueue = dispatch_queue_create("queryQ", DISPATCH_QUEUE_SERIAL );
    }
    return self;
}

- (void)loadAllContactsAsync {
    if( self.delegate && [ self.delegate respondsToSelector:@selector(contactPartInEngine:beginLoadWithTaskID:) ] )
        [ self.delegate contactPartInEngine:self beginLoadWithTaskID:0 ];
    __weak ContactPartInEngine* weakSelf = self;
    dispatch_async( _queryQueue, ^{
        ContactPartInEngine*    sself = weakSelf;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [sself.contactsArray removeAllObjects];
        });
        
        NSData * jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"contacts" ofType:@"json"]];
        
        NSError * error = nil;
        id obj = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];

        NSInteger index = 0;
        if ([obj isKindOfClass:[NSArray class]]) {
            
            NSArray * array = (NSArray*)obj;
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                for ( NSInteger n = 0; n < array.count; n++ ) {
                    ContactModel* contact = [ ContactModel new ];
                    [sself.contactsArray addObject:contact];
                }
                if( sself.delegate && [ sself.delegate respondsToSelector:@selector(contactPartInEngine:itemsCountReceived:) ] ){
                    [ sself.delegate contactPartInEngine:sself itemsCountReceived:array.count ];
                }
            });
            
            for ( NSDictionary* dic in array ) {

                dispatch_sync(dispatch_get_main_queue(), ^{
                    [sself fillContact:sself.contactsArray[index] withDictionary:dic ];
                });

                if( sself.delegate && [ sself.delegate respondsToSelector:@selector(contactPartInEngine:oneItemReceived:atIndex:) ] ) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ sself.delegate contactPartInEngine:sself oneItemReceived:sself.contactsArray[index] atIndex:index ];
                    });
                }
                
                index++;
            }
        }
        index = 0;
        for( ContactModel* contact in sself.contactsArray ) {
            contact.avatarImg = [self loadAvatarImgWithName:contact.avatar_filename ];
            if( sself.delegate && [ sself.delegate respondsToSelector:@selector(contactPartInEngine:avatarImgIsReady:atIndex:) ] ) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ sself.delegate contactPartInEngine:sself avatarImgIsReady:contact.avatarImg atIndex:index ];
                });
            }
            index++;
        }
        

        if( sself.delegate && [ sself.delegate respondsToSelector:@selector(contactPartInEngine:endedLoadWithTaskID:) ] ) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [ sself.delegate contactPartInEngine:sself endedLoadWithTaskID:0 ];
            });
        }
    });
}

/*
 以后可以扩展为从磁盘中或者从网络中获取图片，并且对图片做圆角处理
 */
- (UIImage*)loadAvatarImgWithName:(NSString*)imgName {
    UIImage* img = [ UIImage imageNamed:imgName ];
    return img;
}

- (void)fillContact:(ContactModel*)contact  withDictionary:(NSDictionary*)dic {
    contact.avatar_filename = [dic objectForKey:@"avatar_filename"];
    contact.first_name = [dic objectForKey:@"first_name"];
    contact.introduction = [dic objectForKey:@"introduction"];
    contact.last_name = [dic objectForKey:@"last_name"];
    contact.title = [dic objectForKey:@"title"];
    
}
@end
