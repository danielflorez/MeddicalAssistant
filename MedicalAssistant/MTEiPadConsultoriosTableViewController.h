//
//  MTEiPadConsultoriosTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/16/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MTEiPadConsultoriosTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *consultorios;
@property (nonatomic, strong) NSString *memberID;
@property bool agenda;

-(void)reloadData;

@end
