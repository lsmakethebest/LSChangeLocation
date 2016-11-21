

#import "UIToast.h"

#define LSToastContentFont [UIFont systemFontOfSize:15]
#define LSToastBorder 8

#define LSToastDuration 1.5


@interface UIToast ()

@property(nonatomic, assign) BOOL isAdd;
@property(nonatomic, assign) BOOL completed;

@end
@implementation UIToast

+ (instancetype)shareInstance {
  return [[self alloc] init];
}

+ (id)allocWithZone:(struct _NSZone *)zone {
  static id instance;
  static dispatch_once_t token;
  dispatch_once(&token, ^{
    instance = [super allocWithZone:zone];
  });
  return instance;
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.numberOfLines = 0;
    self.backgroundColor =
        [UIColor colorWithRed:0.130 green:0.157 blue:0.156 alpha:0.884];
    self.font = LSToastContentFont;
    self.layer.cornerRadius = 3.0;
    self.layer.masksToBounds = YES;
    self.textColor = [UIColor whiteColor];
    self.textAlignment = NSTextAlignmentCenter;
  }
  return self;
}

- (id)initWithMessage:(NSString *)message {
  if (self) {
      CGFloat width=[UIScreen mainScreen].bounds.size.width;
    CGSize msg_size = [self stringSizeWith:message];
    CGFloat msg_x = (width - msg_size.width - 2 * LSToastBorder) / 2;
    CGFloat msg_y = width * 3 / 4;
    self.frame = CGRectMake(msg_x, msg_y, msg_size.width + 2 * LSToastBorder,
                            msg_size.height + 2 * LSToastBorder);
    self.text = message;
  }
  return self;
}

#pragma mark - message显示
+ (void)showMessage:(NSString *)message {

  UIToast *toast = [[UIToast shareInstance] initWithMessage:message];
  [[UIApplication sharedApplication].keyWindow endEditing:YES];
  UIWindow *window = [UIApplication sharedApplication].windows.firstObject;

  //不存在才添加
  if ([window.subviews containsObject:toast] && toast.completed == NO) {
    toast.isAdd = NO;
    [toast.layer removeAllAnimations];
    toast.alpha = 1;
    toast = [[UIToast shareInstance] initWithMessage:message];
    [toast show];
      [window bringSubviewToFront:toast];
  } else {
    toast.isAdd = YES;
    [toast show];
  }
}

- (void)show {

  if (self.isAdd) {
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    [window addSubview:self];
    self.alpha = 0;
    self.completed = NO;

    [UIView animateWithDuration:0.5
        animations:^{

          self.alpha = 1;
        }
        completion:^(BOOL finished) {

          [self addAnimation];
        }];
    return;
  }

  [self addAnimation];
}

- (void)addAnimation {
  //将吐司时间延长到1.5秒

  [UIView animateWithDuration:1.0
      delay:LSToastDuration
      options:UIViewAnimationOptionAllowUserInteraction
      animations:^{

        self.alpha = 0;
      }
      completion:^(BOOL finished) {
        if (self.isAdd) {
          [self removeFromSuperview];
          self.completed = YES;
        }

      }];
}

- (CGSize)stringSizeWith:(NSString *)string {
  CGSize stringSize;
    CGFloat width=[UIScreen mainScreen].bounds.size.width;
  if ([[UIDevice currentDevice].systemVersion doubleValue] < 7.0) {
    stringSize =
        [string sizeWithFont:LSToastContentFont
            constrainedToSize:CGSizeMake(width - 2 * LSToastBorder, 200)
                lineBreakMode:NSLineBreakByWordWrapping];
  } else {
    stringSize =
        [string
            boundingRectWithSize:CGSizeMake(width - 2 * LSToastBorder, 200)
                         options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{
                        NSFontAttributeName : LSToastContentFont
                      }
                         context:nil]
            .size;
  }
  return stringSize;
}
@end
