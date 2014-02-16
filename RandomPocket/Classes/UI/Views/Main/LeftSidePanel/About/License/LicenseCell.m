//
//  LicenseCell.m
//  RandomPocket
//
//  Created by RyoAbe on 2014/02/12.
//  Copyright (c) 2014年 RyoAbe. All rights reserved.
//

#import "LicenseCell.h"
#import "LicenseViewController.h"

@interface LicenseCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *copyrightLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation LicenseCell

- (void)setLicenseData:(NSDictionary *)LicenseData
{
    _LicenseData = LicenseData;
    self.titleLabel.text = LicenseData[TitleKey];
    self.copyrightLabel.text = LicenseData[CopyrightKey];
    self.descriptionLabel.text = LicenseData[DescriptionKey];
}

- (CGFloat)cellHeight
{
    if(self.LicenseData == nil || self.LicenseData.count == 0){
        NSAssert(NO, nil);
        return 0;
    }
    NSAttributedString *titleAttString = [[NSAttributedString alloc] initWithString:self.LicenseData[TitleKey]
                                                                         attributes:@{NSFontAttributeName:self.titleLabel.font}];
    CGSize titleSize = [titleAttString boundingRectWithSize:CGSizeMake(self.titleLabel.frame.size.width, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    NSAttributedString *copyrightAttString = [[NSAttributedString alloc] initWithString:self.LicenseData[CopyrightKey]
                                                                             attributes:@{NSFontAttributeName:self.copyrightLabel.font}];
    CGSize copyrightSize = [copyrightAttString boundingRectWithSize:CGSizeMake(self.copyrightLabel.frame.size.width, CGFLOAT_MAX)
                                                            options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    NSAttributedString *descriptionAttString = [[NSAttributedString alloc] initWithString:self.LicenseData[DescriptionKey]
                                                                               attributes:@{NSFontAttributeName:self.descriptionLabel.font}];
    CGSize descriptionSize = [descriptionAttString boundingRectWithSize:CGSizeMake(self.descriptionLabel.frame.size.width, CGFLOAT_MAX)
                                                                options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    
    return titleSize.height + copyrightSize.height + descriptionSize.height + 10 + 4 + 4 + 20;
}

@end
