#### 大致介绍

* 导入科大讯飞库
* 采用科大讯飞人脸识别技术SDK
* `抓取照相机预览层的帧数据`
* 创建一个View，`将抓取到的帧数据放到View的Layer层`，降低CPU损耗，提高用户体验
* 抓取Layer层上每一帧的时候，将CIImage图片进行处理，获取到图片内容，宽高，图片方向
* 将图片传递到科大讯飞检验，科大讯飞返回人脸特征点
* 格式化人脸特征点，拿到面部信息，拆解出每一个坐标点
* 自定义一个View，将面部坐标点传递进View，绘制图形上下文，将图片放入坐标点中，`绘制图形上下文降低性能损耗`

#### 导入科大讯飞SDK

到[科大讯飞 ](http://www.xfyun.cn/?ch=bdtg)注册账号，下载SDK，导入项目中

* 添加依赖库
	* libc++.dylib
	* libstdc++.dylib
	* SystemConfiguration.framework
	* MobileCoreServices.framework
	* CoreGraphics.framework
	* UIKit.framework

在`Build Settings`->`Framework Search Paths`中设置引用存放SDK的文件相对路径路径

科大讯飞SDK其中使用HTTP，所以需要在`Info.plist`中添加

```
<key>NSAppTransportSecurity</key>
<dict>
	<key>NSAllowsArbitraryLoads</key>
	<true/> 
</dict>

```

导入`Tools`文件进入项目中，将`Tools`的类的头文件全局

然后来到`AppDelegate.m`中`- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions`

实现注册SDK

```
 //设置log等级，此处log为默认在app沙盒目录下的msc.log文件
    [IFlySetting setLogFile:LVL_ALL];
    
    //输出在console的log开关
    [IFlySetting showLogcat:YES];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@,",USER_APPID];
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

```

在使用的时候，使用`IFlyFaceDetector`开启检测权限，具体代码如下

```
 self.faceDetector=[IFlyFaceDetector sharedInstance];
 [self.faceDetector setParameter:@"1" forKey:@"detect"];
 [self.faceDetector setParameter:@"1" forKey:@"align"];
```

在自定义的View中，传递进面部坐标点，开启上下文，对图片位置进行处理，


