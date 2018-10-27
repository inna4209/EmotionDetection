//
//  Crop.h
//  EmotionDetection
//
//  Created by Inna Pilipenko on 26/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Crop)

+ (UIImage *)croppImage:(UIImage *)imageToCrop toRect:(CGRect)rect;
@end
