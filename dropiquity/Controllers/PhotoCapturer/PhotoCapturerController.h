//
//  PhotoCapturerController.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DropboxSDK/DropboxSDK.h>

@class DBRestClient;

@interface PhotoCapturerController : UIViewController <UIImagePickerControllerDelegate, DBRestClientDelegate>
{
    UIActivityIndicatorView * activityIndicator;
    
    BOOL working;
    DBRestClient * restClient;
}

@property (nonatomic, weak) IBOutlet UIButton *uploadButton;

@property (nonatomic, weak) IBOutlet UIImageView *photoView;

@property (nonatomic, strong) UIImage *photo;

- (IBAction)uploadDidPressed:(id)sender;

@end
