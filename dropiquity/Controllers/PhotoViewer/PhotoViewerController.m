//
//  PhotoViewerController.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "PhotoViewerController.h"

@interface PhotoViewerController ()
- (void)sharePhoto;
@end

@implementation PhotoViewerController

@synthesize photoView;
@synthesize photo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.photoView setImage:self.photo];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePhoto)];
}

- (void)sharePhoto
{
    NSString *text = @"Photo taken with MyDropiquity";
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[text, self.photo] applicationActivities:nil];

    controller.excludedActivityTypes = @[UIActivityTypePostToWeibo,
                                         UIActivityTypeMessage,
                                         UIActivityTypeMail,
                                         UIActivityTypePrint,
                                         UIActivityTypePostToTwitter,
                                         UIActivityTypeCopyToPasteboard,
                                         UIActivityTypeAssignToContact,
                                         UIActivityTypeSaveToCameraRoll,
                                         UIActivityTypeAddToReadingList,
                                         UIActivityTypePostToFlickr,
                                         UIActivityTypePostToVimeo,
                                         UIActivityTypePostToTencentWeibo,
                                         UIActivityTypeAirDrop];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
