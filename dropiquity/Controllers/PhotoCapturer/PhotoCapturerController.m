//
//  PhotoCapturerController.m
//  dropiquity
//
//  Created by Marcos Jesús Vivar on 9/3/14.
//  Copyright (c) 2014 DevSpark. All rights reserved.
//

#import "PhotoCapturerController.h"

@interface PhotoCapturerController ()
- (void)initiateLocationManager;
- (UIImagePickerController *)initiateImagePicker;
- (void)uploadPhotoToDropbox;
@end

@implementation PhotoCapturerController

@synthesize locationManager;
@synthesize startLocation;

@synthesize photo;

#pragma mark -
#pragma mark Instantiation

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(popController)];
    
    [self initiateLocationManager];
    
    UIImagePickerController * imagePicker = [self initiateImagePicker];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)initiateLocationManager
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    self.startLocation = nil;
}

- (UIImagePickerController *)initiateImagePicker
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    [imagePicker setDelegate:self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [imagePicker setShowsCameraControls:YES];
    }
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    else
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [imagePicker setAllowsEditing:YES];
    
    return imagePicker;
}

#pragma mark -
#pragma mark IBAction Methods

- (IBAction)uploadDidPressed:(id)sender
{
    [self.uploadButton setEnabled:NO];
    
    [SVProgressHUD showWithStatus:@"Uploading your photo..." maskType:SVProgressHUDMaskTypeGradient];
    
    [self uploadPhotoToDropbox];
}

#pragma mark -
#pragma mark EXIFGPS

- (void)saveImage:(UIImage *)imageToSave withInfo:(NSDictionary *)info
{
    // Get the image metadata (EXIF & TIFF)
    NSMutableDictionary * imageMetadata = [[info objectForKey:UIImagePickerControllerMediaMetadata] mutableCopy];
    
    CLLocation * location = self.startLocation;
    
    if (location)
    {
        [imageMetadata setObject:[self gpsDictionaryForLocation:location] forKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
    
    // Get the assets library
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    // create a completion block for when we process the image
    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock = ^(NSURL *newURL, NSError *error)
    {
        if (error)
        {
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        }
        else
        {
            NSLog( @"Wrote image %@ with metadata %@ to Photo Library",newURL,imageMetadata);
            self.photoURL = newURL;
        }
    };
    
    // Save the new image to the Camera Roll, using the completion block defined just above
    [library writeImageToSavedPhotosAlbum:[imageToSave CGImage]
                                 metadata:imageMetadata
                          completionBlock:imageWriteCompletionBlock];
}

- (NSDictionary *)gpsDictionaryForLocation:(CLLocation *)location
{
    CLLocationDegrees exifLatitude  = location.coordinate.latitude;
    CLLocationDegrees exifLongitude = location.coordinate.longitude;
    
    NSString * latitudeReference;
    NSString * longitudeReference;
    if (exifLatitude < 0.0)
    {
        exifLatitude = exifLatitude * -1.0f;
        latitudeReference = @"S";
    }
    else
    {
        latitudeReference = @"N";
    }
    
    if (exifLongitude < 0.0)
    {
        exifLongitude = exifLongitude * -1.0f;
        longitudeReference = @"W";
    }
    else
    {
        longitudeReference = @"E";
    }
    
    NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] init];
    
    [locationDictionary setObject:location.timestamp forKey:(NSString *)kCGImagePropertyGPSTimeStamp];
    [locationDictionary setObject:latitudeReference forKey:(NSString *)kCGImagePropertyGPSLatitudeRef];
    [locationDictionary setObject:[NSNumber numberWithFloat:exifLatitude] forKey:(NSString *)kCGImagePropertyGPSLatitude];
    [locationDictionary setObject:longitudeReference forKey:(NSString *)kCGImagePropertyGPSLongitudeRef];
    [locationDictionary setObject:[NSNumber numberWithFloat:exifLongitude] forKey:(NSString *)kCGImagePropertyGPSLongitude];
    [locationDictionary setObject:[NSNumber numberWithFloat:location.horizontalAccuracy] forKey:(NSString *)kCGImagePropertyGPSDOP];
    [locationDictionary setObject:[NSNumber numberWithFloat:location.altitude] forKey:(NSString *)kCGImagePropertyGPSAltitude];
    
    return locationDictionary;
}

#pragma mark -
#pragma mark Private Methods

- (void)dismissController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)popController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)uploadPhotoToDropbox
{
    NSString *filename = [NSString stringWithFormat:@"photo_%@.png",[NSDate date]];
    NSString *localDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *localPath = [localDir stringByAppendingPathComponent:filename];
    
	NSData *photoData = [NSData dataWithData:UIImagePNGRepresentation(self.photo)];
	[photoData writeToFile:localPath atomically:YES];
    
    //NSString * photoNewURL = [self.photoURL absoluteString];
    
    // Upload file to Dropbox
    NSString *destDir = @"/Photos";
    
    [self.restClient uploadFile:filename toPath:destDir withParentRev:nil fromPath:localPath];
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
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = (!info[UIImagePickerControllerEditedImage]) ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    
    //[self saveImage:image withInfo:info];
    
    self.photo = image;
    
    [self.photoView setImage:self.photo];
    
    [self dismissController];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissController];
    
    [self popController];
}

#pragma mark -
#pragma mark CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (self.startLocation == nil)
        self.startLocation = newLocation;
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to update location due to: %@", [error localizedDescription]);
}

#pragma mark -
#pragma mark DBRestClientDelegate

- (void)restClient:(DBRestClient *)client uploadedFile:(NSString *)destPath from:(NSString *)srcPath metadata:(DBMetadata *)metadata
{
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    
    [SVProgressHUD showSuccessWithStatus:@"Your photo was successfully uploaded."];
    
    [self popController];
}

- (void)restClient:(DBRestClient *)client uploadFileFailedWithError:(NSError *)error
{
    [SVProgressHUD showErrorWithStatus:@"There was an error uploading your photo."];
    
    [self.uploadButton setEnabled:YES];
    
    NSLog(@"File upload failed with error: %@", error);
}

#pragma mark - Memory

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
