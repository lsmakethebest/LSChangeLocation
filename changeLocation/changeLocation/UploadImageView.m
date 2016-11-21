//
//  UploadImageView.m
//  kuaichengwuliu
//
//  Created by 刘松 on 16/4/30.
//  Copyright © 2016年 kuaicheng. All rights reserved.
//

#import "UploadImageView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import "UIToast.h"
@interface UploadImageView () <
    UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UIGestureRecognizerDelegate,
    UIActionSheetDelegate>

@property(nonatomic, weak) UITableView *tableView;
@property(nonatomic, strong) NSArray *contents;
@property(nonatomic, assign) int index;
@property(nonatomic,strong)NSMutableDictionary* mediaInfo;//当前照片的mediaInfo

@property(nonatomic,strong) UIImage *image;
    
    @property (nonatomic,assign) CGFloat longitude;
@property (nonatomic,assign) CGFloat latitude;
@end
@implementation UploadImageView

+ (void)showUpUploadImageViewWithBlockImage:(BlockImage)blockImage longitude:(CGFloat)longitude latitude:(CGFloat)latitude {

  UploadImageView *v = [[UploadImageView alloc] init];
    v.longitude=longitude;
    v.latitude=latitude;
  [[UIApplication sharedApplication].keyWindow addSubview:v];
  v.clickBlockImage = blockImage;
  if ([[UIDevice currentDevice].systemVersion doubleValue] >= 8.0) {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"请选择"
                         message:nil
                  preferredStyle:(UIAlertControllerStyleActionSheet)];
    UIAlertAction *action1 = [UIAlertAction
        actionWithTitle:@"相册"
                  style:(UIAlertActionStyleDefault)
                handler:^(UIAlertAction *_Nonnull action) {
                  UIImagePickerController *picker =
                      [[UIImagePickerController alloc] init];
                  picker.delegate = v;
                  picker.sourceType =
                      UIImagePickerControllerSourceTypePhotoLibrary;
                  [[UIApplication sharedApplication]
                          .keyWindow.rootViewController
                      presentViewController:picker
                                   animated:YES
                                 completion:nil];

                }];
    UIAlertAction *action2 = [UIAlertAction
        actionWithTitle:@"拍照"
                  style:(UIAlertActionStyleDefault)
                handler:^(UIAlertAction *_Nonnull action) {
                  UIImagePickerController *picker =
                      [[UIImagePickerController alloc] init];
                  picker.delegate = v;
                  picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                  [[UIApplication sharedApplication]
                          .keyWindow.rootViewController
                      presentViewController:picker
                                   animated:YES
                                 completion:nil];
                }];
    UIAlertAction *action3 =
        [UIAlertAction actionWithTitle:@"取消"
                                 style:(UIAlertActionStyleCancel)
                               handler:^(UIAlertAction *_Nonnull action) {
                                 [v removeFromSuperview];

                               }];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addAction:action3];
    [[UIApplication sharedApplication]
            .keyWindow.rootViewController presentViewController:alert
                                                       animated:YES
                                                     completion:nil];
  } else {
    UIActionSheet *sheet =
        [[UIActionSheet alloc] initWithTitle:@"请选择"
                                    delegate:v
                           cancelButtonTitle:@"取消"
                      destructiveButtonTitle:nil
                           otherButtonTitles:@"相册", @"拍照", nil];
    [sheet showInView:[UIApplication sharedApplication]
                          .keyWindow.rootViewController.view];
  }
}

- (void)actionSheet:(UIActionSheet *)actionSheet
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  UIImagePickerController *picker = [[UIImagePickerController alloc] init];
  picker.delegate = self;

  if (buttonIndex == 0) {
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [[UIApplication sharedApplication]
            .keyWindow.rootViewController presentViewController:picker
                                                       animated:YES
                                                     completion:nil];
  } else if (buttonIndex == 1) {

    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [[UIApplication sharedApplication]
            .keyWindow.rootViewController presentViewController:picker
                                                       animated:YES
                                                     completion:nil];
  } else if (buttonIndex == 2) {
    [self removeFromSuperview];
  }
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *, id> *)info {
    
    
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
     UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.image=image;
     self.mediaInfo=[NSMutableDictionary dictionaryWithDictionary:info];
    
    
//    GPS setValue:@"25.271139" forKey:kCGImagePropertyGPSLatitude];
//    [GPS setValue:@"55.30748500000004" for/
    [self  log:info];
    
//    [self write];
  [picker dismissViewControllerAnimated:YES completion:nil];

  if (!image) {
    [self removeFromSuperview];
    return;
  }
  if (self.clickBlockImage) {
    self.clickBlockImage(image);
  }
  [self removeFromSuperview];
    
}
-(void)log:(NSDictionary*)info
{
    NSLog(@"info:%@",info);
    __block NSMutableDictionary *imageMetadata = nil;
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:assetURL
             resultBlock:^(ALAsset *asset)  {
                 imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                 //控制台输出查看照片的metadata
                 NSLog(@"2222222-------%@",imageMetadata);
                 self.mediaInfo=imageMetadata;
                 [self write];
                 //GPS数据
                 NSDictionary *GPSDict=[imageMetadata objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
                 if (GPSDict!=nil) {
            
                 }
                 else{

                 }
                 
                 //EXIF数据
                 NSMutableDictionary *EXIFDictionary =[[imageMetadata objectForKey:(NSString *)kCGImagePropertyExifDictionary]mutableCopy];
                 NSString * dateTimeOriginal=[[EXIFDictionary objectForKey:(NSString*)kCGImagePropertyExifDateTimeOriginal] mutableCopy];
                 NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                 [dateFormatter setDateFormat:@"yyyy:MM:dd HH:mm:ss"];//yyyy-MM-dd HH:mm:ss
                 NSDate *date = [dateFormatter dateFromString:dateTimeOriginal];
             }
            failureBlock:^(NSError *error) {
            }];
    
}


-(void)write
{
    //获取照片元数据
    NSDictionary *dict = [_mediaInfo objectForKey:UIImagePickerControllerMediaMetadata];
    NSMutableDictionary *metadata = [NSMutableDictionary dictionaryWithDictionary:dict];
    NSLog(@"111111111111-----%@",dict);
    //将GPS数据写入图片并保存到相册
    
    NSTimeZone    *timeZone   = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateFormatter *formatter  = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"HH:mm:ss.SS"];
    
    
    
//    CGFloat longitude=54.317147;
//    CGFloat latitude=24.461780;
    CGFloat longitude=self.longitude;
    CGFloat latitude=self.latitude;
    NSString * timeStamp=[_mediaInfo objectForKey:(NSString*)kCGImagePropertyGPSTimeStamp];
    NSDate *timeDate=[formatter dateFromString:timeStamp];
    
    
    NSDictionary *gpsDict   = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble :fabs(latitude)], kCGImagePropertyGPSLatitude,
                               ((latitude >= 0) ? @"N" : @"S"), kCGImagePropertyGPSLatitudeRef,
                               [NSNumber numberWithDouble:fabs(longitude)], kCGImagePropertyGPSLongitude,
                               ((longitude >= 0) ? @"E" : @"W"), kCGImagePropertyGPSLongitudeRef,
                               [formatter stringFromDate:timeDate], kCGImagePropertyGPSTimeStamp,
                               nil];
    
    
    if (metadata&& gpsDict) {
        [metadata setValue:gpsDict forKey:(NSString*)kCGImagePropertyGPSDictionary];
    }
    [self writeCGImage:_image metadata:metadata];
}
    /*
     保存图片到相册
     */
- (void)writeCGImage:(UIImage*)image metadata:(NSDictionary *)metadata{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    ALAssetsLibraryWriteImageCompletionBlock imageWriteCompletionBlock =
    ^(NSURL *newURL, NSError *error) {
        if (error) {
            [UIToast showMessage:@"改变失败"];
            NSLog( @"Error writing image with metadata to Photo Library: %@", error );
        } else {
            [UIToast showMessage:@"改变成功"];
            NSLog( @"Wrote image with metadata to Photo Library");
        }
    };
    
    //保存相片到相册 注意:必须使用[image CGImage]不能使用强制转换: (__bridge CGImageRef)image,否则保存照片将会报错
    [library writeImageToSavedPhotosAlbum:[image CGImage]
                                 metadata:metadata
                          completionBlock:imageWriteCompletionBlock];
    
}













//+ (void)showUpUploadImageViewWithBlockImage:(BlockImage)blockImage
//{
//
//  UploadImageView *view = [[UploadImageView alloc] init];
//    view.clickBlockImage=blockImage;
//
//  UIView *window = [UIApplication sharedApplication] .keyWindow;
//
//    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]
//                                 initWithTarget:view
//                                 action:@selector(dismiss)];
//    tap.delegate=view;
//  [view addGestureRecognizer:tap];
//
//  view.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.204];
//  view.frame = window.bounds;
//    view.contents=@[@"拍照",@"从相册中选择"];
//  [window addSubview:view];
//
//  UITableView *tableView =
//      [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
//                                   style:UITableViewStylePlain];
//    tableView.layer.cornerRadius=5;
//    tableView.layer.masksToBounds=YES;
//  tableView.width = view.width * 3 / 5;
// tableView.height = view.contents.count * 44;
//  tableView.center = view.center;
//  tableView.delegate = view;
//  tableView.dataSource = view;
//  view.tableView = tableView;
//    [view addSubview:tableView];
//
//  view.alpha = 0;
//  tableView.alpha = 0;
//  [UIView animateWithDuration:0.25
//                   animations:^{
//                     view.alpha = 1;
//                     tableView.alpha = 1;
//                   }];
//}
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section {
//  return 2;
//}
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//  TipPlainCell *cell =
//      [TipPlainCell tipPlainCellWithTableView:tableView];
//    cell.textLabel.text = self.contents[indexPath.row];
//  return cell;
//}
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath
//*)indexPath
//{
//    self.alpha=0;
//    UIImagePickerController *picker=[[UIImagePickerController alloc]init];
//    picker.delegate=self;
//    if (indexPath.row==0) {
//        picker.sourceType=UIImagePickerControllerSourceTypeCamera;
//    }else{
//    picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
//    }
//
//    [[UIApplication sharedApplication].keyWindow.rootViewController
//    presentViewController:picker animated:YES completion:nil];
//
//}

//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
//{
//    [picker dismissViewControllerAnimated:YES completion:nil];
//    [self removeFromSuperview];
//}
//-(void)dealloc
//{
//    NSLog(@"dealloc");
//
//
//}
///// 消失
//-(void)dismiss
//{
//    [UIView animateWithDuration:0.25 animations:^{
//        self.alpha = 0;
//
//    }completion:^(BOOL finished) {
//        [self removeFromSuperview];
//        for (UIView *v in self.subviews) {
//            [v removeFromSuperview];
//        }
//
//    }];
//}
//#pragma mark -UIGestureRecognizerDelegate
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
//shouldReceiveTouch:(UITouch *)touch
//{
//    if ([NSStringFromClass([touch.view class])
//    isEqualToString:@"UITableViewCellContentView"]) {
//        return NO;
//    }
//    return YES;
//}
@end
