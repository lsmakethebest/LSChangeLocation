//
//  UploadImageView.h
//  kuaichengwuliu
//
//  Created by 刘松 on 16/4/30.
//  Copyright © 2016年 kuaicheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^BlockImage)(UIImage *newImage);

@interface UploadImageView : UIView

@property (nonatomic,copy) BlockImage clickBlockImage;

/**
*
*  @param blockImage 选择完的图片 如若没选择到或者取消 block不会回调
*/
+(void)showUpUploadImageViewWithBlockImage:(BlockImage)blockImage longitude:(CGFloat)longitude latitude:(CGFloat)latitude;

@end
