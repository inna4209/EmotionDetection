//
//  Utils.m
//  EmotionDetection
//
//  Created by Inna Pilipenko on 24/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import "Utils.h"

@implementation Utils

#pragma mark - AlertController
+(void)showActionPhotoPickerOnController:(UIViewController*)vc camera:(void (^)(void))camera photo:(void (^)(void))photo {
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle: @"Select source" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        [actionSheet addAction:[UIAlertAction actionWithTitle: @"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {  }]];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [actionSheet addAction:[UIAlertAction actionWithTitle: @"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                    { camera(); }]];
        }
        
        [actionSheet addAction:[UIAlertAction actionWithTitle: @"Photo library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action)
                                {  photo();  }]];
        
        [vc presentViewController: actionSheet animated: YES completion: nil];
}
    
+(void)showAlertControllerWithTitle: (NSString*)title message: (NSString*)message onController:(UIViewController*)vc
    {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle: title
                                              message:  message
                                              preferredStyle: UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle: @"OK"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   { }];
        
        [alertController addAction: okAction];
        [vc presentViewController: alertController animated: YES completion: nil];
    }

#pragma mark - for Request
+(NSString*)boundary
{
    return [[NSUUID UUID] UUIDString];
}
@end
