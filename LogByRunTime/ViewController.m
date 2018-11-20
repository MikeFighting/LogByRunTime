//
//  ViewController.m
//  LogByRunTime
//
//  Created by Mike on 6/16/16.
//  Copyright © 2016 Mike. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Addition.h"
#import "MMAlertView.h"
#import <objc/runtime.h>
@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *logTapView;
@property (weak, nonatomic) IBOutlet UIView *logTapViewTwo;
@property (weak, nonatomic) IBOutlet UITableView *logTableView;
@property (weak, nonatomic) IBOutlet UIButton *logCommonActionButton0;
@property (weak, nonatomic) IBOutlet UIButton *logCommonActionButton1;
@property (weak, nonatomic) IBOutlet UIButton *logCommonActionButton2;
@property (weak, nonatomic) IBOutlet UIButton *logCommonActionButton3;
@property (nonatomic, strong) NSArray *logCellTitleArray;
// 为埋点所做的标记
@property (nonatomic, copy) NSString *logTapCondation;
@property (nonatomic, copy) NSString *someModelId;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *tapGestureOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [self.logTapViewTwo addGestureRecognizer:tapGestureOne];
    
    UITapGestureRecognizer *tapGestureTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapActionByCondition)];
    [self.logTapView addGestureRecognizer:tapGestureTwo];
    
    self.logCommonActionButton0.zhLogTitle = @"bt0id";
    self.logCommonActionButton1.zhLogTitle = @"bt1id";
    self.logCommonActionButton2.zhLogTitle = @"bt2id";
    self.logCommonActionButton3.zhLogTitle = @"bt3id";
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showTheResult:) name:@"showLogResult" object:nil];
    
    const char *typeCodingTry = method_getTypeEncoding(class_getInstanceMethod([self class], @selector(tableView:didSelectRowAtIndexPath:)));
    NSLog(@"%s",typeCodingTry);
    

}

- (void)showTheResult:(NSNotification *)notification {

    NSMutableString *alertString = [NSMutableString string];
    NSDictionary *logInfoDic = notification.object;
    NSArray *keysArray = logInfoDic.allKeys;
    for (NSString *keyString in keysArray) {
        
        NSString *keyValueString = [NSString stringWithFormat:@"%@:%@",keyString,logInfoDic[keyString]];
        [alertString appendString:keyValueString];
        
    }
    
    MMAlertView *alertView = [[MMAlertView alloc]initWithConfirmTitle:@"埋点数据" detail:alertString];
    [alertView show];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.logCellTitleArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"logCell"];
    if (!cell) {
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"logCell"];
        
    }
    cell.textLabel.text = self.logCellTitleArray[indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    // 这里上传modelID，上传字段是"s1"
    self.someModelId = [NSString stringWithFormat:@"modelId%ld",indexPath.row];
    
    
}

#pragma mark - tapAction
- (void)tapAction:(UITapGestureRecognizer *)tapGesture{

    NSLog(@"无条件,埋点上传");
    self.tapTag = @"tapTagString";
    
}

// 这里面可能有很多的判断
- (void)tapActionByCondition{

    BOOL isTrue = YES;
    if (isTrue) {
        
        if (YES) {
            
            if (YES) {
                
                NSLog(@"有条件,埋点上传");
                self.logTapCondation = @"1";
            }
        }
    }else{
    
             self.logTapCondation = @"0";
    }
    
}

#pragma mark - buttonAction

- (IBAction)leftButtonControlAction:(UIButton *)sender {
    
    
}

- (IBAction)rightButtonControlAction:(UIButton *)sender {
    
}

- (IBAction)commonButtonControlAction:(UIButton *)sender {
    
    
}

#pragma mark - setter and getter
- (NSArray *)logCellTitleArray{

    if (!_logCellTitleArray) {
        
        _logCellTitleArray = @[@"logCell0",@"logCell1",@"logCell2",@"logCell3"];
        
    }
    
    return _logCellTitleArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
