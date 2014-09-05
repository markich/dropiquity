//
//  PhotoCapturerController.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>

#import <DropboxSDK/DropboxSDK.h>

@class DBRestClient;

@interface PhotoCapturerController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate, DBRestClientDelegate>
{
    UIActivityIndicatorView * activityIndicator;
    
    BOOL working;
    DBRestClient * restClient;
}

@property (nonatomic, strong) CLLocationManager * locationManager;
@property (nonatomic, strong) CLLocation * startLocation;

@property (nonatomic, weak) IBOutlet UIButton * uploadButton;
@property (nonatomic, weak) IBOutlet UIImageView * photoView;

@property (nonatomic, strong) UIImage * photo;
@property (nonatomic, strong) NSURL * photoURL;

- (IBAction)uploadDidPressed:(id)sender;

@end
