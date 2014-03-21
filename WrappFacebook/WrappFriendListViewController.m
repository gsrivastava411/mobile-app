//
//  WrappFriendListViewController.m
//  WrappFacebook
//
//  Created by Garima on 3/18/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "WrappFriendListViewController.h"
#import "FacebookGraphApi.h"
#import "WrappFBCollectionViewCell.h"
#import "WrappFacebookFriendsListData.h"

@interface WrappFriendListViewController ()

@property (nonatomic, strong) FacebookGraphApi *facebookGraphApi;
@property (nonatomic, strong) WrappFacebookFriendsListData *wrappFacebookFriendsListData;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UICollectionView *friendsCollectionView;

@property (strong, nonatomic) NSString *searchString;
@property (strong, nonatomic) NSArray *processedFriendsArray;
@property (nonatomic, strong) NSArray *friendsList;


@end

@implementation WrappFriendListViewController

@synthesize facebookGraphApi;
@synthesize friendsList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    self.title = @"Friends";
	
    //alloc and initialize WrappFacebookFriendsListData
    self.wrappFacebookFriendsListData = [[WrappFacebookFriendsListData alloc] init];
    
	//alloc and initalize our FbGraph instance
	self.facebookGraphApi = [[FacebookGraphApi alloc] init];
    
    NSData *responseData = [self.facebookGraphApi facebookResponse:@"me/friends"];
    
    if (responseData != nil) {

        NSError *jsonError = nil;
        
        NSDictionary *friendsListData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                        options:NSJSONReadingAllowFragments
                                                                          error:&jsonError];
        self.friendsList = friendsListData[@"data"];
        self.processedFriendsArray = [self.wrappFacebookFriendsListData initializeFriendsList:self.friendsList];
    }
    
    self.friendsCollectionView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.processedFriendsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WrappFBCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FacebookNameImage" forIndexPath:indexPath];
    
    if (indexPath.row < self.processedFriendsArray.count) {
        [cell configureCell:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", self.processedFriendsArray[indexPath.row][@"id"]] name:self.processedFriendsArray[indexPath.row][@"name"]];
    }
    
    return cell;
}

#pragma mark - SearchBar delegate methods

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    if (searchBar.text && ![searchBar.text isEqualToString:@""]) {
        self.processedFriendsArray = [self.wrappFacebookFriendsListData searchFriendNames:searchBar.text];
        [self.friendsCollectionView reloadData];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    self.processedFriendsArray = [self.wrappFacebookFriendsListData searchFriendNames:[searchBar.text isEqualToString:@""] ? nil : searchBar.text];
    [self.friendsCollectionView reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.processedFriendsArray = [self.wrappFacebookFriendsListData searchFriendNames:nil];
    [self.friendsCollectionView reloadData];
}

@end
