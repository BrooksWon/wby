# 多视频同时播放测试

#### 测试方：APP开发

#### 测试时间：2019.6.14



## 业务场景

1. 单个视频播放
2. 多个视频播放




## 测试用例

1. 1个视频播放、2个视频同时播放、4个视频同时播放、9个视频同时播放

2. 测试说明：每种情况下每个系统测试 2 人 * 3 次

3. 测试系统：iOS、Android
4. 硬件支持：iPhone 6s，iPhone XR，Redmi Note 5A，Pixel 3 XL，华为9e



### 视频源

	"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4”,
	"http://alcdn.hls.xiaoka.tv/2017427/14b/7b3/Jzq08Sl8BbyELNTo/index.m3u8”,
	"https://media.w3.org/2010/05/sintel/trailer.mp4",
	"http://www.w3school.com.cn/example/html5/mov_bbb.mp4",
	"https://www.w3schools.com/html/movie.mp4",
	"http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4",
	"http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8",
	"http://vfx.mtime.cn/Video/2017/03/31/mp4/170331093811717750.mp4",
	"http://mirror.aarnet.edu.au/pub/TED-talks/911Mothers_2010W-480p.mp4,
	"https://media.w3.org/2010/05/sintel/trailer.mp4"



### 相关demo地址

- [Android-demo地址](https://github.com/BrooksWon/wby/tree/master/%E5%A4%9A%E8%A7%86%E9%A2%91%E5%90%8C%E6%97%B6%E6%92%AD%E6%94%BE%E8%B0%83%E7%A0%94/Android/demos)
- [iOS-demo地址](https://github.com/BrooksWon/wby/tree/master/%E5%A4%9A%E8%A7%86%E9%A2%91%E5%90%8C%E6%97%B6%E6%92%AD%E6%94%BE%E8%B0%83%E7%A0%94/iOS/M-Player)



## 测试结果

| 系统    | 硬件参数                                     | 同时播放的视频数 | 效果 | 测试次数 |
| ------- | -------------------------------------------- | ---------------- | ---- | -------- |
| iOS     | iPhone6S/iPhoneX                             | 1                | 支持 | 2人*3    |
| Android | Redmi Note 5A(7.1.2)/Pixel 3 XL(9)/华为9e(9) | 1                | 支持 | 2人*3    |
| iOS     | iPhone6S/iPhoneX                             | 2                | 支持 | 2人*3    |
| Android | Redmi Note 5A(7.1.2)/Pixel 3 XL(9)/华为9e(9) | 2                | 支持 | 2人*3    |
| iOS     | iPhone6S/iPhoneX                             | 4                | 支持 | 2人*3    |
| Android | Redmi Note 5A(7.1.2)/Pixel 3 XL(9)/华为9e(9) | 4                | 支持 | 2人*3    |
| iOS     | iPhone6S/iPhoneX                             | 9                | 支持 | 2人*3    |
| Android | Redmi Note 5A(7.1.2)/Pixel 3 XL(9)/华为9e(9) | 9                | 支持 | 2人*3    |

**备注：**

- 本次调研Android使用的是原生VideoView组价进行测试，在三个不同型号的手机Android版本分别为7.1.2和9.0下均正常同时播放多个视频；iOS使用的是原生的AVPlayer进行测试，6s和XR手机上均可正常同时播放多个视频。

## 结论

iOS和Android均支持多视频同时播放，画面和音频都各自正常。