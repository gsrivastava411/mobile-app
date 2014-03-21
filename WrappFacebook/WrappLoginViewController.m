//
//  WrappLoginViewController.m
//  WrappFacebook
//
//  Created by Garima on 3/18/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "WrappLoginViewController.h"

@interface WrappLoginViewController () {
    
    LoginStatus loginStatus;
}

@property (nonatomic, strong) WrappLoginDialog *loginDialog;

@property (weak, nonatomic) IBOutlet UILabel *loginStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) UIView *loginDialogView;

@end

@implementation WrappLoginViewController

@synthesize loginButton = _loginButton;
@synthesize loginStatusLabel = _loginStatusLabel;
@synthesize loginDialogView = _loginDialogView;


NSString *facebookAppId = @"659375407462389"; //Enter your Facebook App Id here

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
    [self refreshStatus];

}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) refreshStatus {
    
    if (loginStatus == LoginStatusStart || loginStatus == LoginStatusLoggedOut) {
        _loginStatusLabel.text = @"Not connected to Facebook";
        [_loginButton setTitle:@"Login" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
    } else if (loginStatus == LoginStatusLoggingIn) {
        _loginStatusLabel.text = @"Connecting to Facebook...";
        _loginButton.hidden = YES;
    } else if (loginStatus == LoginStatusLoggedIn) {
        _loginStatusLabel.text = @"Connected to Facebook";
        [_loginButton setTitle:@"Logout" forState:UIControlStateNormal];
        _loginButton.hidden = NO;
        [self performSegueWithIdentifier:@"ToWrappFacebookFriendList" sender:self];
    }
}

- (IBAction)facebookLogin:(id)sender {
    
    NSString *permissions = @"user_friends";
    
    if (_loginDialog == nil) {
        self.loginDialog = [[WrappLoginDialog alloc] initWithfacebookApiId:facebookAppId permissions:permissions delegate:self];
        self.loginDialogView = _loginDialog.view;
    }
    
    if (loginStatus == LoginStatusStart || loginStatus == LoginStatusLoggedOut) {
        loginStatus = LoginStatusLoggingIn;
        [_loginDialog facebookLogin];
    } else if (loginStatus == LoginStatusLoggedIn) {
        loginStatus = LoginStatusLoggedOut;
        [_loginDialog facebookLogout];
    }
    
    [self refreshStatus];
}

#pragma mark WrappLoginDialogDelegate methods

- (void)facebookAccessToken:(NSString *)facebookApiId {
        
    [[NSUserDefaults standardUserDefaults]setObject:facebookApiId forKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    loginStatus = LoginStatusLoggedIn;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self refreshStatus];
}

- (void)displayFacebookLogin {
    [self presentViewController:_loginDialog animated:YES completion:nil];
}

- (void)closeFacebookLogin {
    [self dismissViewControllerAnimated:YES completion:nil];
    loginStatus = LoginStatusLoggedOut;
    [_loginDialog facebookLogout];
    [self refreshStatus];
}

@end
