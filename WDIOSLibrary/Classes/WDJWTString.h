//
//  WDJWTString.h
//  Pods
//
//  Created by Dhanu Saksrisathaporn on 8/10/2559 BE.
//
//

#import <Foundation/Foundation.h>

@interface WDJWTString : NSObject
+(NSString *)jwtString:(NSDictionary *)payload subject:(NSString *)subject secret:(NSString *)secret;
@end
