//
//  CLLocation+GPSDictionary.h
//  changeLocation
//
//  Created by 刘松 on 16/10/31.
//  Copyright © 2016年 liusong. All rights reserved.
//


#import <CoreLocation/CoreLocation.h>
#import <ImageIO/ImageIO.h>

@interface CLLocation (GPSDictionary)

//CLLocation对象转换为图片的GPSDictionary
-(NSDictionary*)GPSDictionary;

@end
