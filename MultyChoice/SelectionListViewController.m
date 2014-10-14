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
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [dataBaseManager.arrayOfAllCurrencyInfo count];
}
//animated appearance
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [AnimationFile displaySecondTable:cell :indexPath];
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [AnimationFile shakeAnimation:cell];
    CurrencyInfo *exemplair = [dataBaseManager.arrayOfAllCurrencyInfo
                               objectAtIndex:indexPath.row];
    if (self.selectedMainSegue) {
        [[dataBaseManager.fetchedRateHistory firstObject] setMainCurrencySaved:exemplair];
        [self.navigationController popViewControllerAnimated:YES];
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
//setting the application 'outfit'
-(void) makeApplicationMoreStylish {
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    self.selectionTableView.backgroundColor = [UIColor
                                               colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
}

@end
