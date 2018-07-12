//
//  ViewController.m
//  ProficiencyExercise
//
//  Created by kanagasabapathy on 08/07/18.
//  Copyright © 2018 kanagasabapathy. All rights reserved.
//

#import "ViewController.h"

#import "CountryDetail.h"

#import "CountryTableViewCell.h"

#import "UIImageView+WebCache.h"

#import "AFNetworking.h"

#import "ProficiencyModelObject.h"

#define API_PROFIENCY_EXERCISE @"https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    listArr = [[NSMutableArray alloc] init]; // Initialize the list array
    _countryTableView.delegate = self;
    _countryTableView.dataSource = self;
    // Setting delegate and datasource of tableview to viewController

    refreshControl = [[UIRefreshControl alloc]init]; // Refresh Control for TableView
    [self.countryTableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
   
    [self populateProficiencyData]; // API Calls to get the data from the server and checking the network connection
    
    
}

-(void)refreshTable{
    
    [refreshControl endRefreshing]; // End Refreshing
    [self populateProficiencyData]; // Populate the data from server
}

-(void)populateProficiencyData{
    
    ProficiencyModelObject * modelObject = [[ProficiencyModelObject alloc] init];
    
    if ([modelObject checkForNetwork]) { // Check the network connection : Condition
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:API_PROFIENCY_EXERCISE]]; // Constant API_PROFIENCY_EXERCISE contains API url
        [request setHTTPMethod:@"GET"]; // GET Method
        // API call by
        
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]]; // Used NSURLSession
        [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { // Success Block and Failure Block
            
            NSString *requestReply = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
           
            NSLog(@"Request reply: %@", requestReply);
            
            NSData * jsondata = [requestReply dataUsingEncoding:NSUTF8StringEncoding];
            
            id json = [NSJSONSerialization JSONObjectWithData:jsondata options:0 error:nil]; // JSON Dictionary value
            
            titleHeader = [json valueForKey:@"title"]; // Title of header view
            
            listArr = [self storeInformationFromAPI:json]; // Copying the values from the server to the Array
            
            dispatch_async(dispatch_get_main_queue(), ^{ // Main Queue using GCD Operation
                self.headerTitle_Lb.text = titleHeader; // Header of table view
                [_countryTableView reloadData]; // Reload the table views
            });
            
        }] resume];
    }else{
        
        dispatch_async(dispatch_get_main_queue(), ^{// Main Queue using GCD Operation
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:@"No Network Connection"
                                         message:@"Please check your network connection"
                                         preferredStyle:UIAlertControllerStyleAlert];
            // ALERT VIEW controller
            UIAlertAction *okButton = [UIAlertAction
                                       actionWithTitle:@"OK"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction *action)
                                       {
                                           
                                       }];
            // OK BUTTON TO dismiss the alert view controller
            [alert addAction:okButton]; // Adding action for the OK button
            [self presentViewController:alert animated:YES completion:nil]; // Presenting the alert view controller
        });
        
        
    }
}
- (NSMutableArray *)storeInformationFromAPI:(NSDictionary *)jsonDictionary{
    
    NSMutableArray * totalRows = [[NSMutableArray alloc] init]; // initializing the array
    
    BOOL hasValue = NO;
    
    for (NSDictionary * rowDict in [jsonDictionary valueForKey:@"rows"]) {  // iterating the array using for each loop
        CountryDetail * detail = [[CountryDetail alloc] init]; // Initializing the model class
        detail.rowTitle = [self validateStringNull:[rowDict valueForKey:@"title"]]?[rowDict valueForKey:@"title"]:@"";
        detail.rowDesc = [self validateStringNull:[rowDict valueForKey:@"description"]]?[rowDict valueForKey:@"description"]:@"";
        detail.imageUrl = [self validateStringNull:[rowDict valueForKey:@"imageHref"]]?[rowDict valueForKey:@"imageHref"]:@"";
        // Assigning the values to the model objects
        
        hasValue = YES;
        if (detail.rowTitle.length==0 && detail.rowDesc.length == 0 && detail.imageUrl.length == 0) {
            hasValue = NO;
        }
        if (hasValue) {
            [totalRows addObject:detail];  // Adding the objects to the array
            
        }
    }
    
    return totalRows; // Return number of the rows.
}

-(BOOL)validateStringNull:(NSString *)string{ // Validating the string
    
    if (string == (id)[NSNull null] || string.length == 0 ){
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{ // Returns sections of tableview
    return  1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ // Returns rows of tableview
    
    NSInteger  count = (NSInteger)[listArr count];
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // Configuring the Tableview cell
    NSString  * cellIdentifier = [NSString stringWithFormat:@"CountryTableViewCell"]; // Cell identifier
    
    CountryTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(!cell)
    {
        cell = [[CountryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    if ([listArr count] > 0) { // Checking the list array count
        CountryDetail * countryDet = (CountryDetail *) [listArr objectAtIndex:indexPath.row];
        cell.titleLabel.text = countryDet.rowTitle;
        cell.DescriptionLabel.text = countryDet.rowDesc;
        [cell.rowImageView sd_setImageWithURL:[NSURL URLWithString:countryDet.imageUrl] placeholderImage:[UIImage imageNamed:@""]];
        
        // Displaying the data into the table view cell
        
    }
    return cell; // returning the cell
}


#pragma mark - UITableView Delegates
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44.0; // Height
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewAutomaticDimension;
}




@end
