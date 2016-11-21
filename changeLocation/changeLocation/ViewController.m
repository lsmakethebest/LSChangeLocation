//
//  ViewController.m
//  changeLocation
//
//  Created by 刘松 on 16/10/31.
//  Copyright © 2016年 liusong. All rights reserved.
//

#import "ViewController.h"
#import "UploadImageView.h"
#import "UIToast.h"


@interface ViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *longitude;
    @property (weak, nonatomic) IBOutlet UITextField *latitude;
    
    @end

@implementation ViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];

    
}
    
    
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    

- (IBAction)change:(id)sender {
    
    if (self.longitude.text.length<=0||self.latitude.text.length<=0) {
        [UIToast showMessage:@"请输入经纬度"];
        return;
    }
    //浮点数值使用CGFloat,NSDecimalNumber对象进行处理:
    NSDecimalNumber *longitude = [[NSDecimalNumber alloc] initWithString:self.longitude.text];
    NSDecimalNumber *latitude = [[NSDecimalNumber alloc] initWithString:self.latitude.text];

    [UploadImageView showUpUploadImageViewWithBlockImage:^(UIImage *newImage) {
        
    } longitude:[longitude doubleValue ] latitude:[latitude doubleValue ]];
}
@end
