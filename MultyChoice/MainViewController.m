#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SelectionListViewController.h"

NSString * const backgroundImage = @"wood-wallpaper.png";
NSString * const cellIdentifier = @"SimpleIdentifier";

static NSString *mainCurrencyKey = @"mainCurrency";
static NSString *mainSegueIdentifier = @"MainAdd";
static NSString *addSegueIdentifier = @"Add";


@interface MainViewController () {
    DataBaseManager *dataBaseManager;
}
@end

@implementation MainViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeApplicationMoreStylish];
    if (![AppLaunchDefaultManager checkApplicationLaunch]) {
        [self firstLoadOfApplication];
    } else {
        dataBaseManager = [DataBaseManager sharedManager];
        [self setTheMainCurrency:[[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved]];
    }
    [self linkToTextField];
    self.currencyAmount.clearsOnBeginEditing = YES;
    [self createTableViewSwipeDownRefresh];
    self.shownIndexes = [NSMutableSet set];
    [self setObservingForMainCurrencyAndCheckmarks];
    //[self.currencyAmount textField:<#(UITextField *)#> shouldChangeCharactersInRange:<#(NSRange)#> replacementString:self.currencyA]
    
}

- (void)reloadTable {
    [self.myTableView reloadData];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSArray  *arrayOfString = [newString componentsSeparatedByString:@"."];
    
    if ([arrayOfString count] > 2 )
        return NO;
    
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.currencyAmount customButton];
}
//animated appearance
- (void)viewWillAppear:(BOOL)animated {
    [AnimationFile animateTableViewAppearance:self.myTableView];
    [dataBaseManager.selectedCurrencies removeAllObjects];
    for (CurrencyInfo* temp in dataBaseManager.arrayOfAllCurrencyInfo) {
        if ((temp.checked) && (![temp isEqual:[[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved]])) {
            [dataBaseManager.selectedCurrencies addObject:temp];
        }
    }
    [self.myTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    SelectionListViewController* controller = segue.destinationViewController;
    if ([segue.identifier isEqualToString:mainSegueIdentifier]) {
        controller.selectedMainSegue = YES;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.currencyAmount resignFirstResponder];
    self.currencyAmount.text = @"1";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSInteger)tableView:(UITableView*)tableView
 numberOfRowsInSection:(NSInteger)section {
    return [dataBaseManager.selectedCurrencies count];
}

- (UITableViewCell*)tableView:(UITableView*)tableView
        cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    CurrencyInfo* tempCurrency =
    [dataBaseManager.selectedCurrencies objectAtIndex:indexPath.row];
    TableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.nameLabel.text = tempCurrency.abbrev;
    cell.fullNameLabel.text = tempCurrency.fullName;
    cell.flagImageView.image = [UIImage imageNamed:tempCurrency.icon];
    RateHistory* tempCurrencyRate =
    [dataBaseManager.fetchedRateHistory firstObject];
    CurrencyCalculation* calculation = [CurrencyCalculation new];
    double resultRate = [calculation
                         convertNumber:[self.currencyAmount.text doubleValue]
                         OfCurrency:[tempCurrencyRate valueForKey:[self.mainName.text lowercaseString]]
                         into:[tempCurrencyRate valueForKey:[tempCurrency.abbrev lowercaseString]]];
    cell.sumLabel.text = [NSString stringWithFormat:@"%.3f", resultRate];
    return cell;
}

- (void)refreshTheMainTableView {
    [RefreshData refreshTableViewWithCompletionHandler:^(BOOL success) {
        if (success){
            [self.myTableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}
//rows deletion
- (void)tableView:(UITableView*)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CurrencyInfo *exemplair = [dataBaseManager.selectedCurrencies objectAtIndex:indexPath.row];
        exemplair.checked = nil;
        [dataBaseManager.selectedCurrencies removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationBottom];
    }
}
//the main currency output on the view
-(void) setTheMainCurrency: (CurrencyInfo *)main {
    self.mainName.text = main.abbrev;
    self.mainFullName.text = main.fullName;
    self.mainImage.image = [UIImage imageNamed:main.icon];
}
//performing entities creation and filling all the necessary arrays
-(void)firstLoadOfApplication {
    [AppLaunchDefaultManager rememberAboutApplicationLaunchWithKey];
    [DataBaseManager startWorkWithCurrencyRateAplication];
    
    dataBaseManager = [DataBaseManager sharedManager];
    [[dataBaseManager.fetchedRateHistory firstObject] setMainCurrencySaved:[dataBaseManager.arrayOfAllCurrencyInfo firstObject]];
    [self  setTheMainCurrency:[[dataBaseManager.fetchedRateHistory firstObject] mainCurrencySaved]];
}
//creating app's 'outfit'
-(void) makeApplicationMoreStylish {
    self.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:backgroundImage]];
    self.myTableView.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.titleTextAttributes =
    @{NSForegroundColorAttributeName : [UIColor whiteColor] };
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
//performing manual refresh
-(void)createTableViewSwipeDownRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshTheMainTableView)
                  forControlEvents:UIControlEventValueChanged];
    [self.myTableView addSubview:self.refreshControl];
}
//setting the relation with the text field, performing input validation
-(void) linkToTextField {
    self.currencyAmount.text = @"1";
    self.currencyAmount.reloadDelegate = self;
    [self.currencyAmount addTarget:self.currencyAmount
                            action:@selector(checkTyping)
                  forControlEvents:UIControlEventEditingChanged];
}
//setting the necessary performance in case of observed property being changed (animation + output)
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                       change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"mainCurrencySaved"]) {
        self.mainName.text =  [object mainCurrencySaved].abbrev;
        self.mainFullName.text = [object mainCurrencySaved].fullName;
        self.mainImage.image = [UIImage imageNamed:[object mainCurrencySaved].icon];
        [self.view addSubview:self.mainImage];
        [AnimationFile addRotateAnimationForLayer:self.mainImage.layer];
    }
}
//setting observance over the main currency (KVO)
-(void)setObservingForMainCurrencyAndCheckmarks {
    [[dataBaseManager.fetchedRateHistory firstObject]addObserver:self
                                                      forKeyPath:@"mainCurrencySaved"
                                                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
}
-(void)dealloc {
 [[dataBaseManager.fetchedRateHistory firstObject] removeObserver:self
                                                       forKeyPath:@"mainCurrencySaved"];
}

@end
