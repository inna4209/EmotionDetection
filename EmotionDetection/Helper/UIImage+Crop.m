//
//  Crop.m
//  EmotionDetection
//
//  Created by Inna Pilipenko on 26/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

+ (UIImage *)croppImage:(UIImage *)imageToCrop toRect:(CGRect)rect
{
    if(CGRectEqualToRect(rect, CGRectZero)) return imageToCrop;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], rect);
    UIImage *cropped = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return cropped;
}
@end
