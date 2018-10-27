//
//  ImageInfo.h
//  EmotionDetection
//
//  Created by Inna Pilipenko on 24/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ImageInfo : NSObject
    {
        NSString* feeling;
        CGRect coordinate;
    }
    @property (nonatomic, strong) NSString *feeling;
    @property (nonatomic, assign) CGRect coordinate;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
