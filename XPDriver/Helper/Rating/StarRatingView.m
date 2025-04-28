//
//  StarRatingView.m
//  StarRatingDemo
//
//  Created by HengHong on 5/4/13.
//  Copyright (c) 2013 Fixel Labs Pte. Ltd. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "StarRatingView.h"


@interface StarRatingView()
@property (nonatomic) int userRating;
@property (nonatomic) int maxrating;
@property (nonatomic) int rating;
@property (nonatomic) BOOL animated;
@property (nonatomic) float kLabelAllowance;
@property (nonatomic,strong) NSTimer* timer;
@property (nonatomic,strong) UILabel* label;
@property (nonatomic,strong) CALayer* tintLayer;

@end

@implementation StarRatingView
@synthesize timer;
@synthesize kLabelAllowance;
@synthesize tintLayer;
- (id)initWithFrame:(CGRect)frame andRating:(int)rating withLabel:(BOOL)label animated:(BOOL)animated
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        
        _maxrating = rating;
        self.animated = animated;
        
        
        if (label) {
            self.kLabelAllowance = 40.0f;
            self.label = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-kLabelAllowanceSize , 0,kLabelAllowanceSize, frame.size.height)];
            
            self.label.font = [UIFont systemFontOfSize:14.0f];
            self.label.text = [NSString stringWithFormat:@"%d%%",rating];
            self.label.textAlignment = NSTextAlignmentRight;
            self.label.textColor = [UIColor whiteColor];
            self.label.backgroundColor = [UIColor clearColor];
            //[self addSubview:self.label];
        }else{
            self.kLabelAllowance = 0.0f;
        }
        
        
        
        CGRect newrect = CGRectMake(0, 0, self.bounds.size.width-self.kLabelAllowance, self.bounds.size.height);
        
        
        CALayer* starBackground = [CALayer layer];
        starBackground.contents = (__bridge id)([UIImage imageNamed:@"star_fill"].CGImage);
        starBackground.frame = newrect;
        [self.layer addSublayer:starBackground];
        
        tintLayer = [CALayer layer];
        tintLayer.frame = CGRectMake(0, 0, 0, self.bounds.size.height);
        if (self.userRating >=20.0f) {
            [tintLayer setBackgroundColor:RATING_COLOR.CGColor];
        }else{
            [tintLayer setBackgroundColor:RATING_COLOR.CGColor];
        }
        
        [self.layer addSublayer:tintLayer];
        CALayer* starMask = [CALayer layer];
        starMask.contents = (__bridge id)([UIImage imageNamed:@"star_fill"].CGImage);
        starMask.frame = newrect;
        [self.layer addSublayer:starMask];
        tintLayer.mask = starMask;
        
        
        if (self.animated) {
            _rating = 0;
            timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(increaseRating) userInfo:nil repeats:YES];
            [self performSelector:@selector(ratingDidChange) withObject:nil afterDelay:0.1];
        }else{
            _rating = _maxrating;
            ////NSLog(@"setting rating");
        }
    }
    return self;
}


-(void)increaseRating{
    if (_rating<_maxrating) {
        _rating = _rating + 1;
        
        if (self.label) {
            if (self.rating >100)
            {
                self.rating = 100;
            }
            self.label.text = [NSString stringWithFormat:@"%d%%",self.rating];
        }
    }else{
        [timer invalidate];
    }
}


-(void)ratingDidChange{
    if (self.userRating < 20.0f) {
        [self.tintLayer setBackgroundColor:[UIColor appBlueColor].CGColor];
        float barWitdhPercentage = (_maxrating/100.0f) *  (self.bounds.size.width);
        self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
    }else{
        [self.tintLayer setBackgroundColor:RATING_COLOR.CGColor];
        float barWitdhPercentage = (_rating/100.0f) *  (self.bounds.size.width);
        self.tintLayer.frame = CGRectMake(0, 0, barWitdhPercentage, self.frame.size.height);
    }
    
}



@end
