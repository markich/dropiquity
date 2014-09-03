//
//  LoginController.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DropboxSDK/DropboxSDK.h>

#import "PhotoListController.h"

@class DBRestClient;

@interface LoginController : UIViewController
{
    DBRestClient *restClient;
}

- (IBAction)didPressLinkButton:(id)sender;
- (void)didPressLink;

@property (nonatomic, strong) IBOutlet UIButton *linkButton;
@property (nonatomic, strong) PhotoListController *photoListController;

@end
