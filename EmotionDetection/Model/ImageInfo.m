//
//  ImageInfo.m
//  EmotionDetection
//
//  Created by Inna Pilipenko on 24/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import "ImageInfo.h"

@implementation ImageInfo
@synthesize feeling,coordinate;


- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
        if (self = [super init]) {
            
               self.feeling = dictionary[@"faceEmotion"];
            self.coordinate = [self getCoordinate: dictionary[@"faceRectangle"]];
        }
        return self;
    }

-(CGRect)getCoordinate:(NSDictionary*)data
{
    CGRect rect = CGRectZero;
    if(data != nil)
         rect = CGRectMake([data[@"left"] floatValue], [data[@"top"] floatValue], [data[@"width"] floatValue], [data[@"height"] floatValue]);
    return rect;
}


@end
