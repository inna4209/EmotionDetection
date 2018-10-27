//
//  APIRequest.h
//  EmotionDetection
//
//  Created by Inna Pilipenko on 24/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ImageInfo.h"

@interface APIRequest : NSObject

    +(void)uploadImage:(UIImage*)image withBlock:(void (^)(ImageInfo *imageInfo, BOOL success, NSString *errorMessage))block;
@end
