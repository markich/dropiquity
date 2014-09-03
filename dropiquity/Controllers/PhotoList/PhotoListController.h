//
//  PhotoListController.h
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <DropboxSDK/DropboxSDK.h>

@class DBRestClient;

@interface PhotoListController : UICollectionViewController <DBRestClientDelegate>

@end
