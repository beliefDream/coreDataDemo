//
//  MainViewController.m
//  summaryCoreData
//
//  Created by zhs on 15/11/11.
//  Copyright (c) 2015年 zhs. All rights reserved.
//

#import "MainViewController.h"
#import <Masonry.h>

#import "PersonViewCell.h"
#import "Entity.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UISearchBar * searchBar;
}

@property (nonatomic, strong) NSMutableArray * dataArray;
@property (nonatomic, strong) NSMutableArray * tempArray;

@property (nonatomic, assign)int count;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(deletePerson)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(useGDCAddPerson)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}
#pragma mark - setUpView
- (void)setUpView {
    UIButton * btn = [UIButton new];
    btn.backgroundColor = [UIColor orangeColor];
    [btn setTitle:@"select" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectPerson) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    searchBar = [UISearchBar new];
    [self.view addSubview:searchBar];
    
    UITextField * nameTF = [UITextField new];
    nameTF.tag = 101;
    nameTF.placeholder = @"name";
    nameTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:nameTF];
    
    UITextField * ageTF = [UITextField new];
    ageTF.tag = 102;
    ageTF.placeholder = @"age";
    ageTF.backgroundColor = [UIColor redColor];
    [self.view addSubview:ageTF];
    
    
    UITableView * tableView = [UITableView new];
//    tableView.backgroundColor = [UIColor yellowColor];
    tableView.tag = 100;
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PersonViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];

    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(80);
        make.left.equalTo(self.view).offset(10);
//        make.height.mas_equalTo(50);
    }];
    
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn);
        make.left.equalTo(btn.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    [nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
    }];
    
    [ageTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(nameTF);
        make.top.equalTo(nameTF);
        make.left.mas_equalTo(nameTF.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-10);
    }];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameTF.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(10);
        make.bottom.and.right.equalTo(self.view).offset(-10);
    }];
    NSLog(@"frame = %@", NSStringFromCGRect(tableView.frame));
}

#pragma mark - tableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PersonViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    Entity * person = [self.dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = person.name;
    cell.ageLabel.text = [NSString stringWithFormat:@"%@", person.age];
    return cell;
}

#pragma mark - addPerson 
- (void)deletePerson {
    if (self.dataArray.count == 0) {
        return;
    }
    NSManagedObject * object = [self.dataArray objectAtIndex:0];
    [self.context deleteObject:object];
    [self.context save:nil];
    [self.dataArray removeObjectAtIndex:0];
    UITableView * tableView = (UITableView *)[self.view viewWithTag:100];
    //让cell显示  在0区 0行
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0
                                                 inSection:0];
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                     withRowAnimation:UITableViewRowAnimationFade];
}


- (void)useGDCAddPerson {
    [NSThread detachNewThreadSelector:@selector(addPerson) toTarget:self withObject:nil];
}
- (void)addPerson {
    Entity * person = [NSEntityDescription insertNewObjectForEntityForName:@"Entity"
                                                    inManagedObjectContext:self.context];
//    person.name = @"hell0";
//    person.age = @(self.count);
    self.count++;

    UITextField * nameTF = (UITextField *)[self.view viewWithTag:101];
    UITextField * ageTF = (UITextField *)[self.view viewWithTag:102];

    person.name = nameTF.text;
    person.age =  [NSNumber numberWithInt:[ ageTF.text intValue]];
    
    [self.context save:nil];
    [self.dataArray insertObject:person atIndex:0];
    self.tempArray = self.dataArray;

    UITableView * tableView = (UITableView *)[self.view viewWithTag:100];
//    tableView.backgroundColor = [UIColor blueColor];
    //让cell显示  在0区 0行
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0
                                                 inSection:0];
    [tableView insertRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil]
                          withRowAnimation:UITableViewRowAnimationRight];

}
- (void)selectPerson {
    if (self.dataArray.count > 0) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name=%@", searchBar.text];
        NSArray * array = [self.dataArray filteredArrayUsingPredicate:predicate];
        if (array.count == 0) {
            self.dataArray = self.tempArray;
        }else {
            self.dataArray = [NSMutableArray arrayWithArray: array];
        }
        UITableView * tableView = (UITableView *)[self.view viewWithTag:100];
        [tableView reloadData];
    }
}

@end
