//
//  WrappFacebookFriendsListData.m
//  WrappFacebook
//
//  Created by Garima on 3/20/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "WrappFacebookFriendsListData.h"

@interface WrappFacebookFriendsListData()

@property (strong, nonatomic) NSMutableArray *friendList;

@property (strong, nonatomic) NSArray *sortedFriendsArray;

@property (strong, nonatomic) NSArray *processedFriendsArray;

@property (strong, nonatomic) NSString *searchString;
@end

@implementation WrappFacebookFriendsListData

- (instancetype)init {
    if (self = [super init]) {
        self.friendList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray*) initializeFriendsList: (NSArray*) friendsList {
    
    [self.friendList addObjectsFromArray:friendsList];
    
    self.sortedFriendsArray = [self.friendList sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES]]];
    self.processedFriendsArray = [self searchArray:self.sortedFriendsArray usingFilterString:self.searchString];
    
    return self.processedFriendsArray;
}

- (NSArray *)searchArray:(NSArray *)originalArray usingFilterString:(NSString *)searchString {
    
    if (!searchString) {
        return originalArray;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@",  searchString];
    return [originalArray filteredArrayUsingPredicate:predicate];
}

- (NSArray *)searchFriendNames:(NSString *)searchString {
    
    self.searchString = searchString;
    self.processedFriendsArray = [self searchArray:self.friendList usingFilterString:self.searchString];
    
    return self.processedFriendsArray;
}


@end
