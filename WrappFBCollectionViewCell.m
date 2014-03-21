//
//  WrappFBCollectionViewCell.m
//  WrappFacebook
//
//  Created by Garima on 3/20/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import "WrappFBCollectionViewCell.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@implementation WrappFBCollectionViewCell

@synthesize imageView = _imageView;
@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView.image = [UIImage imageNamed:@"friendicon"];
    }
    return self;

}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void) configureCell:(NSString *)urlString name:(NSString *)name {
    
    if (urlString) {
        NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [_imageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"fb"]];
    }
    
    _label.text = name;
}

@end
