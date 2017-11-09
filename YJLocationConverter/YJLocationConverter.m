//
//  YJLocationConverter.m
//  YJLocationConverterDemo
//
//  Created by YJHou on 2014/5/9.
//  Copyright © 2014年 https://github.com/stackhou . All rights reserved.
//

#import "YJLocationConverter.h"

#define kLAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define kLAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define kLAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define kLAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0

#define kLON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define kLON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define kLON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define kLON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0

#define kRANGE_LON_MAX 137.8347
#define kRANGE_LON_MIN 72.004
#define kRANGE_LAT_MAX 55.8271
#define kRANGE_LAT_MIN 0.8293
// kYJA = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
#define kYJA 6378245.0
#define kYJEE 0.00669342162296594323

@implementation YJLocationConverter

+ (CLLocationCoordinate2D)yj_WGS84ConvertToGCJ02:(CLLocationCoordinate2D)location{
    return [self gcj02Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)yj_GCJ02ConvertToWGS84:(CLLocationCoordinate2D)location{
    return [self gcj02Decrypt:location.latitude gjLon:location.longitude];
}

+ (CLLocationCoordinate2D)yj_WGS84ConvertToBD09:(CLLocationCoordinate2D)location{
    
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:location.latitude
                                                  bdLon:location.longitude];
    return [self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude] ;
}

+ (CLLocationCoordinate2D)yj_GCJ02ConvertToBD09:(CLLocationCoordinate2D)location{
    return  [self bd09Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)yj_BD09ConvertToGCJ02:(CLLocationCoordinate2D)location{
    return [self bd09Decrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)yj_BD09ConvertToWGS84:(CLLocationCoordinate2D)location{
    CLLocationCoordinate2D gcj02 = [self yj_BD09ConvertToGCJ02:location];
    return [self gcj02Decrypt:gcj02.latitude gjLon:gcj02.longitude];
}

#pragma mark - Private
+ (double)transformLat:(double)x bdLon:(double)y{
    
    double ret = kLAT_OFFSET_0(x, y);
    ret += kLAT_OFFSET_1;
    ret += kLAT_OFFSET_2;
    ret += kLAT_OFFSET_3;
    return ret;
}

+ (double)transformLon:(double)x bdLon:(double)y{
    
    double ret = kLON_OFFSET_0(x, y);
    ret += kLON_OFFSET_1;
    ret += kLON_OFFSET_2;
    ret += kLON_OFFSET_3;
    return ret;
}

+ (BOOL)outOfChina:(double)lat bdLon:(double)lon{
    
    if (lon < kRANGE_LON_MIN || lon > kRANGE_LON_MAX)
        return true;
    if (lat < kRANGE_LAT_MIN || lat > kRANGE_LAT_MAX)
        return true;
    return false;
}

+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon{
    
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - kYJEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((kYJA * (1 - kYJEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (kYJA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}

+ (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon {
    
    CLLocationCoordinate2D  gPt = [self gcj02Encrypt:gjLat bdLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}

+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon{
    
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065, y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}

+(CLLocationCoordinate2D)bd09Encrypt:(double)ggLat bdLon:(double)ggLon{
    
    CLLocationCoordinate2D bdPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}

@end
