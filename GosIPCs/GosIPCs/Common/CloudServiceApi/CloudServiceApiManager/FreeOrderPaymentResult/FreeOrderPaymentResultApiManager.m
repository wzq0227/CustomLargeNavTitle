//  FreeOrderPaymentResultApiManager.m
//  CloudStoreSDK
//
//  Create by daniel.hu on 2018/12/11.
//  Copyright © 2018年 daniel. All rights reserved.

#import "FreeOrderPaymentResultApiManager.h"
#import "FreeOrderApiRespModel.h"
#import "YYModel.h"
#import "FreeOrderPaymentResultApiRespModel.h"
#import "GosMediator+CloudServiceApiMethods.h"

#pragma mark - service identifier
/// CloudPaymentService
extern NSString *const GosNetworkingCloudPaymentServiceIdentifier;
#pragma mark - 请求参数
/// 订单号
extern NSString *const kCloudServiceApiReqKeyOrderNumber;
/// 令牌
extern NSString *const kCloudServiceApiReqKeyToken;
/// 用户名
extern NSString *const kCloudServiceApiReqKeyUsername;

#pragma mark - 响应参数
/// 数据
extern NSString *const kCloudServiceApiRespKeyData;
/// 标记代码
extern NSString *const kCloudServiceApiRespKeyCode;
/// 错误信息
extern NSString *const kCloudServiceApiRespKeyMessage;

@interface FreeOrderPaymentResultApiManager () <GosApiManagerValidator, GosApiManagerParamSource>
/// 签名
@property (nonatomic, copy) NSString *token;
/// 用户名
@property (nonatomic, copy) NSString *username;
/// 订单号
@property (nonatomic, copy) NSString *orderNumber;

@end
@implementation FreeOrderPaymentResultApiManager
#pragma mark - initialization
+ (NSInteger)loadDataWithOrderNumber:(NSString *)orderNumber success:(void (^)(GosApiBaseManager * _Nonnull))successCallback fail:(void (^)(GosApiBaseManager * _Nonnull))failCallback {
    FreeOrderPaymentResultApiManager *api = [[FreeOrderPaymentResultApiManager alloc] init];
    api.successBlock = successCallback;
    api.failBlock = failCallback;
    return [api loadDataWithOrderNumber:orderNumber];
}
+ (NSInteger)loadDataWithPayOrder:(FreeOrderApiRespModel *)payOrder success:(void (^)(GosApiBaseManager * _Nonnull))successCallback fail:(void (^)(GosApiBaseManager * _Nonnull))failCallback {
    FreeOrderPaymentResultApiManager *api = [[FreeOrderPaymentResultApiManager alloc] init];
    api.successBlock = successCallback;
    api.failBlock = failCallback;
    return [api loadDataWithPayOrder:payOrder];
}
- (instancetype)init {
    if (self = [super init]) {
        self.validator = self;
        self.paramSource = self;
    }
    return self;
}
#pragma mark - public method
- (NSInteger)loadDataWithOrderNumber:(NSString *)orderNumnber {
    self.orderNumber = orderNumnber;
    return [self loadData];
}
- (NSInteger)loadDataWithPayOrder:(FreeOrderApiRespModel *)payOrder {
    return [self loadDataWithOrderNumber:payOrder.orderNo];
}

#pragma mark - GosApiManager
- (NSString *)methodName {
    return @"inland/cloudstore/payment-free";
}
- (GosApiManagerRequestType)requestType {
    return GosApiManagerRequestTypePost;
}
- (NSString *)serviceIdentifier {
    return GosNetworkingCloudPaymentServiceIdentifier;
}
- (NSDictionary *)reformParams:(NSDictionary *)params {
    NSMutableDictionary *temp = [params mutableCopy];
    if (self.orderNumber) {
        [temp addEntriesFromDictionary:@{kCloudServiceApiReqKeyOrderNumber:self.orderNumber}];
    }
    return [temp copy];
}

#pragma mark - GosApiManagerParamSource
- (NSDictionary *)paramsForApi:(GosApiBaseManager *)manager {
    // 每个api都需要token, username
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (self.token) {
        [params addEntriesFromDictionary:@{kCloudServiceApiReqKeyToken:self.token}];
    }
    if (self.username) {
        [params addEntriesFromDictionary:@{kCloudServiceApiReqKeyUsername:self.username}];
    }
    return [params copy];
}

#pragma mark - GosApiManagerValidator
- (GosApiManagerErrorType)manager:(GosApiBaseManager *)manager isCorrectWithParamsData:(NSDictionary *)data {
    if ([manager isKindOfClass:[self class]]) {
        if ([data objectForKey:kCloudServiceApiReqKeyToken]
            && [data objectForKey:kCloudServiceApiReqKeyUsername]
            && [data objectForKey:kCloudServiceApiReqKeyOrderNumber]
            && [data count] == 3) {
            // 必须只存在 token, username, order_no
            return GosApiManagerErrorTypeNoError;
        }
        return GosApiManagerErrorTypeParamsError;
    }
    return GosApiManagerErrorTypeNoError;
}
- (GosApiManagerErrorType)manager:(GosApiBaseManager *)manager isCorrectWithCallBackData:(NSDictionary *)data {
    // 校验返回参数
    if ([manager isKindOfClass:[self class]]) {
        if (![data objectForKey:kCloudServiceApiRespKeyCode] &&
            (![data objectForKey:kCloudServiceApiRespKeyData]
             && ![data objectForKey:kCloudServiceApiRespKeyMessage])) {
                // code必须有，data与message必须有其一
                return GosApiManagerErrorTypeNoContent;
            }
        return GosApiManagerErrorTypeNoError;
    }
    return GosApiManagerErrorTypeNoError;
}

#pragma mark - GosApiManagerDataReformer
- (id)manager:(GosApiBaseManager *)manager reformData:(NSDictionary *)data {
    if ([[data objectForKey:kCloudServiceApiRespKeyCode] integerValue] == 0) {
        return @(YES);
    }
    return @(NO);
}

#pragma mark - getters and setters
- (NSString *)token {
    if (!_token) {
        _token = [[GosMediator sharedInstance] cloudServiceApiToken];
    }
    return _token;
}
- (NSString *)username {
    if (!_username) {
        _username = [[GosMediator sharedInstance] cloudServiceApiUsername];
    }
    return _username;
}
@end