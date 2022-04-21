# seeworld_flutter

### Features

图片转文字。调取摄像头拍摄图书，将图片发送移动平台返回解析的文本数据。  

文本转语音。如果将大量文本发送移动平台再返回语音数据，延迟过大且无法申请使用离线SDK，因此使用Android原生TTS实现。

语音转命令。调取麦克风监听用户语音，移动平台无法申请使用离线语音SDK，因此将语音发送至平台转文本返回，本地解析文本命令。

基于安全及隐私关系，Android/iOS禁止闲置应用启动麦克风  

此应用是否应一直启动麦克风？电量消耗，隐私安全？  
防止应用休眠？

### Update
#### 2022-04-17
app基本布局结构，主题色调等再改    
功能，没注册，以手机为用户存储在本地；注册，特征/收藏夹等存储在服务器数据库，支持更换手机或不同手机登录
添加siri机器人功能能否实现？  

拉取新的新闻，

介绍的时候，要稍微介绍一下国际视障的标准及问题，因此我们针对该人群优化了UI等设计，例如使用了XXX色调主题  
我们在设计app UI时，在红色/绿色盲型，特意将UI界面调整到，使用纹理而非颜色来增加APP的识别度等，细节   

用PS截几张色障下的图  

添加调整到视障模式选项？


### Developments
Flutter 2.10.4  
Android SDK 32  

### Others
需要studio-SDK manager-sdk tools安装android sdk command-line tools(lastest)  
gradle替换国内阿里镜像  

android minSdkVersion设为21  

函数类型变量，需声明完整函数类型  
```dart
void Function() onTap;
```
