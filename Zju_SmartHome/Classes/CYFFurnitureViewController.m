//
//  CYFFurnitureViewController.m
//  Zju_SmartHome
//
//  Created by 123 on 15/11/20.
//  Copyright © 2015年 GJY. All rights reserved.
//

#import "CYFFurnitureViewController.h"
#import "CYFCollectionViewCell.h"
#import "CYFCollectionReusableView.h"
#import "JYElectricalController.h"
#import "JYFurniture.h"
#import "JYFurnitureSection.h"
#import "CYFFurnitureViewController.h"
#import "CYFCollectionViewCell.h"
#import "CYFCollectionReusableView.h"
#import "JYElectricalController.h"
#import "JYFurniture.h"
#import "JYFurnitureSection.h"
#import "QRCatchViewController.h"
#import "DLAddDeviceView.h"
#import "JYFurnitureBack.h"
#import "AFNetworking.h"
#import "JYFurnitureBackStatus.h"

#define UISCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)

@interface CYFFurnitureViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,DLAddDeviceViewDelegate>

//collectionView属性
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
//增加智能区域
- (IBAction)add:(id)sender;

//智能区域数组
@property(nonatomic,strong)NSMutableArray *furnitureSecArray;
//@property(nonatomic,strong)NSMutableArray *furnitureSecArrayCopy;
//某一区域电器数组
@property(nonatomic,strong)NSMutableArray *furnitureArray;

//添加电器View
@property(nonatomic,strong)DLAddDeviceView *addDeviceView;
@property(nonatomic,copy)NSString *area;


//头部数组
@property(nonatomic,strong)NSMutableArray *headerArray;
//默认图片数组
@property(nonatomic,strong)NSMutableArray *imageArray;
@property(nonatomic,strong)NSMutableArray *imageHighArray;
//默认文字描述
@property(nonatomic,strong)NSMutableArray *descArray;

@property(nonatomic,strong)JYFurnitureBackStatus *furnitureBackStatus;

@property(nonatomic,strong)JYFurnitureSection *section;
@end

@implementation CYFFurnitureViewController

-(NSMutableArray *)headerArray
{
    if(!_headerArray)
    {
        _headerArray=[[NSMutableArray alloc]initWithObjects:@"大厅",@"卧室", nil];
    }
    return _headerArray;
}
-(NSMutableArray *)imageArray
{
    if(!_imageArray)
    {
        _imageArray=[[NSMutableArray alloc]initWithObjects:@"aircondition_off",@"fridge_off",@"tv_off",@"rgb_light_off",@"yw_light_off",@"equipment_add" ,nil];
    }
    return _imageArray;
}
-(NSMutableArray *)imageHighArray
{
    if(!_imageHighArray)
    {
        _imageHighArray=[[NSMutableArray alloc]initWithObjects:@"aircondition_on",@"fridge_on",@"tv_on",@"rgb_light_on",@"yw_light_on",@"equipment_add" ,nil];
    }
    return _imageHighArray;
}
-(NSMutableArray *)descArray
{
    if(!_descArray)
    {
        _descArray=[[NSMutableArray alloc]initWithObjects:@"空调",@"冰箱",@"电视",@"RGB灯",@"YW灯",@"添加", nil];
    }
    return _descArray;
}
-(NSMutableArray *)furnitureSecArray
{
    if(!_furnitureSecArray)
    {
        _furnitureSecArray=[[NSMutableArray alloc]init];
        //默认有两个智能区域
        for(int i=0;i<2;i++)
        {
            _furnitureArray=[[NSMutableArray alloc]init];
            //每个区域默认有5个电器和一个添加电器图片
            for(int j=0;j<6;j++)
            {
                //初始化一个电器
                JYFurniture *furniture=[[JYFurniture alloc]init];
                //设置电器图片
                furniture.imageStr=self.imageArray[j];
                //设置电器描述文字
                furniture.descLabel=self.descArray[j];
                //设置电器是否注册过
                //furniture.registed=NO;
                
                //将电器添加到电器数组中
                [_furnitureArray addObject:furniture];
            }
            
            //初始化一个智能区域
            JYFurnitureSection *furnitureSection=[[JYFurnitureSection alloc]init];
            //设置智能区域的名称
            furnitureSection.sectionName=self.headerArray[i];
            //设置智能区域的电器数组
            furnitureSection.furnitureArray=_furnitureArray;
            
            
            //将智能区域添加到智能区域数组中
            [_furnitureSecArray addObject:furnitureSection];
        }
    }
//    _furnitureSecArrayCopy=[[NSMutableArray alloc]init];
//    _furnitureSecArrayCopy=_furnitureSecArray;
    return _furnitureSecArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //进行CollectionView和Cell的绑定
    [self.collectionView registerClass:[CYFCollectionViewCell class]  forCellWithReuseIdentifier:@"CollectionCell"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    //加入头部视图；
    [self.collectionView registerClass:[CYFCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header"];
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    //右侧滚动条隐藏
    self.collectionView.showsVerticalScrollIndicator=false;
    
    [self getDataFromReote];
    
}

//有多少个section；
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    //有多少个一维数组；
    return self.furnitureSecArray.count;
}

//加载头部标题；
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
    view.title.text=furnitureSection.sectionName;
    
    return view;
}

//每一部分有多少个item
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    JYFurnitureSection *furnitureSction=[self.furnitureSecArray objectAtIndex:section];
    return furnitureSction.furnitureArray.count;
}

//每一个item具体显示
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
    JYFurniture *furniture=[furnitureSection.furnitureArray objectAtIndex:indexPath.row];
    
    [cell.imageButton setBackgroundImage:[UIImage imageNamed:furniture.imageStr] forState:UIControlStateNormal];
    
    cell.descLabel.text=furniture.descLabel;
    cell.topX.hidden=YES;
  
    return cell;
    
}
//***********************************************************************************
//下面这几个代理方法是必须实现的
//设置每一个item的宽度，高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(UISCREEN_WIDTH/ 3, UISCREEN_WIDTH/ 3);
}

//设置间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(0,0,0,0);
}

//设置section的header高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(self.collectionView.frame.size.width, 45);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    
    return 0;
}
//************************************************************************************
//item点击触发事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
    JYFurnitureSection *furnitureSection=[self.furnitureSecArray objectAtIndex:indexPath.section];
    
    if(indexPath.row==furnitureSection.furnitureArray.count-1)
    {
        self.area=furnitureSection.sectionName;
       
        JYFurnitureSection *section=self.furnitureSecArray[indexPath.section];
        self.section=section;
        [self addNewFurniture];
    }
    else
    {
        NSLog(@"第%ld个section,点击图片%ld",indexPath.section,indexPath.row);
        
        JYElectricalController *jyVc=[[JYElectricalController alloc]init];
        [self.navigationController pushViewController:jyVc animated:YES];
    }
    
}


- (IBAction)add:(id)sender
{
    self.furnitureArray=[[NSMutableArray alloc]init];
    //每个区域默认有5个电器和一个添加电器图片
    for(int i=0;i<6;i++)
    {
        //初始化一个电器
        JYFurniture *furniture=[[JYFurniture alloc]init];
        //设置电器图片
        furniture.imageStr=self.imageArray[i];
        //设置电器描述文字
        furniture.descLabel=self.descArray[i];
        //设置电器是否注册过
        //furniture.registed=NO;
        
        //将电器添加到电器数组中
        [self.furnitureArray addObject:furniture];
    }
    
    [self popEnvirnmentNameDialog];

}

- (void)popEnvirnmentNameDialog
{
    //初始化一个智能区域
    JYFurnitureSection *furnitureSection=[[JYFurnitureSection alloc]init];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入智能区域名称" preferredStyle:UIAlertControllerStyleAlert];
    
    //以下方法就可以实现在提示框中输入文本；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                {
                                    UITextField *envirnmentNameTextField = alertController.textFields.firstObject;
                                    
                                    //设置智能区域的名称
                                    furnitureSection.sectionName=envirnmentNameTextField.text;
                                    //设置智能区域的电器数组
                                    furnitureSection.furnitureArray=self.furnitureArray;
                                    //将智能区域添加到智能区域数组中
                                    [self.furnitureSecArray addObject:furnitureSection];
                                    
                                    //此时更新界面；
                                    [self.collectionView reloadData];
                                    
                                    
                                }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"请输入智能区域名称";
    }];
    [self presentViewController:alertController animated:true completion:nil];
    
}

-(void)addNewFurniture
{
//  QRCatchViewController *qrCatcherVC=[[QRCatchViewController alloc]init];
//  [self.navigationController pushViewController:qrCatcherVC animated:YES];
    
    DLAddDeviceView *addDeviceView=[DLAddDeviceView addDeviceView];
    addDeviceView.delegate=self;
    self.addDeviceView=addDeviceView;
    addDeviceView.frame=CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:addDeviceView];
    self.navigationItem.hidesBackButton=YES;
}

//取消添加设备
-(void)cancelAddDevice
{
    [self.addDeviceView removeFromSuperview];
    self.navigationItem.hidesBackButton=NO;
}

//添加设备
-(void)addDeviceGoGoGo:(NSString *)deviceName and:(NSString *)deviceMac
{
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    params[@"equipment.name"]=deviceName;
    params[@"equipment.logic_id"]=@"1234567890";
    params[@"equipment.scene_name"]=self.area;

    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Equipment/create" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         [self.addDeviceView removeFromSuperview];
         
         JYFurniture *furniture=[[JYFurniture alloc]init];
         furniture.imageStr=@"家居";
         furniture.descLabel=deviceName;
         
         JYFurniture *temp=[self.section.furnitureArray lastObject];
         [self.section.furnitureArray removeLastObject];
         [self.section.furnitureArray addObject:furniture];
         [self.section.furnitureArray addObject:temp];
         
         [self.collectionView reloadData];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回失败了吧：%@",error);
     }];
    
}

-(void)getDataFromReote
{
    //1.创建请求管理对象
    AFHTTPRequestOperationManager *mgr=[AFHTTPRequestOperationManager manager];
    
    //2.说明服务器返回的是json参数
    mgr.responseSerializer=[AFJSONResponseSerializer serializer];
    
    //3.封装请求参数
    NSMutableDictionary *params=[NSMutableDictionary dictionary];
    params[@"is_app"]=@"1";
    
    //4.发送请求
    [mgr POST:@"http://60.12.220.16:8888/paladin/Equipment/find" parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         //请求成功
         JYFurnitureBackStatus *furnitureBackStatus=[JYFurnitureBackStatus statusWithDict:responseObject];
         self.furnitureBackStatus=furnitureBackStatus;
         
         [self judge];
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"返回失败了吧：%@",error);
     }];
}

-(void)judge
{
    //遍历从服务器返回的电器的所属区域
    for(int i=0;i<self.furnitureBackStatus.furnitureArray.count;i++)
    {
        //按顺序取出从服务器返回的电器
        JYFurnitureBack *furnitureBack=self.furnitureBackStatus.furnitureArray[i];
        //遍历头部区域数组
        int j=0;
        for(j=0;j<self.headerArray.count;j++)
        {
            //如果电器的所属区域已存在于头部区域数组
            if ([furnitureBack.scene_name isEqualToString:self.headerArray[j]])
            {
                int k=0;
                //遍历电器描述文字
                for(k=0;k<self.descArray.count;k++)
                {
                    //如果从服务器返回的电器与已有电器描述一致
                    if([furnitureBack.name isEqualToString:self.descArray[k]])
                    {
                        //那就从self.furnitureSecArray中找到它
                        JYFurnitureSection *section=[self.furnitureSecArray objectAtIndex:j];
                        JYFurniture *furniture=[section.furnitureArray objectAtIndex:k];
                        //并将该电器的显示图片改为高亮
                        furniture.imageStr=self.imageHighArray[k];
                        break;
                    }
                }
                if(k>=self.descArray.count)
                {
                    //那就说明该电器不在默认电器里面，创建它
                    JYFurniture *furniture=[[JYFurniture alloc]init];
                    furniture.imageStr=@"办公室";
                    furniture.descLabel=furnitureBack.name;
                    //furniture.registed=YES;
                    
                    JYFurnitureSection *section=[self.furnitureSecArray objectAtIndex:j];
                    
                    JYFurniture *temp=[[JYFurniture alloc]init];
                    temp=[section.furnitureArray lastObject];
                    [section.furnitureArray removeLastObject];
        
                    //将创建的加入
                    [section.furnitureArray addObject:furniture];
                    //将添加按钮加入
                    [section.furnitureArray addObject:temp];
                }
                break;
            }
            else
            {
                
            }
        }
        //电器的所属区域不存在于已有头部电器数组
        if(j>=self.headerArray.count)
        {
            //创建新区域
            self.furnitureArray=[[NSMutableArray alloc]init];
            //每个区域默认有5个电器和一个添加电器图片
            for(int i=0;i<6;i++)
            {
                //初始化一个电器
                JYFurniture *furniture=[[JYFurniture alloc]init];
                //设置电器图片
                furniture.imageStr=self.imageArray[i];
                //设置电器描述文字
                furniture.descLabel=self.descArray[i];
                //设置电器是否注册过
                //furniture.registed=NO;
                
                //将电器添加到电器数组中
                [self.furnitureArray addObject:furniture];
            }
            JYFurniture *furniture=[[JYFurniture alloc]init];
            furniture.imageStr=@"单品";
            furniture.descLabel=furnitureBack.name;
            //furniture.registed=YES;
            
            JYFurniture *temp=[[JYFurniture alloc]init];
            temp=[self.furnitureArray lastObject];
            [self.furnitureArray removeLastObject];
            
            [self.furnitureArray addObject:furniture];
            [self.furnitureArray addObject:temp];
            
            //初始化一个智能区域
            JYFurnitureSection *furnitureSection=[[JYFurnitureSection alloc]init];
            //设置智能区域的名称
            furnitureSection.sectionName=furnitureBack.scene_name;
            //设置智能区域的电器数组
            furnitureSection.furnitureArray=self.furnitureArray;
            //将智能区域添加到智能区域数组中
            [self.furnitureSecArray addObject:furnitureSection];
            [self.headerArray addObject:furnitureBack.scene_name];
        
            
            //这里判断是否有注册的电器是默认图片的
            int k=0;
            //遍历电器描述文字
            for(k=0;k<self.descArray.count;k++)
            {
                //如果从服务器返回的电器与已有电器描述一致
                if([furnitureBack.name isEqualToString:self.descArray[k]])
                {
                    //那就从self.furnitureSecArray中找到它
                    JYFurnitureSection *section=[self.furnitureSecArray objectAtIndex:j];
                    JYFurniture *furniture=[section.furnitureArray objectAtIndex:k];
                    //并将该电器的显示图片改为高亮
                    furniture.imageStr=self.imageHighArray[k];
                    break;
                }
            }
        }
        
    }
    [self.collectionView reloadData];
}
@end
