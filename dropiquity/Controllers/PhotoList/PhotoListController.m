//
//  PhotoListController.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "PhotoListController.h"

#import "PhotoViewerController.h"
#import "PhotoCapturerController.h"

#import "PhotoCell.h"

@interface PhotoListController ()

- (void)loadPhotos;
- (NSString *)photoPath:(NSString *)temporaryPhotoPath;
- (void)displayError;
- (void)setWorking:(BOOL)isWorking;

@property (nonatomic, strong) NSMutableArray * photoPaths;
@property (nonatomic, strong) NSString * photosHash;
@property (nonatomic, strong) NSMutableDictionary * imageCache;

@property (nonatomic, readonly) DBRestClient * restClient;

@property (nonatomic, strong) UIImage * photo;

@end

NSString *kPhotoCell = @"photoCell";

@implementation PhotoListController

@synthesize photoPaths;
@synthesize photosHash;
@synthesize imageCache;

@synthesize photo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photos";
    
    self.photoPaths = [@[] mutableCopy];
    self.photosHash = @"";
    self.imageCache = [[NSMutableDictionary alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadPhotos];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return [self.photoPaths count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCell forIndexPath:indexPath];
    
    NSString * photoPath = @"";
    NSString * localPath = @"";
    
    if ([self.photoPaths count] == 0)
    {
        NSString *msg = nil;
        
        if ([DBSession sharedSession].root == kDBRootDropbox)
        {
            msg = @"Put .jpg or .png photos in your Photos folder to use MyDropiquity!";
        }
        else
        {
            msg = @"Put .jpg or .png photos in your app's App folder to use MyDropiquity!";
        }
        
        [[[UIAlertView alloc]
          initWithTitle:@"No Photos!" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
         show];
        
        [self setWorking:NO];
    }
    else
    {
        photoPath = [self.photoPaths objectAtIndex:indexPath.row];
        localPath = [self photoPath:[NSString stringWithFormat:@"photo_%ld",indexPath.row]];
        
        if (![self.imageCache objectForKey:photoPath])
        {
            [self.restClient loadThumbnail:photoPath ofSize:@"iphone_bestfit" intoPath:localPath];
        }
        else
        {}
    }
    
    cell.label.text = photoPath;
    cell.image.image = ([self.imageCache objectForKey:photoPath]) ? [UIImage imageWithContentsOfFile:localPath] : [UIImage imageNamed:@"dropbox-placeholder.png"];
    
    [self.imageCache setObject:localPath forKey:photoPath];
    
    return cell;
}

#pragma mark -
#pragma mark UICollectionViewDelegate
 
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoCell forIndexPath:indexPath];
    
    self.photo = cell.image.image;
}

#pragma mark -
#pragma mark Private methods

- (void)loadPhotos
{
    [self setWorking:YES];
    
    [SVProgressHUD showWithStatus:@"Downloading your photos..." maskType:SVProgressHUDMaskTypeGradient];
    
    NSString *photosRoot = @"";
    
    if ([DBSession sharedSession].root == kDBRootDropbox)
    {
        photosRoot = @"/photos";
    }
    else
    {
        photosRoot = @"/";
    }
    
    [self.restClient loadMetadata:photosRoot withHash:self.photosHash];
}

- (NSString *)photoPath:(NSString *)temporaryPhotoPath
{
    return [NSTemporaryDirectory() stringByAppendingPathComponent:temporaryPhotoPath];
}

-  (void)displayError
{
    [[[UIAlertView alloc]
      initWithTitle:@"Error Loading Photo" message:@"There was an error loading your photo."
      delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil]
     show];
}

- (void)setWorking:(BOOL)isWorking
{
    if (working == isWorking) return;
    working = isWorking;
    
    if (working)
    {
        [activityIndicator startAnimating];
    }
    else
    {
        [activityIndicator stopAnimating];
    }
}

- (DBRestClient*)restClient
{
    if (restClient == nil)
    {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        restClient.delegate = self;
    }
    
    return restClient;
}

#pragma mark -
#pragma mark DBRestClientDelegate

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata
{
    self.photosHash = metadata.hash;
    
    NSArray * validExtensions = [NSArray arrayWithObjects:@"jpg", @"jpeg", @"png", nil];
    
    NSMutableArray * newPhotoPaths = [@[] mutableCopy];
    
    for (DBMetadata * child in metadata.contents)
    {
        NSString * extension = [[child.path pathExtension] lowercaseString];
        
        if (!child.isDirectory && [validExtensions indexOfObject:extension] != NSNotFound)
        {
            [newPhotoPaths addObject:child.path];
        }
    }
    
    self.photoPaths = newPhotoPaths;
    
    [SVProgressHUD showSuccessWithStatus:@"Ready"];
    
    [self.collectionView reloadData];
}

- (void)restClient:(DBRestClient *)client metadataUnchangedAtPath:(NSString *)path
{
    NSLog(@"metadataUnchangedAtPath: %@", path);
    
    [SVProgressHUD showSuccessWithStatus:@"Ready"];
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
    NSLog(@"restClient:loadMetadataFailedWithError: %@", [error localizedDescription]);
    
    [SVProgressHUD showErrorWithStatus:@"There was an error uploading your photo."];
    
    [self setWorking:NO];
}

- (void)restClient:(DBRestClient *)client loadedThumbnail:(NSString *)destPath
{
    [self setWorking:NO];
    
    NSLog(@"SUCCESS! I LIKE... HIGH FIVE!");
    
    if ([self.photoPaths count] == [self.imageCache count])
    {
        [self.collectionView reloadData];
    }
}

- (void)restClient:(DBRestClient *)client loadThumbnailFailedWithError:(NSError *)error
{
    [self setWorking:NO];
    
    NSLog(@"%@", [error localizedDescription]);
}

#pragma mark -
#pragma mark Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"photoViewSegue"])
    {
        PhotoViewerController *destinationController = (PhotoViewerController *)segue.destinationViewController;
        
        if ([destinationController isKindOfClass:[PhotoViewerController class]])
        {
            destinationController.photo = self.photo;
        }
    }
}

@end
