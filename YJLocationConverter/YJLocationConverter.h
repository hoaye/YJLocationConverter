//
//  YJLocationConverter.h
//  YJLocationConverterDemo
//
//  Created by YJHou on 2014/5/9.
//  Copyright © 2014年 https://github.com/stackhou . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/** 版本号: 0.0.1  */

@interface YJLocationConverter : NSObject

/**
 世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标> 超出中国依旧是世界标准地理坐标

 @param location 世界标准地理坐标(WGS-84)
 @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)yj_WGS84ConvertToGCJ02:(CLLocationCoordinate2D)location;

/**
 中国国测局地理坐标（GCJ-02）<火星坐标>  转换成  世界标准地理坐标(WGS-84) 超出中国依旧是世界标准地理坐标

 @param location 中国国测局地理坐标（GCJ-02）<火星坐标>
 @return 世界标准地理坐标(WGS-84)
 */
+ (CLLocationCoordinate2D)yj_GCJ02ConvertToWGS84:(CLLocationCoordinate2D)location;

/**
 世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)

 @param location 世界标准地理坐标(WGS-84)
 @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)yj_WGS84ConvertToBD09:(CLLocationCoordinate2D)location;

/**
 中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)

 @param location  中国国测局地理坐标（GCJ-02）<火星坐标>
 @return 百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)yj_GCJ02ConvertToBD09:(CLLocationCoordinate2D)location;

/**
 百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>

 @param location 百度地理坐标（BD-09)
 @return 中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)yj_BD09ConvertToGCJ02:(CLLocationCoordinate2D)location;

/**
 百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）此接口有1－2米左右的误差，需要精确定位情景慎用

 @param location 百度地理坐标（BD-09)
 @return 世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)yj_BD09ConvertToWGS84:(CLLocationCoordinate2D)location;

@end
