//
//  CountryTableViewCell.h
//  ProficiencyExercise
//
//  Created by kanagasabapathy on 08/07/18.
//  Copyright © 2018 kanagasabapathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *rowImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *DescriptionLabel;

@end
