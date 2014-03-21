//
//  WrappFBCollectionViewCell.h
//  WrappFacebook
//
//  Created by Garima on 3/20/14.
//  Copyright (c) 2014 Test. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WrappFBCollectionViewCell : UICollectionViewCell

- (void)configureCell:(NSString *)urlString name:(NSString *)nameString;

@property (nonatomic, weak) IBOutlet UIImageView*imageView;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end
