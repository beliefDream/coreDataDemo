//
//  PersonViewCell.m
//  summaryCoreData
//
//  Created by zhs on 15/11/11.
//  Copyright (c) 2015年 zhs. All rights reserved.
//

#import "PersonViewCell.h"
#import "Masonry.h"

@implementation PersonViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView {
    self.nameLabel = [UILabel new];
    _nameLabel.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_nameLabel];
   
    
    self.ageLabel = [UILabel new];
    _ageLabel.backgroundColor = [UIColor purpleColor];
    [self.contentView addSubview:_ageLabel];
    
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(-10);
//        make.right.equalTo(_ageLabel.mas_left).offset(-10);
//        make.width.equalTo(_ageLabel);
    }];
    [_ageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_nameLabel);
        make.top.bottom.equalTo(_nameLabel);
        make.left.mas_equalTo(_nameLabel.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];

}

@end
