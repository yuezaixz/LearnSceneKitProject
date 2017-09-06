# 笔记
## chapter2

在GameViewController.swift的setupScene()函数末尾添加以下内容。

```swift
 scnScene.background.contents = "GeometryFighter.scnassets/Textures/
Background_Diffuse.png"

```

产生的结果与预期效果不一致，怎么灰色深灰色的呢？

![](http://7oxfjd.com2.z0.glb.qiniucdn.com/2017-09-06-15046837172769.jpg)

找到一篇文章，[Chapter 2: Asset catalogs - issue with background color](https://forums.raywenderlich.com/t/chapter-2-asset-catalogs-issue-with-background-color/22582/2)，解决了该问题。不过还是对alpha通道不理解，Google了下，还是没大懂，只当理解是RGBA中的A了。

修改后的预览：
![](http://7oxfjd.com2.z0.glb.qiniucdn.com/2017-09-06-15046845384476.jpg)

