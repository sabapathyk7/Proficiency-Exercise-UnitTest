//
//  ProficiencyModelObject.m
//  ProficiencyExercise
//
//  Created by FSSD-26102015 on 7/12/18.
//  Copyright © 2018 kanagasabapathy. All rights reserved.
//

#import "ProficiencyModelObject.h"
#import "Reachability.h"

@implementation ProficiencyModelObject
-(BOOL)checkForNetwork
{
    Reachability *myNetwork = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    switch (myStatus) {
        case NotReachable:
            return NO;
            break;
        case ReachableViaWWAN:
            return YES;
            break;
        case ReachableViaWiFi:
            return YES;
            break;
        default:
            break;
    }
}



@end
