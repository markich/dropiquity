//
//  PhotoViewerController.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Social/Social.h>

@interface PhotoViewerController : UIViewController

@property (nonatomic, strong) IBOutlet UIImageView *photoView;

@property (nonatomic, strong) UIImage *photo;

@end
