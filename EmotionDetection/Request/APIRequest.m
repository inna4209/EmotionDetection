//
//  APIRequest.m
//  EmotionDetection
//
//  Created by Inna Pilipenko on 24/10/2018.
//  Copyright © 2018 Inna. All rights reserved.
//

#import "APIRequest.h"
#import "Utils.h"

@implementation APIRequest

#pragma mark - detect face
+(void)uploadImage:(UIImage*)image withBlock:(void (^)( ImageInfo *imageInfo, BOOL success, NSString *errorMessage))block
    {
        NSData *  imageData = UIImageJPEGRepresentation(image, 1);
        NSString* boundary = [Utils boundary];
        NSData *  body = [self createBodyWithFilePathKey: @"image" imageDataKey: imageData boundary: boundary];
        
        [self sendPostRequestWithUrl: [self urlForFaceDetection] body: body boundary: boundary completion: ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error)
         {
             if(data == nil) { block(nil, false, @""); return;}//error
             
             NSDictionary *dic = [self parseData: data];
             if(dic != nil)
             {
                 ImageInfo *info = [[ImageInfo alloc] initWithDictionary: dic];
                 block (info, true, @"");
             }
             else // get error message from server
             {
                 NSString *errorString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                 if(errorString!= nil && errorString.length > 3)
                 {
                     block(nil, false, errorString);
                 }
                 else {block(nil, false, @"");}
             }
         }];
}

#pragma mark - Parse response
+(NSDictionary*)parseData:(NSData*)data
{
    NSError *error1;
    id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error1];
    
    if ( [json isKindOfClass:[NSArray class]]) {
        NSArray *array = (NSArray*)json;
        if(array.count == 0) return nil;
        return json[0];
    }
    if ( [json isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary*)json;
        if(dic == nil) return nil;
        return dic;
        }
    return nil;
}

#pragma mark - Send response
+(void)sendPostRequestWithUrl:(NSString*)url body:(NSData*)body boundary: (NSString*)boundary completion:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completion
    {
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString: url]];
        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
        [request setHTTPShouldHandleCookies:NO];
        [request setTimeoutInterval: 30];
        [request setHTTPMethod: @"POST"];
        [request setHTTPBody:body];
        
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
        [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSURLSession *session = [self defaultSession];
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){ completion(data, response, error); }];
        [task resume];
        [session finishTasksAndInvalidate];
    }

#pragma mark - Make url
+(NSString*)urlForFaceDetection
{
    return  [NSString stringWithFormat:@"%@detectFace", kBaseURL];
}

#pragma mark - make body for image form-data
+(NSData*)createBodyWithFilePathKey: (NSString*)filePathKey imageDataKey: (NSData*)imageDataKey boundary: (NSString*)boundary
    {
        // Body of the POST method
        NSMutableData * body = [NSMutableData data];
        NSString* filename = @"image.jpg";
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", filePathKey, filename] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type:image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageDataKey];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];

        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

        return body;
}



#pragma mark - session configuration
+(NSURLSession *)defaultSession
    {
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        return [NSURLSession sessionWithConfiguration: sessionConfiguration];
    }
@end
