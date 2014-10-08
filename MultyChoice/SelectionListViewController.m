//
//  ViewController.m
//  CurrencyTable
//
//  Created by Admin on 07.09.14.
//  Copyright (c) 2014 LembergSun. All rights reserved.
//

#import "SelectionListViewController.h"

@interface SelectionListViewController () {
    DataBaseManager *dataBaseManager;
    UsedData *data;
    NSString *backgroundImage;
}
@property(weak, nonatomic) IBOutlet UITableView *selectionTableView;
@end

@implementation SelectionListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    backgroundImage = @"wood-wallpaper.png";
    dataBaseManager = [DataBaseManager sharedManager];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    _selectionTableView.backgroundColor = [UIColor
                                           colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    data = [[UsedData alloc] initData];
    
    CGFloat rotationAngleDegrees = -15;
    CGFloat rotationAngleRadians = rotationAngleDegrees * (M_PI/180);
    CGPoint offsetPositioning = CGPointMake(-20, -20);
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, rotationAngleRadians, 0.0, 0.0, 1.0);
    transform = CATransform3DTranslate(transform, offsetPositioning.x, offsetPositioning.y, 0.0);
    _initialTransformation = transform;
    _shownIndexes = [NSMutableSet set];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource:
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [data.shortNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *SimpleIdentifier = @"SimpleIdentifier";
    TableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
    CurrencyInfo *exemplair =
    [dataBaseManager.fetchedArrayOfCurrencyInfo objectAtIndex:indexPath.row];
    cell.nameLabel.text = exemplair.abbrev;
    cell.fullNameLabel.text = exemplair.fullName;
    cell.flagImageView.image = [UIImage imageNamed:exemplair.icon];
    cell.sumLabel.text = nil;
    if (!self.selectedMainSegue) {
        if (exemplair.checked) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    if (![self.shownIndexes containsObject:indexPath]) {
        [self.shownIndexes addObject:indexPath];
        cell.layer.transform = self.initialTransformation;
        cell.layer.opacity = 1.8;
        [UIView animateWithDuration:0.7 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.layer.opacity = 1;
        }];
    }
    return cell;
}

#pragma mark - UITableViewDelegate:
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [AnimationFile shakeAnimation:cell];
    CurrencyInfo *exemplair = [dataBaseManager.fetchedArrayOfCurrencyInfo
                               objectAtIndex:indexPath.row];
    if (self.selectedMainSegue) {
        [[self delegate] setMainCurrency:exemplair];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        if (cell.accessoryType == UITableViewCellAccessoryNone) {
            if (![self.selectedCurrency isEqualToString:exemplair.abbrev]) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                exemplair.checked = @1;
            }
        } else if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            self.amount -= 1;
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
    [self dismissViewControllerAnimated:NO completion:^{
        UITableView *tableView;
        static NSString *SimpleIdentifier = @"SimpleIdentifier";
        TableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:SimpleIdentifier];
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.transform = CATransform3DMakeRotation(M_PI_2, 0.1, 0, 0);
        CATransform3DRotate(cell.layer.transform, 0.8, 0.8, 0.8, 0.5);
        cell.layer.opacity = 1;
    }];
}

@end
