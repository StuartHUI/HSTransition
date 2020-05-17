# HSTransition


pod 'BTTransition'

一个自定义视图控制器转换动画，底部弹出，下拉手势收回

## Easy Usg
```
public init() {
    super.init(nibName:nil, bundle:nil)
    self.aniamtion = HSCoverVerticalTransition.init(present: self, dismiss: true)
    self.transitioningDelegate = self.aniamtion
}

required public init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}
```

## Author

245068482@qq.com

## License

HSTransition is available under the MIT license. See the LICENSE file for more info.
