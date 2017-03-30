//
//  MTEHistoriaClinicaViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 2/17/15.
//  Copyright (c) 2015 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEantecedente.h"

@interface MTEHistoriaClinicaViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *patoTextField;
@property (weak, nonatomic) IBOutlet UITextField *farmaTextField;
@property (weak, nonatomic) IBOutlet UITextField *taTextField;
@property (weak, nonatomic) IBOutlet UITextField *qxTextField;
@property (weak, nonatomic) IBOutlet UITextField *goTextField;
@property (weak, nonatomic) IBOutlet UITextField *otrosTextField;
@property (nonatomic, strong) MTEantecedente *antece;


@end
