//
//  ViewController.h
//  ProficiencyExercise
//
//  Created by kanagasabapathy on 08/07/18.
//  Copyright © 2018 kanagasabapathy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSString * titleHeader;
    NSMutableArray * listArr;
    UIRefreshControl *refreshControl;
}
@property (weak, nonatomic) IBOutlet UITableView *countryTableView;
@property (weak, nonatomic) IBOutlet UILabel *headerTitle_Lb;

@end

