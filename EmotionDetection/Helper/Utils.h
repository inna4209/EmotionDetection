//
//  Utils.h
//  EmotionDetection
//
//  Created by Inna Pilipenko on 24/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kBaseURL @"http://0.0.0.0:5000/"

@interface Utils : NSObject
    
+(void)showActionPhotoPickerOnController:(UIViewController*)vc camera:(void (^)(void))camera photo:(void (^)(void))photo;
+(void)showAlertControllerWithTitle: (NSString*)title message: (NSString*)message onController:(UIViewController*)vc;

+(NSString*)boundary;
@end
