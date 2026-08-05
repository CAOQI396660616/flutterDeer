# Android 问题汇总

## Could not resolve io.flutter:flutter_embedding_xxx

### 大致异常如下：

```java
Could not resolve all files for configuration ':app:debugCompileClasspath'.
    > Could not resolve io.flutter:flutter_embedding_debug:1.0.0-6bc433c6b6b5b98dcf4cc11aff31cdee90849f32.
    ...
```

### 解决方法：

修改`flutter\packages\flutter_tools\gradle`下的`flutter.gradle`文件。

替换`MAVEN_REPO`为： http://download.flutter.io

或者修改flutter项目`android`目录的`build.gradle`文件，在`repositories`中添加：

```java
maven {
    url `http://download.flutter.io`
}
```

参考：https://github.com/flutter/flutter/issues/39729

## 关于打包

默认使用`flutter build apk`命令，包含32、64位。

添加`--target-platform`可指定平台，比如`android-arm`或`android-arm64`，来减小包体积。

还可以使用`--split-debug-info`标志省略调试信息，来减小包体积。（注意使用此方式无法获取可读的堆栈信息）

完整举例子：

```
flutter build apk --target-platform android-arm64 --obfuscate --split-debug-info=/flutter_deer/
```

## 历史问题

- 3.10.0已知问题(~~#124546~~ ~~#126560~~ ~~#131319~~ ~~#73388~~)。

- 1.22.0已知问题(~~#67262~~ ~~#67213~~)。

- 1.17.0已知问题(~~#25767~~ ~~#47191~~)。

- 1.12.13已知问题（~~#47804~~ ~~#47270~~ ~~#47635~~ ~~#47137~~ ~~#47462~~  ~~#47021~~ ~~#39494~~）。

- 1.12.13已修复。~~在1.9.1上，TextField在语言环境为中文时，[光标与输入文字不居中显示](https://github.com/flutter/flutter/issues/40248)，可暂时使用`textBaseline: TextBaseline.alphabetic` 处理此问提。~~

- 1.9.1已支持，使用`keyboardType: TextInputType.visiblePassword`即可。~~输入框在不设置`obscureText`属性的情况下(false)，[无法弹出密码模式键盘](https://github.com/flutter/flutter/issues/31738)，可暂时使用`BlacklistingTextInputFormatter`去除可能会输入的中文。~~




有如下问题
1背景上那张图片对应的细节还没完善 也就是  bg_login  是一个带透明通道的 图 背景可以显示出来 这个图片
这个没处理好
2 底部的 账号密码 应该判断 如果是安卓平台 就只显示  账号密码 如果是ios才显示右边的 apple
3 账号密码 需要翻译 我们目前都是 土耳其语言 这个是demo 只做 土耳其语言先
4截图中的 登录三个按钮的左右间距 需要 按照百分比 也就是现在的间距的2倍 然后高度加高现在高度的 1.3


1 第三个邮箱登录的 UI 改成电话登录  点击以后按照