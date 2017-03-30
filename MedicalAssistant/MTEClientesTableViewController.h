//
//  MTEClientesTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 10/24/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTECrearCitaViewController.h"

@interface MTEClientesTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) NSMutableArray *pacientes;
@property (nonatomic, strong) NSString *memberID;
@property (strong,nonatomic) NSMutableArray *filteredPacientesArray;
@property (nonatomic, strong) MTECrearCitaViewController *ccvc;
@property bool cita;

- (void) reloadData;

@end
