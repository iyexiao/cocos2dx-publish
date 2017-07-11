# cocos2dx-publish
cocos2dx 的前端发布及热更新工具

#### 1.首次打包发布，运行如下命令  传入的参数为工程目录

``` sh firshBuild.sh projPath ```


#### 2.检查更新(必须已经运行1 且生成一个2016052419.md5文件) 传入参数为 1工程目录 2上次打包对应的md5文件
``` sh checkUpdate.sh projPath lastPubilishMd5File.md5 ```
#### 3.最终生成的时候，终端内有一个MD5(update_2016052422.zip)=j2230j234sldfjdslf将这个复制进《服务器文件》project.manifest内参考给予的形式，这样子就可以实现热更新啦。

#### 4.注意：AppDelegate.cpp中这行字
```stack->setXXTEAKey("KFCKey",strlen("KFCKey"));//研发模式注释掉这行```
这个需要注意，不能更改，打包部署的时候别注释。如果需要修改密匙或者加密方式，修改xxteaProj文件夹内xxteaRes源码

#### 5.这个加密已经将lua也加密了，请勿再次加密,这样ios android 都可以公用一套代码了,加密方式用的cocos带的xxtea。自己可以修改成另外一套代码

#### 6.文件结构
> * 客户端需要修改的文件 old[旧文件，对比用的]，new[新文件] TestClass.lua是测试热更新用的
> * server服务器cdn需要的配置文件，热更包zip也是放在这里
> * xxteaProj加密可执行文件源码
> * firshBuild.sh、checkUpdate.sh 对应的第一次打包和以后热更新用脚本

#### 7.TODO
> * 通过git账号每次打包的时候获取master分支上最新代码更新
> * 通过scp 将zip及对应热更新资源上次至cdn