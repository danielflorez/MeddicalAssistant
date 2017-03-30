//
//  MTEiPadPreciosXEntidadCollectionViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/10/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEprocedimiento.h"

@interface MTEiPadPreciosXEntidadCollectionViewController : UICollectionViewController
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEprocedimiento *proc;
@property (nonatomic, strong) NSMutableArray *precios;

@end
