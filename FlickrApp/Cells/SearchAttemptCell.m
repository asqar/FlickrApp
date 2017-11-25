//
//  SearchAttemptCell.m
//  FlickrApp
//
//  Created by aSqar on 23.11.2017.
//  Copyright © 2017 Askar Bakirov. All rights reserved.
//

#import "SearchAttemptCell.h"
#import "Entities.h"

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

- (void) setSearchAttempt:(SearchAttempt *)searchAttempt
{
    _searchAttempt = searchAttempt;
    
    _lblSearchTerm.text = searchAttempt.searchTerm;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"dd/MM/yyyy HH:mm";
    
    _lblSearchDate.text = [dateFormatter stringFromDate:searchAttempt.dateSearched];
}

@end
