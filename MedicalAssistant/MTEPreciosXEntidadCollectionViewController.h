//
//  MTEPreciosXEntidadCollectionViewController.h
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 11/7/14.
//  Copyright (c) 2014 Mangosta Tecnologia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MTEprocedimiento.h"

@interface MTEPreciosXEntidadCollectionViewController : UICollectionViewController
@property (nonatomic, strong) NSString *memberID;
@property (nonatomic, strong) MTEprocedimiento *proc;
@property (nonatomic, strong) NSMutableArray *precios;

@end
