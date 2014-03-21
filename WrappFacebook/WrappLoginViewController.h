//
//  WrappLoginViewController.h
//  WrappFacebook
//
//  Created by Garima on 3/18/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WrappLoginDialog.h"

typedef enum {
    LoginStatusStart,
    LoginStatusLoggingIn,
    LoginStatusLoggedIn,
    LoginStatusLoggedOut
} LoginStatus;

@interface WrappLoginViewController : UIViewController <WrappLoginDialogDelegate>

@end
