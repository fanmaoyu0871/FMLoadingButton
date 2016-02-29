//
//  FMLoadingButton.m
//  FMLoadingButton
//
//  Created by 范茂羽 on 16/2/22.
//  Copyright © 2016年 范茂羽. All rights reserved.
//

#import "FMLoadingButton.h"

@interface FMLoadingButton ()
{
    CGFloat _defaultWidth;
    CGFloat _defaultHeight;
}

@property (nonatomic, strong)CAShapeLayer *loadingLayer;

@property (nonatomic, strong)UIButton *loadingBtn;

@property (nonatomic, strong)UIView *bgView;

@end

@implementation FMLoadingButton

-(CAShapeLayer *)loadingLayer
{
    if(_loadingLayer == nil)
    {
        _loadingLayer = [CAShapeLayer layer];
        _loadingLayer.lineWidth = 5.0f;
        _loadingLayer.strokeColor = [UIColor purpleColor].CGColor;
        _loadingLayer.fillColor = nil;
        _loadingLayer.strokeStart = .0f;
        _loadingLayer.strokeEnd = .0f;
    }
    
    return _loadingLayer;
}

-(void)layoutSubviews
{
    self.bgView.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor greenColor];
        
        //loading layer
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame))];
        self.bgView.userInteractionEnabled = NO;
        self.bgView.hidden = YES;
        [self addSubview:self.bgView];
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bgView.bounds];
        self.loadingLayer.path = path.CGPath;
        self.loadingLayer.frame = self.bgView.bounds;
        [self.bgView.layer addSublayer:self.loadingLayer];
        
        //origin btn
        _loadingBtn = [[UIButton alloc]initWithFrame:self.bounds];
        [_loadingBtn setImage:[UIImage imageNamed:@"logo_"] forState:UIControlStateNormal];
        _loadingBtn.userInteractionEnabled = NO;
        _loadingBtn.backgroundColor = [UIColor greenColor];
        [self addSubview:_loadingBtn];
        
        [self addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];

        
        _defaultWidth = CGRectGetWidth(frame);
        _defaultHeight = CGRectGetHeight(frame);
        
    }
    
    return self;
}

-(void)btnAction
{
    [self setIsLoading:!self.isLoading];
}

-(void)setIsLoading:(BOOL)isLoading
{
    _isLoading = isLoading;
    _isLoading?[self startLoading]:[self stopLoading];
}

#pragma mark - Private Method
-(void)startLoading
{
    CABasicAnimation *cornerAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerAnim.fromValue = @(0);
    cornerAnim.toValue = @(CGRectGetHeight(self.frame)/2.0f);
    cornerAnim.duration = 0.2f;
    cornerAnim.removedOnCompletion = NO;
    cornerAnim.fillMode = kCAFillModeForwards;
    [self.layer addAnimation:cornerAnim forKey:@"cornerAnim"];
    
    [UIView animateWithDuration:0.3f delay:.0f usingSpringWithDamping:0.6f initialSpringVelocity:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.hidden = NO;
        self.bounds = CGRectMake(0, 0, _defaultHeight, _defaultHeight);
        self.loadingBtn.transform = CGAffineTransformMakeScale(0, 0);
        self.loadingBtn.alpha = 0;
    } completion:^(BOOL finished) {
        self.loadingBtn.hidden = YES;
        [self startRotatingAnimation];
    }];
    
}

-(void)stopLoading
{
    [self.bgView.layer removeAllAnimations];
    self.bgView.hidden = YES;
    self.loadingBtn.hidden = NO;
    
    [UIView animateWithDuration:0.3f delay:.0f usingSpringWithDamping:0.6f initialSpringVelocity:.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bounds = CGRectMake(0, 0, _defaultWidth, _defaultHeight);
        self.loadingBtn.transform = CGAffineTransformIdentity;
        self.loadingBtn.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [self stopRotatingAnimation];
    }];
}

-(void)startRotatingAnimation
{
    
    CABasicAnimation *rotateAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotateAnim.duration = 4.0f;
    rotateAnim.repeatCount = INFINITY;
    rotateAnim.fromValue = @(0);
    rotateAnim.toValue = @(2*M_PI);
    [self.bgView.layer addAnimation:rotateAnim forKey:@"rotateAnimation"];
    
    
    //add to groupAnimation
    CABasicAnimation *headAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    headAnimation.duration = 1.0f;
    headAnimation.fromValue = @(0);
    headAnimation.toValue = @(0.25);
    
    CABasicAnimation *tailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    tailAnimation.duration = 1.0f;
    tailAnimation.fromValue = @(0);
    tailAnimation.toValue = @(1.0f);
    
    CABasicAnimation *endHeadAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    endHeadAnimation.duration = 0.5f;
    endHeadAnimation.fromValue = @(0.25f);
    endHeadAnimation.toValue = @(1.0f);
    endHeadAnimation.beginTime = 1.0f;
    
    CABasicAnimation *endTailAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    endTailAnimation.duration = 0.5f;
    endTailAnimation.fromValue = @(1.0f);
    endTailAnimation.toValue = @(1.0f);
    endTailAnimation.beginTime = 1.0f;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[headAnimation, tailAnimation, endHeadAnimation, endTailAnimation];
    groupAnimation.duration = 1.5f;
    groupAnimation.repeatCount = INFINITY;
    [self.loadingLayer addAnimation:groupAnimation forKey:@"groupAnimation"];
}

-(void)stopRotatingAnimation
{
    [self.loadingLayer removeAllAnimations];
}



@end
