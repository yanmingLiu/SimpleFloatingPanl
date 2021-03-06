# SimpleFloatingPanl
FloatingPanl 自定义，抖音评论弹窗交互式的关闭效果。

### 一、没有tabbar的情况，并且fpc中没有跳转的逻辑，这种直接p
一般我们的视图层级是这样的: window -> UITabBarController -> UINavigationController -> UIViewController，
像抖音弹窗中的用户头像点击是需要跳转的，而且返回的时候fpc还是在最上层，这样就不能直接的present处理。



![没有tabbar的情况](https://github.com/yanmingLiu/SimpleFloatingPanl/blob/master/FloatingPanelDemo/Kapture%202021-03-26%20at%2012.39.55.gif)


1. 有tabbar的页面    
抖音那种首页弹窗，由于有tabbar的关系，所以弹出评论的方式就应该已add的方式，并且需要在弹出和关闭的时候处理tabbar显示隐藏

```

import FloatingPanel
import Foundation

class SimpleFloatingPanlManager: NSObject, FloatingPanelControllerDelegate {
    var semiModalViewController: UIViewController?
    var layout: SimpleFloatingPanelLayout!
    var fpc: FloatingPanelController = FloatingPanelController()

    var showNestedScrollView: Bool = false

    func setup(semiModalViewController: UIViewController, scrollView: UIScrollView?) {
        self.semiModalViewController = semiModalViewController
        layout = SimpleFloatingPanelLayout()
        fpc.delegate = self
        fpc.isRemovalInteractionEnabled = true
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 20
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        fpc.surfaceView.appearance = appearance
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        // 指示器的大小
         fpc.surfaceView.grabberHandleSize = .zero

        if let sv = scrollView {
            showNestedScrollView = true
            fpc.panGestureRecognizer.delegateProxy = self
            fpc.track(scrollView: sv)
        }

        fpc.set(contentViewController: semiModalViewController)
    }

    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return layout
    }

    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        print(#function, vc.layout.initialState)
    }

    func floatingPanelDidChangePosition(_ vc: FloatingPanelController) {
        print(#function, vc.layout.initialState)
        if vc.layout.initialState == .hidden {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.semiModalViewController?.dismiss(animated: true, completion: {
                    print("dismissed")
                })
            }
        }
    }

    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        print("floatingPanelWillEndDragging velocity = \(velocity)")

        if velocity.y > 40 {
            semiModalViewController?.dismiss(animated: true, completion: {
                print("floatingPanelWillEndDragging dismissed")
            })
        }
    }

    func floatingPanel(_ vc: FloatingPanelController, contentOffsetForPinning trackingScrollView: UIScrollView) -> CGPoint {
        return CGPoint(x: 0.0, y: 0.0 - trackingScrollView.contentInset.top)
    }
}

extension SimpleFloatingPanlManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return showNestedScrollView
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

class SimpleFloatingPanelLayout: FloatingPanelLayout {
    open var initialState: FloatingPanelState {
        return .full
    }

    open var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            // absoluteInset 返回一个布局锚点，该锚点具有指定的小数值、边缘和面板的参考指南。
            .full: FloatingPanelLayoutAnchor(absoluteInset: 120, edge: .top, referenceGuide: .safeArea),
            // fractionalInset 返回一个布局锚点，该锚点具有指定的小数值、边缘和面板的参考指南。 范围为 0.0 至 1.0
            //.half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    open var position: FloatingPanelPosition {
        return .bottom
    }

    open func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return state == .full ? 0.3 : 0.0
    }
}
```
