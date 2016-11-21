//
//  NSDictionary+CLLocation.h
//  changeLocation
//
//  Created by 刘松 on 16/10/31.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>
@interface NSDictionary (CLLocation)

//图片的GPSDictionary转化为CLLocation对象
-(CLLocation*)locationFromGPSDictionary;


@end
