//
//  FishEyeView.m
//  FishEyeDemo
//
//  Created by haiwei li on 11-11-22.
//  Copyright (c) 2011年 13awan. All rights reserved.
//

#import "AhaMacDockView.h"


@interface AhaMacDockView () {
    
    NSUInteger index;
    NSInteger _eyeCount;
    
    //----------
    //鼠标最大响应距离，最小响应距离
    float m_MaxDisc;
    float m_MinDisc;
    
    //图标最大缩放比例，最小缩放比例
    float m_MaxRate;
    float m_MinRate;
    
    //图标初始大小
    float m_Width;
    float m_Height;
    float m_A;
    float m_B;
    float m_Offset;
    
    //horizontal or vertical
    BOOL horizontal;
    float m_StartY;
    float m_StartX;
}

@property (nonatomic, strong) NSMutableArray * items;
@property (nonatomic, strong) NSMutableArray * backItems;
@property (nonatomic, strong) NSMutableArray * postions;

@end



@implementation AhaMacDockView


- (void)_initWithFrame:(CGRect)frame {
    
    self.backgroundColor = [UIColor clearColor];
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self _initWithFrame:frame];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _initWithFrame:self.frame];
    }
    
    return self;
}


#pragma mark - public

- (void) configWithViews:(NSArray *)views
             withMinSize:(CGSize)_minSize
             withMaxRate:(float)_maxRate {
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;

    _eyeCount = views.count;
    
    for (int i = 0; i < _eyeCount; ++i) {
        
        UIView * backItem = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:backItem];
        [self.backItems addObject:backItem];
    }
    
    for (int i = 0; i < _eyeCount; ++i) {
        
        UIView * item = views[i];
        [self addSubview: item];
        [self.items addObject:item];
    }
    
    m_Width = _minSize.width;
    m_Height = _minSize.height;
        
    m_MaxDisc = m_Width * 3.5;
    m_MinRate = 1.0f;
    m_MinDisc = m_Width / 2;
    m_MaxRate = _maxRate;
    
    m_A = (m_MinRate - m_MaxRate)/(m_MaxDisc - m_MinDisc);
    m_B = m_MinRate - m_A * m_MaxDisc;
    
    m_Offset = ((m_A * m_Width * 0.5 + m_B) +
                (m_A * 1.5 * m_Width + m_B) +
                (m_A * 2.5 * m_Width + m_B) +
                (m_A * 3.5 * m_Width + m_B)  - 4.5)  * m_Width;
    
    [self resetPosition];
    
}


#pragma mark - helpers

- (void)resetPosition {
    
    float viewH = m_Height * _eyeCount;
    m_StartY = ( self.frame.size.height - viewH ) / 2;
    
    [UIView beginAnimations: @"FishEyeAnimation" context: NULL];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration: 0.5];
    
    for ( int i = 0; i < _eyeCount; ++i ) {
        
        UIView * item = self.items[i];
        item.frame = CGRectMake(0, m_StartY + i * m_Height, m_Width, m_Height);
        
        UIView * backItem = self.backItems[i];
        backItem.frame = CGRectMake(0, m_StartY + i * m_Height, m_Width, m_Height);
        [NSValue valueWithCGRect:CGRectMake(0, m_StartY + i * m_Height, m_Width, m_Height)];
    }
    
    [UIView commitAnimations];
    
}

- (void)calFishEyeWithPosition:(CGPoint)position
                  withAnimated:(BOOL)animated{
    
    float _disc = 0;
    float _per = 0;
    float _rate = 0;
    
    int indexTmp = -1;
    
    UIView * backItem_0 = self.backItems[0];
    UIView * backItem_1 = self.backItems[_eyeCount - 1];
    
    if(position.y < backItem_0.frame.origin.y ||
       position.y > backItem_1.frame.origin.y + backItem_1.frame.size.height) {

        [self resetPosition];
        return;
    }
    
    for (int i = 0; i < _eyeCount; ++i) {
        
        UIView * backItem = self.backItems[i];
        
        if (position.y > backItem.frame.origin.y &&
            position.y <= backItem.frame.origin.y + m_Height ) {
            
            indexTmp = i;
            _per = (position.y - backItem.frame.origin.y) * m_MaxRate;
            break;
        }
    }
    
    if (indexTmp == -1) {
        
        return;
    }
    
    if (animated) {
        
        [UIView beginAnimations: @"FishEyeAnimation" context: NULL];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration: 0.3];
    }
    
    
    UIView * itemTmp = self.items[indexTmp];
    UIView * backItemTmp = self.backItems[indexTmp];
    itemTmp.frame = CGRectMake(0, position.y - _per, m_Width * m_MaxRate, m_Height * m_MaxRate);
    
    for (int i = indexTmp - 1; i >= 0; --i) {
        
        UIView * item = self.items[i];
        UIView * backItem = self.backItems[i];
        
        if (i < (indexTmp - 3)) {
            
            item.frame = CGRectMake(0, backItemTmp.center.y - m_Height * abs(i - indexTmp) - m_Offset - m_Height, m_Width, m_Height);
            
        } else {
            
            _disc = fabs(backItem.center.y - position.y );
            
            _rate = m_A * _disc + m_B;
            
            UIView * item1 = self.items[i + 1];
            item.frame = CGRectMake(0, item1.frame.origin.y - m_Height * _rate, m_Width * _rate, m_Height * _rate);
        }
    }
    
    for (int i = indexTmp + 1; i < _eyeCount; ++i) {
        
        UIView * item = self.items[i];
        UIView * backItem = self.backItems[i];
        
        if (i > indexTmp + 3) {
            
            item.frame = CGRectMake(0, backItemTmp.center.y + m_Height * abs(i - indexTmp) + m_Offset, m_Width, m_Height);
            
        } else {
            
            UIView * item1 = self.items[i - 1];
            
            _disc = fabs(backItem.center.y - position.y );
            _rate = m_A * _disc + m_B;
            item.frame = CGRectMake(0, item1.frame.origin.y + item1.frame.size.height, m_Width * _rate, m_Height * _rate);
        }
    }
    
    if (animated) {
        
        [UIView commitAnimations];
    }
    
    if (index != indexTmp && self.delegate && [self.delegate respondsToSelector: @selector(fishEyeIndex:)]) {
        
        index = indexTmp;
        [self.delegate fishEyeIndex: index];
    }
    
}


#pragma mark - touch method

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

    UITouch * _touch = [touches anyObject];
    
    CGPoint touchPoint = [_touch locationInView: self];
    
    [self calFishEyeWithPosition:touchPoint 
                    withAnimated:YES];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetPosition];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self resetPosition];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * _touch = [touches anyObject];
    
    CGPoint touchPoint = [_touch locationInView: self];   
    
    [self calFishEyeWithPosition:touchPoint 
                    withAnimated:NO];
}


#pragma mark - getters

- (NSMutableArray *)items {
    if (!_items) {
        _items = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _items;
}

- (NSMutableArray *)backItems {
    if (!_backItems) {
        _backItems = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _backItems;
}

@end
