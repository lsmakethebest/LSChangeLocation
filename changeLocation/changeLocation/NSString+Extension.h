//
//  NSString+Extension.h
//  kuaichengwuliu
//
//  Created by 刘松 on 16/5/9.
//  Copyright © 2016年 kuaicheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

@property (nonatomic,copy,readonly) NSString *value;

@property (nonatomic,copy) NSString *date;
@property (nonatomic,copy) NSString *noSecondDate;

@property(nonatomic,strong) NSDate *formatDate;

@property (nonatomic,copy) NSString *ymdLineString;

@property (nonatomic,copy) NSString *ymdDate;

@property (nonatomic,copy) NSString *priceString;

@property (nonatomic,copy) NSString *otherString;



@end

