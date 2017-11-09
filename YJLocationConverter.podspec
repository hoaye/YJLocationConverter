version = "0.0.1";

Pod::Spec.new do |s|

    s.name         = "YJLocationConverter"
    s.version      = version
    s.summary      = "YJLocationConverter 是中国国测局地理坐标（GCJ-02）<火星坐标>、世界标准地理坐标(WGS-84) 、百度地理坐标（BD-09)坐标系转换工具类"
    s.description      = <<-DESC
                        YJLocationConverter 是中国国测局地理坐标（GCJ-02）<火星坐标>、世界标准地理坐标(WGS-84) 、百度地理坐标（BD-09)坐标系转换工具类, 精准装换
                            DESC
    s.homepage     = "https://github.com/stackhou/YJLocationConverter"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "houmanager" => "houmanager@Hotmail.com" }
    s.platform     = :ios, "7.0"
    s.source       = { :git => "https://github.com/stackhou/YJLocationConverter.git", :tag => "#{version}"}
    s.source_files  = "YJLocationConverter/*.{h,m}"
    s.requires_arc = true

end
