//
//  AppDelegate.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DropboxSDK/DropboxSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, DBSessionDelegate, DBNetworkRequestDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *relinkUserId;

@end
