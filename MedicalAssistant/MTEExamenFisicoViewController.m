//
//  MTEExamenFisicoViewController.m
//  MedicalAssistant
//
//  Created by DANIEL FLOREZ HUERTAS on 2/17/15.
//  Copyright (c) 2015 Mangosta Tecnologia. All rights reserved.
//

#import "MTEExamenFisicoViewController.h"

@interface MTEExamenFisicoViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scroller;

@end

@implementation MTEExamenFisicoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapAnywhere:)];
    [self.view addGestureRecognizer:tapRecognizer];
    [self.scroller setScrollEnabled:YES];
    [self.scroller setContentSize:CGSizeMake(320, 549)];
    UIImage *bg = [UIImage imageNamed:@"bcint.png"];
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 0.f);
    [bg drawInRect:CGRectMake(0.f, 0.f, self.view.frame.size.width, self.view.frame.size.height)];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:resultImage]];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer
{
    [[self view] endEditing:YES];
}


@end
