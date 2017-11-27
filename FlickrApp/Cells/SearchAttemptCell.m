//
//  SearchAttemptCell.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchAttemptCell.h"
#import "SearchAttemptViewModel.h"

@interface SearchAttemptCell ()

@property (nonatomic, weak) IBOutlet UILabel *lblSearchTerm;
@property (nonatomic, weak) IBOutlet UILabel *lblSearchDate;

@end

@implementation SearchAttemptCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setViewModel:(SearchAttemptViewModel *)viewModel
{
    _lblSearchTerm.text = viewModel.queryString;
    _lblSearchDate.text = viewModel.dateString;
}

@end
