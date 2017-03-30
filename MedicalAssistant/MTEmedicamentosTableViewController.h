//
//  MTEmedicamentosTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/28/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEFormulacionTableViewController.h"
#import "MTEmedicamento.h"
#import "MTEformulacion.h"

@interface MTEmedicamentosTableViewController : UITableViewController
@property (nonatomic, strong) NSMutableArray *medicamentos;
@property (nonatomic, strong) NSMutableArray *filteredMedicamentos;
@property (nonatomic, strong) MTEFormulacionTableViewController *fcvc;

@end
