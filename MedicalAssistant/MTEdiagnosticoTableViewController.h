//
//  MTEdiagnosticoTableViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/27/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEdiagnostico.h"
#import "MTEControlViewController.h"

@interface MTEdiagnosticoTableViewController : UITableViewController <UISearchBarDelegate, UISearchDisplayDelegate>
@property (nonatomic, strong) NSMutableArray *diagnosticos;
@property (nonatomic, strong) NSMutableArray *filteredDiagnosticos;
@property (nonatomic, strong) MTEControlViewController *cvc;
@end
