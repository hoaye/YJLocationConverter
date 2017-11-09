# YJLocationConverter
中国国测局地理坐标（GCJ-02）<火星坐标>、世界标准地理坐标(WGS-84) 、百度地理坐标（BD-09)坐标系转换工具类

## 需求

### 一、在进行地图开发过程中，我们一般能接触到以下三种类型的地图坐标系：

* 1.WGS－84原始坐标系，一般用国际GPS纪录仪记录下来的经纬度，通过GPS定位拿到的原始经纬度，Google和高德地图定位的的经纬度（国外）都是基于WGS－84坐标系的；但是在国内是不允许直接用WGS84坐标系标注的，必须经过加密后才能使用；

* 2.GCJ－02坐标系，又名“火星坐标系”，是我国国测局独创的坐标体系，由WGS－84加密而成，在国内，必须至少使用GCJ－02坐标系，或者使用在GCJ－02加密后再进行加密的坐标系，如百度坐标系。高德和Google在国内都是使用GCJ－02坐标系，可以说GCJ－02是国内最广泛使用的坐标系；

* 3.百度坐标系:bd-09，百度坐标系是在GCJ－02坐标系的基础上再次加密偏移后形成的坐标系，只适用于百度地图。(目前百度API提供了从其它坐标系转换为百度坐标系的API，但却没有从百度坐标系转为其他坐标系的API);

* 4.LocationManager 中所用到的是国际标准的坐标系统(WGS-84)，使用 LocationManager 必须经过装换才能准确;

* 5.在MKMapView上通过定位自己位置所获得的经纬度有是准确，由此可知，Apple已经对国内地图做了偏移优化.

## Installation

### Cocoapods

YJBannerView is available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile:

```ruby
    pod 'YJLocationConverter'
```

## Support-Method

```objc
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
```

## 附加

1、使用IOS的私有类MKLocationManager来计算。
　　这个做法是有风险的，苹果不允许私有模块被直接调用。换句话说，你的软件可能会被Deny。因为是私有模块，我们需要声明这个类和我们要用到的函数，代码如下：
　　

```objc
@interface MKLocationManager   
+ (id)sharedLocationManager;    // 创建并获取MKLocationManager实例
- (BOOL)chinaShiftEnabled;    　// 判断IOS系统是否支持计算偏移
- (CLLocation*)_applyChinaLocationShift:(CLLocation*)arg;   // 传入原始位置，计算偏移后的位置
@end
```

在CLLocationManager的位置监听函数中，我们把newLocation（原始位置），转换为中国位置:

```objc
-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{

    if ([[MKLocationManager sharedLocationManager] chinaShiftEnabled]) {
        newLocation = [[MKLocationManager sharedLocationManager] _applyChinaLocationShift:newLocation];
        if (newLocation == nil) {  // 计算location好像是要联网的，软件刚启动时前几次计算会返回nil。
            return;
        }
    }
    ...
}
```

总结：这样(只能在IOS5以前的系统中使用)，经转换后的newLocation，已经是中国的位置了。现在在映射到MKMapView上时，会显示正确的所在位置。

2、打开MKMapView的showsUserLocation功能。
　　初始化MKMapView时，将属性showsUserLocation设置为YES，MKMapView会启动内置的位置监听服务，当用户位置变化时，调用delegate的回调函数：
　　

```objc
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    // 这里得到的userLocation，已经是偏移后的位置了
}
```
总结：这个方法不会用到IOS的私有类和函数，不会有被绝的风险。缺点可能是不能像CLLocationManager那样进行丰富的配置，至少目前我还没找到。

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).

## Change-log

A brief summary of each YJBannerView release can be found in the [CHANGELOG](CHANGELOG.mdown). 