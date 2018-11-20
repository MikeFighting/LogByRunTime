//
//  MMAlertTableView.m
//  Bidding
//
//  Created by 58 on 2016/10/27.
//  Copyright © 2016年 bj.58.com. All rights reserved.
//

#import "MMAlertTableView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import "Masonry.h"
@interface MMAlertTableView()
@property(nonatomic,copy)NSArray * dataSource;
@property(nonatomic,retain)MMAlertTableViewConfig * config;
@property(nonatomic,copy)NSString * title;
@end
@implementation MMAlertTableView

- (instancetype) initWithTableViewWithTitle:(NSString *)title DataSource:(NSArray<NSString *>*) dataSource
{

    self = [super init];
    if (self) {
        self.dataSource = dataSource;
        self.title = title;
        self.config = [MMAlertTableViewConfig globalConfig];
        [self configSubViews];
    }
    return self;
}


-(void)configSubViews
{
    self.layer.cornerRadius = self.config.cornerRadius;
    self.clipsToBounds = YES;
    self.backgroundColor = self.config.backgroundColor;
    self.layer.borderWidth = MM_SPLIT_WIDTH;
    self.layer.borderColor = self.config.splitColor.CGColor;
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.config.width);
    }];
    
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    
    MASViewAttribute *lastAttribute = self.mas_top;
    if (self.title.length > 0) {
        UILabel * titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lastAttribute).offset(self.config.innerMargin);
            make.left.right.equalTo(self).insets(UIEdgeInsetsMake(0, self.config.innerMargin, 0, self.config.innerMargin));
        }];
        titleLabel.textColor = self.config.titleColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont boldSystemFontOfSize:self.config.titleFontSize];
        titleLabel.numberOfLines = 0;
        titleLabel.backgroundColor = self.backgroundColor;
        titleLabel.text = self.title;
        
        lastAttribute = titleLabel.mas_bottom;
    }
    UIScrollView * scrollView = [UIScrollView new];
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute);
        make.left.right.equalTo(self);
    }];
    
    UIView * contentView = [UIView new];
    [scrollView addSubview:contentView];
    [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];

    lastAttribute = contentView.mas_top;
    for (int i = 0; i < self.dataSource.count; i++) {
        
        UILabel * rightLabel = [UILabel new];
        rightLabel.textColor = self.config.detailColor;
        rightLabel.font = [UIFont systemFontOfSize:self.config.detailFontSize];
        rightLabel.backgroundColor = self.backgroundColor;
        rightLabel.text = self.dataSource[i];
        rightLabel.numberOfLines = 0;
        rightLabel.textAlignment = NSTextAlignmentLeft;
        [contentView addSubview:rightLabel];
        // [rightLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView).offset(-self.config.innerMargin);
            make.top.equalTo(lastAttribute).offset(self.config.innerMargin/2);
            
        }];
        
        UILabel * leftLabel = [UILabel new];
        leftLabel.textColor = self.config.detailColor;
        leftLabel.font = [UIFont systemFontOfSize:self.config.detailFontSize];
        leftLabel.backgroundColor = self.backgroundColor;
        leftLabel.textAlignment = NSTextAlignmentLeft;
        leftLabel.text = [NSString stringWithFormat:@"%d.",i+1];
        [contentView addSubview: leftLabel];
        [leftLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
  

        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(rightLabel);
            make.right.equalTo(contentView.mas_left).offset(30);
            make.right.equalTo(rightLabel.mas_left).offset(-self.config.innerMargin/2);
        }];
        lastAttribute = rightLabel.mas_bottom;
    }
    
    [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute).offset(self.config.innerMargin);
    }];

    [scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(contentView).priorityLow();
        make.height.mas_lessThanOrEqualTo(self.config.maxHeight).priorityHigh();
    }];
    lastAttribute = scrollView.mas_bottom;
    
    UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lastAttribute).offset(self.config.innerMargin);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(self.config.buttonHeight);
    }];
    
    [btn setBackgroundImage:[UIImage mm_imageWithColor:self.backgroundColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage mm_imageWithColor:self.config.itemPressedColor] forState:UIControlStateHighlighted];
    [btn setTitle:self.config.defaultTextConfirm forState:UIControlStateNormal];
    [btn setTitleColor:self.config.itemHighlightColor forState:UIControlStateNormal];
    btn.layer.borderWidth = MM_SPLIT_WIDTH;
    btn.layer.borderColor = self.config.splitColor.CGColor;
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:self.config.buttonFontSize];
    
    lastAttribute = btn.mas_bottom;
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastAttribute);
    }];
}

- (void)actionButton:(UIButton*)btn
{
    [self hide];
}
@end


@interface MMAlertTableViewConfig()

@end

@implementation MMAlertTableViewConfig

+ (MMAlertTableViewConfig *)globalConfig
{
    static MMAlertTableViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [MMAlertTableViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.width          = 280.0f;
        //128 减去两个navigationbar和statusBar

        self.buttonHeight   = 50.0f;
        self.innerMargin    = 15.0f;
        self.cornerRadius   = 5.0f;
        
        self.titleFontSize  = 18.0f;
        self.detailFontSize = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleColor         = MMHexColor(0x333333FF);
        self.detailColor        = MMHexColor(0x333333FF);
        self.splitColor         = MMHexColor(0xCCCCCCFF);
        
        self.itemNormalColor    = MMHexColor(0x333333FF);
        self.itemHighlightColor = MMHexColor(0xE76153FF);
        self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
        
        self.defaultTextOK      = @"好";
        self.defaultTextCancel  = @"取消";
        self.defaultTextConfirm = @"确定";
        
        self.detailTextAlignment = NSTextAlignmentCenter;
        self.maxHeight      = ([UIScreen mainScreen].bounds.size.width-128)-self.buttonHeight-self.innerMargin*2-[UIFont systemFontOfSize:self.titleFontSize].lineHeight;
    }
    
    return self;
}
@end
