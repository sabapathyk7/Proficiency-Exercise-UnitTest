//
//  AppDelegate.h
//  ProficiencyExercise
//
//  Created by kanagasabapathy on 08/07/18.
//  Copyright © 2018 kanagasabapathy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

