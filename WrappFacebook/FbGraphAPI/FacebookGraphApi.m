//
//  FacebookGraphApi.m
//  WrappFacebook
//
//  Created by Garima on 3/20/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "FacebookGraphApi.h"

@implementation FacebookGraphApi


- (NSData *)facebookResponse:(NSString *)action {
    
    //Extract the access token
    NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"];
 	
	NSString *url_string = [NSString stringWithFormat:@"https://graph.facebook.com/%@?", action];
	
	if (accessToken != nil) {
		//Attach the access token to the graph api url, and encode it
		url_string = [[NSString stringWithFormat:@"%@access_token=%@", url_string, accessToken]
                    stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	} else {
        //Access Token is nil, something went wrong
        return nil;
    }
	
    //Create request and send a synchronous load of the given request
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url_string]];
	
	NSError *err;
	NSURLResponse *resp;
    
    //response will be nil, if loading failed
	NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&resp error:&err];
    
    return response;
}

@end