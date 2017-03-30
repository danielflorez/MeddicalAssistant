//
//  MTEProcedimientosTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/6/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTECrearCitaViewController.h"

@interface MTEProcedimientosTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *procedimientos;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTECrearCitaViewController *ccvc;
@property bool cita;

-(void)reloadData;

@end
