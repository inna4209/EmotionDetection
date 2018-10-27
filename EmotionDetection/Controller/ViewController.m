//
//  ViewController.m
//  EmotionDetection
//
//  Created by Inna Pilipenko on 24/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import "ViewController.h"
#import "Utils.h"
#import "APIRequest.h"
#import "ImageInfo.h"
#import "UIImage+Crop.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *chosenImage;
@property (weak, nonatomic) IBOutlet UILabel *feelingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;

@end

@implementation ViewController

#pragma mark - View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Buttons actions
- (IBAction)addPhotoButtonTouched:(id)sender
{
    self.feelingLabel.text = @"";
    [Utils showActionPhotoPickerOnController: self  camera: ^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate: self];
        [imagePicker setAllowsEditing: NO];
        [imagePicker setSourceType: UIImagePickerControllerSourceTypeCamera];
        
        if([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceFront])
        {
            [imagePicker setCameraDevice: UIImagePickerControllerCameraDeviceFront];
        }
        
        [self presentViewController: imagePicker animated: YES completion: nil];
    } photo:^{
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        [imagePicker setDelegate: self];
        [imagePicker setAllowsEditing: NO];
        [imagePicker setSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        [self presentViewController: imagePicker animated: YES completion: nil];
    }];
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated: YES completion: nil];
    
    if(image == nil) return;
    [self getDataForImage: image];
    self.chosenImage.image = image;
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated: YES completion: nil];
}

#pragma mark - API Requests
-(void)getDataForImage:(UIImage*)image
{
    [self.loader startAnimating];
    [APIRequest uploadImage: image withBlock: ^(ImageInfo *imageInfo, BOOL success, NSString *errorMessage)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if(success && imageInfo != nil)
             {
                 [self.loader stopAnimating];
                 UIImage *croppedImage = [UIImage croppImage: image toRect: imageInfo.coordinate];
                 self.chosenImage.image = croppedImage;
                 self.feelingLabel.text = imageInfo.feeling;
             }
             else
             {
                 [self.loader stopAnimating];
                 NSString *message = (errorMessage.length > 0) ? errorMessage : @"Error in uploading image";
                 [Utils showAlertControllerWithTitle: @"Error" message: message onController: self];
             }
         });
     }];
}
@end
