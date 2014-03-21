//
//  WrappLoginDialogViewController.h
//  WrappFacebook
//
//  Created by Garima on 3/18/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WrappLoginDialogDelegate

- (void)facebookAccessToken:(NSString *)facebookApiId;
- (void)displayFacebookLogin;
- (void)closeFacebookLogin;

@end

@interface WrappLoginDialog : UIViewController <UIWebViewDelegate>

- (id)initWithfacebookApiId: (NSString *)facebookApiId permissions: (NSString *)permissions delegate: (id<WrappLoginDialogDelegate>)delegate;
- (void)facebookLogin;
- (void)facebookLogout;

@end
