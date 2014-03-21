//
//  WrappFacebookFriendsListData.h
//  WrappFacebook
//
//  Created by Garima on 3/20/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WrappFacebookFriendsListData : NSObject


- (NSArray*) initializeFriendsList: (NSArray*) friendsList;

- (NSArray *)searchArray:(NSArray *)originalArray usingFilterString:(NSString *)searchString;

- (NSArray *)searchFriendNames:(NSString *)searchString;


@end
