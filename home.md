# Learning Notes

### GetX
注入单列组件，基本将工具类转为组件，集成网络请求框架    
provider/controller划分？  
可直接通过Get中的静态常量context，用于自定义弹窗等  
可在所需组件通过put()函数注入组件，自动基于类型创建单列或获取，不会重复创建  

**Router**

支持声明页面切换方式，

本地存储    

**GetConnect**

可集成作为自定义provider，自动注入请求函数，可重写生命周期函数。

自带网络请求函数timeout时间较短，大致4秒没有接收到响应就结束请求返回null，应自定义请求timeout时间。

### SQFLite

数据库数据表初始化，及增删改查

### Notification

### TTS

调用本地tts较简单，但仅支持朗读/暂停，ProgressHandler回调接口无效，无法获取当前朗读状态，无法前进后退。


### Others
传递执行函数到封装组件  

输入域获取值及监听  

**Timer**

```dart
var time = Timer.periodic();
time.cancel();
```

**进入页面即弹出dialog**

必须在页面渲染完后弹出。addPostFrameCallback()函数可以在frame绘制完回调

```D
 WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    _dialogController.showFullDialog('');
});
```

**Camera**

必须在执行runApp()函数前与fluuter engine通信，获取camera对象传入视图组件。

```dart
WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  _firstCamera = cameras.first;
```

