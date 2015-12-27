//
//  LocationNode.m
//  LocationDemo
//
//  Created by 刘人榕 on 15/12/21.
//  Copyright © 2015年 LRR. All rights reserved.
//

#import "LocationNode.h"
@interface LocationNode()
@property (nonatomic, strong)NSArray *countryArr;
@property (nonatomic, assign,readwrite)BOOL isSelectedStyle;
@end
@implementation LocationNode


+ (instancetype)nodeWithNodeName:(NSString *)name selectedName:(NSString*)selectedName{
    
    LocationNode * node = [LocationNode nodeWithNodeName:name];
    
    if (selectedName&&selectedName.length>0&&[selectedName rangeOfString:name].location != NSNotFound) {
        node.isSelectedStyle = YES;
    }
    
    return node;
}

// 用于回传,子类重写
- (NSString*)returnString{
    if (self.fatherNode) {
        if (self.fatherNode.name&&self.fatherNode.name.length>0) {
            // "广东省 深圳市"
            return [NSString stringWithFormat:@"%@ %@",self.fatherNode.name,self.name];
        }else{
            // "美国"
            return [NSString stringWithFormat:@"%@",self.name];
        }
    }else {
        return self.name;
    }
}


#pragma mark -- 特殊节点调用

// 加载全球国家数据(根节点调用)
- (void)addAreaDataWithSelectedString:(NSString *)selectedString{
    
    for(int i = 0;i<self.countryArr.count;i++) {
        NSString *country = self.countryArr[i];
        
        if (i == 0) {   // China
            LocationNode * ChinaNode = [LocationNode nodeWithNodeName:country selectedName:selectedString];
            
            NSString *areaPath = [[NSBundle mainBundle]pathForResource:@"area" ofType:@"plist"];
            NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:areaPath];
            [ChinaNode addChinaData:dic selectedString:selectedString];
            [self addNode:ChinaNode];
            
        }else {   // other country
            LocationNode *otherCountryNode = [LocationNode nodeWithNodeName:country selectedName:selectedString];
            [self addNode:otherCountryNode];
        }
    }
}

#pragma mark -- 添加中国地所有省份
// 应该是「中国节点」调用此方法
- (void)addChinaData:(NSDictionary *)dataDict selectedString:(NSString*)selectedString{
    
    // 省份顺序要按照plist最外层的key排序
    NSArray *keys = dataDict.allKeys;
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        if (obj1.integerValue < obj2.integerValue) {
            return NSOrderedAscending;
        }else if(obj1.integerValue > obj2.integerValue){
            return NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    for(NSString *key in sortedKeys) {
        NSDictionary *provinceDic = dataDict[key];
        LocationNode *provinceNode = [self getAllCityNodeWithDic:provinceDic selectedString:selectedString];
        [self addNode:provinceNode];
    }
}

- (LocationNode*)getAllCityNodeWithDic:(NSDictionary *)provinceDic selectedString:(NSString*)selectedString{
    // 第一层级: 省份
    LocationNode *provinceNode = [LocationNode nodeWithNodeName:provinceDic.allKeys[0] selectedName:selectedString];
    NSDictionary *tempDic = provinceDic.allValues[0];
    for(NSDictionary *cityDic in tempDic.allValues) {
        // 第二层级: 城市
        
        LocationNode *cityNode = [LocationNode nodeWithNodeName:cityDic.allKeys[0] selectedName:selectedString];
        NSArray *regionArray = cityDic.allValues[0];
        [provinceNode addNode:cityNode];
        

        // 直辖市: 只有二级层次
        if ([self checkMunicipality:cityNode.name]) {
            for(NSString *regionName in regionArray) {
                // 第三层级: 区域
                
                LocationNode *regionNode = [LocationNode nodeWithNodeName:regionName selectedName:selectedString];
                
                [cityNode addNode:regionNode];
            }
            [provinceNode removeNode:cityNode];
            return cityNode;
        }
    }
    return provinceNode;
}


#pragma mark -- 是否港澳、直辖市
- (BOOL)checkMunicipality:(NSString *)city {
    NSArray *municipalitys = @[@"香港特别行政区",@"澳门特别行政区",@"北京市",@"天津市",@"上海市",@"重庆市"];
    for(NSString *municipality in municipalitys) {
        if ([city isEqualToString:municipality]) {
            return YES;
        }
    }
    return NO;
}



#pragma mark -- setter&getter

/**************************************************************************************
                            全球国家
***************************************************************************************
 */
#pragma mark -- 所有国家数据
- (NSArray*)countryArr{
    if (!_countryArr) {
        _countryArr = @[@"中国",@"美国",@"阿富汗",@"奥兰群岛",@"阿尔巴尼亚",@"阿尔及利亚",@"美属萨摩亚",@"安道尔",@"安哥拉",@"安圭拉",@"南极洲",@"安提瓜和巴布达",@"阿根廷",@"亚美尼亚",@"阿鲁巴",@"澳大利亚",@"奥地利",@"阿塞拜疆",@"巴哈马",@"巴林",@"孟加拉国",@"巴巴多斯",@"白俄罗斯",@"比利时",@"伯利兹",@"贝宁",@"百慕",@"不丹",@"玻利维亚",@"波斯尼亚和黑塞哥维那",@"博茨瓦纳",@"布维岛",@"巴西",@"文莱",@"保加利亚",@"布基纳法索",@"布隆迪",@"柬埔寨",@"喀麦隆",@"加拿",@"佛得角",@"开曼群岛",@"中非共和国",@"乍得",@"智利",@"圣诞岛",@"哥伦比亚",@"科摩罗",@"刚果",@"库克群岛",@"哥斯达黎加",@"科特迪瓦",@"克罗地亚",@"库拉索岛",@"塞浦路斯",@"捷克共和国",@"丹麦",@"吉布提",@"多米尼加",@"多米尼加共和国",@"东帝汶",@"厄瓜多尔",@"埃及",@"萨尔瓦多",@"赤道几内亚",@"厄立特里亚",@"爱沙尼亚",@"埃塞俄比亚",@"法罗群岛",@"密克罗尼西亚联邦密克罗尼西亚",@"斐济",@"芬兰",@"法国",@"法国 大都会",@"法属圭亚那",@"法属波利尼西亚",@"法国南部领土",@"加蓬",@"冈比亚",@"格鲁吉亚",@"德国",@"加纳",@"直布罗陀",@"希腊",@"格陵兰岛",@"格林纳达",@"瓜德罗普岛",@"关岛",@"危地马拉",@"根西岛",@"几内亚",@"几内亚 几内亚比绍",@"圭亚那",@"海地",@"赫德岛和麦克唐纳群岛",@"罗马教廷（梵蒂冈城国）",@"洪都拉斯",@"匈牙利",@"冰岛",@"印度",@"印度尼西亚",@"伊拉克",@"爱尔兰",@"马恩岛",@"以色列",@"意大利",@"牙买加",@"日本",@"新泽西州",@"约旦",@"哈萨克斯坦",@"肯尼亚",@"基里巴斯",@"科威特",@"吉尔吉斯斯坦",@"老挝",@"拉脱维亚",@"黎巴嫩",@"莱索托",@"利比里亚",@"利比亚",@"列支敦士登",@"立陶宛",@"卢森堡",@"马其顿",@"马达加斯加",@"马拉维",@"马来西亚",@"马尔地夫",@"马里",@"马耳他",@"马绍尔群岛",@"马提尼克岛",@"毛里塔尼亚",@"毛里求斯",@"马约特岛",@"墨西哥",@"摩纳哥",@"蒙古",@"黑山",@"蒙特塞拉特",@"摩洛哥",@"莫桑比克",@"缅甸",@"纳米比亚",@"瑙鲁",@"尼泊尔",@"荷兰",@"新喀里多尼亚",@"新西兰",@"尼加拉瓜",@"尼日尔",@"尼日利亚",@"纽埃",@"诺福克岛",@"北马里亚纳群岛",@"挪威",@"阿曼",@"巴基斯坦",@"帕劳",@"巴勒斯坦领土",@"巴拿马",@"巴布亚新几内亚",@"巴拉圭",@"秘鲁",@"菲律宾",@"皮特凯恩",@"波兰",@"葡萄牙",@"波多黎各",@"卡塔尔",@"摩尔多瓦共和国",@"留尼旺",@"罗马尼亚",@"俄罗斯联邦",@"卢旺达",@"圣巴泰勒米岛地区",@"圣赫勒拿岛",@"圣基茨和尼维斯",@"圣卢西亚",@"圣马丁",@"圣皮埃尔和密克隆",@"圣文森特和格林纳丁斯",@"萨摩亚",@"圣马力诺",@"圣多美和普林西比",@"沙特阿拉伯",@"苏格兰",@"塞内加尔",@"塞尔维亚",@"塞舌尔",@"塞拉利昂",@"新加坡",@"圣马丁岛",@"斯洛伐克",@"斯洛文尼亚",@"索罗门群岛",@"索马里",@"南非",@"韩国",@"西班牙",@"斯里兰卡",@"苏里南",@"斯瓦尔巴群岛和扬马延岛",@"史瓦济兰",@"瑞典",@"瑞士",@"塔吉克斯坦",@"坦桑尼亚",@"泰国",@"多哥",@"托克劳",@"汤加",@"特里尼达和多巴哥",@"突尼斯",@"土耳其",@"土库曼斯坦",@"特克斯和凯科斯群岛",@"图瓦卢",@"乌干达",@"乌克兰",@"阿拉伯联合大公国",@"英国",@"美国本土外小",@"乌拉圭",@"乌兹别克斯坦",@"瓦努阿图",@"委内瑞拉",@"越南",@"瓦利斯群岛和富图纳群岛",@"西撒哈拉",@"也门",@"南斯拉夫",@"赞比亚",@"津巴布韦"];
    }
    return _countryArr;
}


@end
