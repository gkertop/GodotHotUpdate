# GodotHotUpdate

### 简介

Godot热更新项目

利用PCK文件实现项目热更新示例

### 项目结构

* loader //加载器(客户端)

* updater //更新器
    * src //更新目录(存放需要更新的资源文件)
    * pack //打包工具

### 调试步骤

1. 打包PCK文件
    * 打开"updater"项目
    * 将启动场景设置为"pack.tscn"
    * 运行项目,默认打包"src"目录下的所有资源文件

2. 测试更新
    * 打开"loader"项目
    * 将启动场景设置为"Loader.tscn"
    * 运行项目,将会下载并加载pck文件