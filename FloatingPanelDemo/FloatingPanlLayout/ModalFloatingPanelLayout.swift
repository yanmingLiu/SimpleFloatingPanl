//
//  SimpleFloatingPanl.swift
//  FloatingPanelDemo
//
//  Created by lym on 2021/3/25.
//

import FloatingPanel
import Foundation

// MARK: - child

class ChildFloatingPanlManager: NSObject, FloatingPanelControllerDelegate {
    var fpc = FloatingPanelController()
    var onWillRemove: (() -> Void)?

    public func setup(childViewController: UIViewController, scrollView: UIScrollView?) {
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
            fpc.panGestureRecognizer.delegateProxy = self
            fpc.track(scrollView: sv)
        }
        fpc.set(contentViewController: childViewController)
    }

    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return ModalFloatingPanelLayout()
    }

    func floatingPanel(_ vc: FloatingPanelController, contentOffsetForPinning trackingScrollView: UIScrollView) -> CGPoint {
        return CGPoint(x: 0.0, y: 0.0 - trackingScrollView.contentInset.top)
    }

    func floatingPanelWillRemove(_ fpc: FloatingPanelController) {
        onWillRemove?()
    }
    
    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        print("floatingPanelWillEndDragging velocity = \(velocity)")

        if velocity.y > 40 {
            fpc.removeFromParent()
        }
    }
}

extension ChildFloatingPanlManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

// MARK: - model

class ModalFloatingPanlManager: NSObject, FloatingPanelControllerDelegate {
    var fpc = FloatingPanelController()

    public func setup(semiModalViewController: UIViewController, scrollView: UIScrollView?) {
        fpc.delegate = self
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 20
        appearance.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        fpc.surfaceView.appearance = appearance
        fpc.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        // 指示器的大小
        fpc.surfaceView.grabberHandleSize = .zero
        if let sv = scrollView {
            fpc.panGestureRecognizer.delegateProxy = self
            fpc.track(scrollView: sv)
        }
        fpc.set(contentViewController: semiModalViewController)
        fpc.isRemovalInteractionEnabled = true
    }

    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout {
        return ModalFloatingPanelLayout()
    }

    func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        print("floatingPanelWillEndDragging velocity = \(velocity)")

        if velocity.y > 40 {
            fpc.dismiss(animated: true, completion: {
                print("floatingPanelWillEndDragging dismissed")
            })
        }
    }

    func floatingPanel(_ vc: FloatingPanelController, contentOffsetForPinning trackingScrollView: UIScrollView) -> CGPoint {
        return CGPoint(x: 0.0, y: 0.0 - trackingScrollView.contentInset.top)
    }
}

extension ModalFloatingPanlManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}

// MARK: - layout

class ModalFloatingPanelLayout: FloatingPanelLayout {
    open var initialState: FloatingPanelState {
        return .full
    }

    open var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            // absoluteInset 返回一个布局锚点，该锚点具有指定的小数值、边缘和面板的参考指南。
            .full: FloatingPanelLayoutAnchor(absoluteInset: 120, edge: .top, referenceGuide: .safeArea),
            // fractionalInset 返回一个布局锚点，该锚点具有指定的小数值、边缘和面板的参考指南。 范围为 0.0 至 1.0
            // .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea)
        ]
    }

    open var position: FloatingPanelPosition {
        return .bottom
    }

    open func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        return state == .full ? 0.3 : 0.0
    }
}
