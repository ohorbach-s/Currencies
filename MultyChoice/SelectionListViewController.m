//
//  ViewController.m
//  CurrencyTable
//
//  Created by Admin on 07.09.14.
//  Copyright (c) 2014 LembergSun. All rights reserved.
//

#import "SelectionListViewController.h"

extern NSString *backgroundImage;
extern NSString *cellIdentifier;

@interface SelectionListViewController () {
    DataBaseManager *dataBaseManager;
}
@property(weak, nonatomic) IBOutlet UITableView *selectionTableView;
@end

@implementation SelectionListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    dataBaseManager = [DataBaseManager sharedManager];
    [self makeApplicationMoreStylish];
    [self makeAnimation];
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [dataBaseManager.arrayOfAllCurrencyInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    CurrencyInfo *exemplair =
    [dataBaseManager.arrayOfAllCurrencyInfo objectAtIndex:indexPath.row];
    cell.nameLabel.text = exemplair.abbrev;
    cell.fullNameLabel.text = exemplair.fullName;
    cell.flagImageView.image = [UIImage imageNamed:exemplair.icon];
    cell.sumLabel.text = nil;
    if (!self.selectedMainSegue) {
        for (CurrencyInfo *temp in dataBaseManager.selectedCurrencies) {
        if ([exemplair isEqual:temp]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [AnimationFile shakeAnimation:cell];
    CurrencyInfo *exemplair = [dataBaseManager.arrayOfAllCurrencyInfo
                               objectAtIndex:indexPath.row];
    if (self.selectedMainSegue) {
        dataBaseManager.mainCurrencySaved = exemplair;
       // RateHistory *tempRate = [[dataBaseManager.fetchedRateHistory firstObject] m];
        [[dataBaseManager.fetchedRateHistory firstObject] setMainCurrencySaved:exemplair];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            exemplair.checked = @(YES);
        } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            exemplair.checked = nil;
        }
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath
                 :(NSIndexPath *)indexPath {
    if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
        cell.layer.transform = self.initialTransformation;
        cell.layer.opacity = 1.8;
        [UIView animateWithDuration:0.7 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1;
        }];
    }
}
- (IBAction)done:(UIBarButtonItem *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)makeAnimation {
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
    _shownIndexes = [NSMutableSet set];
}

-(void) makeApplicationMoreStylish {
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.selectionTableView.backgroundColor = [UIColor
                                               colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
}

@end
