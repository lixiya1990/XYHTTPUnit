Pod::Spec.new do |s|
s.name         = "XYHttpUnit"    #存储库名称
s.version      = "0.0.2"      #版本号，与tag值一致
s.summary      = "这个是简介,基于AF的网络框架"  #简介
s.description  = "基于AF的网络框架"  #描述
s.homepage     = "https://github.com/lixiya1990/XYHttpUnit"      #项目主页，不是git地址
s.license      = { :type => "MIT", :file => "LICENSE" }   #开源协议
s.author             = { "lixiya" => "lixiya@mana.com" }  #作者
s.platform     = :ios, "9.0"                  #支持的平台和版本号
s.source       = { :git => "https://github.com/lixiya1990/XYHttpUnit.git", :tag => "0.0.2" }         #存储库的git地址，以及tag值
s.source_files  =  "Classess/**/*.{h,m}" #需要托管的源代码路径
s.requires_arc = true #是否支持ARC
s.dependency "AFNetworking"    #所依赖的第三方库，没有就不用写

end
