//
//  CustomTitleView.m
//  lhScanQCodeTest
//
//  Created by 叶一帆 on 2017/5/24.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "CustomTitleView.h"

@interface CustomTitleView ()

@property (strong, nonatomic) UIView *backView;
@property (strong, nonatomic) UIView *showView;

@property (strong, nonatomic) CALayer *maskLayer;
@property (strong, nonatomic) UIButton *lastButton;

@end

@implementation CustomTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles {
    if (self = [super initWithFrame:frame]) {
        // 布置子控件
        [self initSubviews:frame titles:titles];
    }
    return self;
}
-(void)initSubviews:(CGRect)frame titles:(NSArray <NSString *>*)titles {
    // 布置子控件
    CGRect bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _backView = [[UIView alloc]initWithFrame:bounds];
    _showView = [[UIView alloc]initWithFrame:bounds];
    [self addSubview:_backView];
    _showView.backgroundColor = [UIColor redColor];
    _showView.userInteractionEnabled = NO;
    [self addSubview:_showView];
    
    CGFloat width = frame.size.width;
    CGFloat height = frame.size.height;
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * width / titles.count, 0, width / titles.count, height);
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        if (i == 0) {
            _lastButton = button;
        }
        [_backView addSubview:button];
    }
    
    for (int i = 0; i < titles.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i * width / titles.count, 0, width / titles.count, height);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_showView addSubview:button];
    }
    
    self.maskLayer = [CALayer layer];
    self.maskLayer.frame = CGRectMake(0, 0, width / titles.count, height);
    self.maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.maskLayer.cornerRadius = height * 0.25;
    self.showView.layer.mask = self.maskLayer;
}

-(void)buttonClick:(UIButton *)sender {
    if (_lastButton == sender) {
        return;
    }    
    CGPoint position = CGPointMake(_lastButton.frame.origin.x + _lastButton.frame.size.width * 0.5, _lastButton.frame.origin.y + _lastButton.frame.size.height * 0.5);
    NSInteger num = fabs(sender.frame.origin.x - _lastButton.frame.origin.x) / sender.frame.size.width + 1;
    CGFloat x = MIN(sender.frame.origin.x, _lastButton.frame.origin.x);
    CGPoint fromPosition = CGPointMake(x + sender.frame.size.width * num * 0.5, position.y);
    CGPoint toPosition = CGPointMake(sender.frame.origin.x + sender.frame.size.width * 0.5, sender.frame.origin.y + sender.frame.size.height * 0.5);
    
    CAKeyframeAnimation *aniPos = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    aniPos.values = @[[NSValue valueWithCGPoint:CGPointMake(_lastButton.frame.origin.x + _lastButton.frame.size.width * 0.5, _lastButton.frame.origin.y + _lastButton.frame.size.height * 0.5)],[NSValue valueWithCGPoint:fromPosition],[NSValue valueWithCGPoint:toPosition]];
    
    CAKeyframeAnimation *aniBou = [CAKeyframeAnimation animationWithKeyPath:@"bounds"];
    aniBou.values = @[[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(_lastButton.frame), CGRectGetHeight(_lastButton.frame))],[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(sender.frame) * num, CGRectGetHeight(sender.frame))],[NSValue valueWithCGRect:CGRectMake(0, 0, CGRectGetWidth(sender.frame), CGRectGetHeight(sender.frame))]];
    
    CAAnimationGroup *anis = [CAAnimationGroup animation];
    anis.animations = @[aniBou,aniPos];
    anis.duration = 0.35;
    anis.removedOnCompletion = NO;
    anis.fillMode = kCAFillModeForwards;
    anis.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.maskLayer addAnimation:anis forKey:nil];
    _lastButton = sender;
}

@end
