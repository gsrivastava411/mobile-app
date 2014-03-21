//
//  WrappLoginDialogViewController.m
//  WrappFacebook
//
//  Created by Garima on 3/18/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "WrappLoginDialog.h"

@interface WrappLoginDialog ()

@property (nonatomic, assign) id <WrappLoginDialogDelegate> delegate;
@property (nonatomic, strong) NSString *facebookApiId;
@property (nonatomic, strong) NSString *permissions;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

- (IBAction)closeButton:(id)sender;

-(void)checkFacebookAccessToken:(NSString *)urlString;
-(void)checkFacebookLoginRequired:(NSString *)urlString;


@end

@implementation WrappLoginDialog

@synthesize delegate = _delegate;
@synthesize facebookApiId = _facebookApiId;
@synthesize permissions = _permissions;

#pragma mark init

- (id)initWithfacebookApiId: (NSString *)facebookApiId permissions: (NSString *)permissions delegate: (id<WrappLoginDialogDelegate>)delegate {
    
    if ((self = [super initWithNibName:@"WrappLoginDialog" bundle:[NSBundle mainBundle]])) {
        self.facebookApiId = facebookApiId;
        self.permissions = permissions;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark login/logout

- (void) facebookLogin {
    
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"about:blank"]]];
    
    NSString *redirectUrlString = @"http://www.facebook.com/connect/login_success.html";

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/oauth/authorize?client_id=%@&redirect_uri=%@&scope=%@&type=user_agent&display=touch", _facebookApiId, redirectUrlString, _permissions]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [_webView loadRequest:request];
}

- (void) facebookLogout {
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie* cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        [cookies deleteCookie:cookie];
    }
}

#pragma mark UIWebViewDelegate routines

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *urlString = request.URL.absoluteString;
    
    [self checkFacebookAccessToken:urlString];
    
    if (self.isViewLoaded && self.view.window) {
        // viewController is visible
        return TRUE;
    }
    
    [self checkFacebookLoginRequired:urlString];
    
    return TRUE;
}

#pragma mark Helper routines

-(void)checkFacebookAccessToken:(NSString *)urlString {
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"access_token=(.*)&" options:0 error:&error];
    if (regex != nil) {
        NSTextCheckingResult *firstMatch = [regex firstMatchInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        if (firstMatch) {
            NSRange accessTokenRange = [firstMatch rangeAtIndex:1];
            NSString *accessToken = [urlString substringWithRange:accessTokenRange];
            accessToken = [accessToken stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_delegate facebookAccessToken:accessToken];
        }
    }
}

-(void)checkFacebookLoginRequired:(NSString *)urlString {
    
    if ([urlString rangeOfString:@"login.php"].location != NSNotFound && [urlString rangeOfString:@"refid"].location == NSNotFound) {
        [_delegate displayFacebookLogin];
    } else if ([urlString rangeOfString:@"user_denied"].location != NSNotFound) {
        [_delegate closeFacebookLogin];
    }
}

#pragma mark IBAction routines
- (IBAction)closeButton:(id)sender {
    
    [_delegate closeFacebookLogin];
}

@end
