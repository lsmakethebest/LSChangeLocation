
//
//  NSString+Extension.m
//  kuaichengwuliu
//
//  Created by 刘松 on 16/5/9.
//  Copyright © 2016年 kuaicheng. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)
-(NSString *)value
{
    if (self==nil||[self isEqualToString:@""]) {
        return @"";
    }else{
        return  self;
    }
}
-(NSString *)ymdDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy.MM.dd";
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.doubleValue/1000.0];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;                           

}
-(NSString *)noSecondDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy.MM.dd HH:mm";
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.doubleValue/1000.0];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
    
}
-(NSString *)date
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.doubleValue/1000.0];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
}
-(NSDate*)formatDate
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    return [formatter dateFromString:self];
    
}


-(NSString *)ymdLineString
{
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"yyyy-MM-dd";
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:self.doubleValue/1000.0];
    NSString *dateString=[formatter stringFromDate:date];
    return dateString;
}
-(NSString *)priceString
{
    NSArray *arr=[self componentsSeparatedByString:@"."];
    if (arr.count>1) {
       return  [NSString stringWithFormat:@"%.2lf", round(self.doubleValue*100)/100];
    }else{
        return  [NSString stringWithFormat:@"%@.00",self];
    }
}
-(NSString *)otherString
{
    NSArray *arr=[self componentsSeparatedByString:@"."];
    if (arr.count>1) {
        return  [NSString stringWithFormat:@"%.2lf", round(self.doubleValue*100)/100];
    }else{
        return  self;
    }
    
}
@end
