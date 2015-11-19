//
//  ViewController.m
//  AhaMacDockDemo
//
//  Created by wei on 15/11/19.
//  Copyright © 2015年 livv. All rights reserved.
//

#import "ViewController.h"
#import "AhaMacDockView.h"


@interface ViewController () <AhaMacDockDelegate>

@property (nonatomic, strong) AhaMacDockView * dockView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.jpg"]];
    [self.view addSubview:self.dockView];
    
    self.dockView.frame = CGRectMake(50, 0, 80, self.view.frame.size.height);
    
    int count = 12;
    
    NSMutableArray * nameArray = [NSMutableArray arrayWithCapacity:count];
    
    for (int i = 0; i < count; ++i) {
        
        NSString * fileName = [NSString stringWithFormat:@"eye_item_%d.png", i];
        
        UIImageView * item = [[UIImageView alloc] initWithFrame:CGRectZero];
        item = [[UIImageView alloc] initWithFrame:CGRectZero];
        item.contentMode = UIViewContentModeScaleAspectFill;
        item.image = [UIImage imageNamed:fileName];
        
        [nameArray addObject:item];
    }
    
    CGSize minSize = CGSizeMake(30, 30);
    
    self.dockView.delegate = self;
    [self.dockView configWithViews:nameArray
                       withMinSize:minSize
                       withMaxRate:2.0f];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)fishEyeIndex:(NSUInteger)index {
    NSLog(@"%ld", (long)index);
}

- (AhaMacDockView *)dockView {
    if (!_dockView) {
        _dockView = [[AhaMacDockView alloc] init];
    }
    return _dockView;
}

@end
