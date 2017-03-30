//
//  MTEentidadesTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/4/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEEntidad.h"

@interface MTEentidadesTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *entidades;
@property (nonatomic, strong) NSString *memberID;

@end
