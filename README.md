# FirImUploader
如果编译打包发布企业版对你来说算是一件比较繁琐的事情，可以试试该工具

使用该工具，在配置好相关信息后你可以一键给你的工程打包企业版应用，并自动上传到 fir.im 然后显示下载页面的二维码

省去了手动 archive，export，登录 fir.im, 上传应用的繁琐工作

# Usage

1、前往你的 fir.im 个人页面，获取 API Token

<img src="https://github.com/hon-key/FirImUploader/blob/master/1.png" />

2、启动 FirImUploader ，输入获取的 API Token

<img src="https://github.com/hon-key/FirImUploader/blob/master/2.png" />

3、点击搜索，将会出现相应的 APP 列表，如果你是第一次上传，先手动打包手动上传一次之后，再进行使用

<img src="https://github.com/hon-key/FirImUploader/blob/master/3.jpg" />

4、点击你想要上传的 APP，点击‘创建’，进入打包上传窗口

<img src="https://github.com/hon-key/FirImUploader/blob/master/4.png" />

5、依次输入一些必要信息：

- **工程名**：必须是你工程文件的名称
- **Scheme**: 你所要打包的目标 scheme
- **Plist名**: 关于这个，你需要首先手动打包一次并以export的方式导出，在导出的文件中找到相应的 ExportOptions.plist 拷贝到工程目录之下，名字即 ExportOptions.plist，注意带后缀
- **工程目录**: 即你打包工程的目录
- **输出目录**: 你需要将你打包的ipa输出到哪个目录之下

6、点击‘生成’按钮，将会自动打包并上传，等待完成之后，会在底部显示相应二维码
