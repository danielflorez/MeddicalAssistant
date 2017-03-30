//
//  MTEiPadProcedimientosTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/7/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEiPadCrearCitaViewController.h"

@interface MTEiPadProcedimientosTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *procedimientos;
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEiPadCrearCitaViewController *ccvc;
@property bool cita;

-(void)reloadData;

@end
