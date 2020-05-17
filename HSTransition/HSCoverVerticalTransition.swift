//
//  HSCoverVerticalTransition.swift
//  HSTransitionDemo
//
//  Created by Shuai Hui on 2020/5/7.
//  Copyright © 2020 Shuai Hui. All rights reserved.
//

import UIKit

class MKPresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        get {
            if let containerViewBounds = self.containerView?.bounds {
                 let presentedViewContentSize = self.size(forChildContentContainer: self.presentedViewController, withParentContainerSize: containerViewBounds.size)
                 var presentedViewControllerFrame = containerViewBounds
                 presentedViewControllerFrame.size.height = presentedViewContentSize.height
                 presentedViewControllerFrame.origin.y = containerViewBounds.height - presentedViewContentSize.height
                 return presentedViewControllerFrame
             }
             return CGRect.zero
        }
    }
    
    lazy var dimmingView: UIButton = {
        let button =  UIButton.init()
        button.backgroundColor = UIColor.clear.withAlphaComponent(0)
        button.addTarget(self, action: #selector(dismissAction), for: .touchUpInside)
        return button
    }()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.containerView?.addSubview(self.presentedView!)
    }
    // 通知感兴趣的控制器其子控制器的首选内容大小已更改。
    override func preferredContentSizeDidChange(forChildContentContainer container: UIContentContainer) {
        super.preferredContentSizeDidChange(forChildContentContainer: container)
//        print("通知感兴趣的控制器其子控制器的首选内容大小已更改" + #function)
        if container as? UIViewController == self.presentedViewController{
            self.containerView?.setNeedsLayout()
        }
    }
    // 返回指定子视图控制器内容的大小。
    override func size(forChildContentContainer container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        if container as? UIViewController == self.presentedViewController {
            let preferredContent = container.preferredContentSize
            return preferredContent
        } else {
            return super.size(forChildContentContainer: container, withParentContainerSize: parentSize)
        }
    }
    
    //
    override func containerViewWillLayoutSubviews(){
        super.containerViewDidLayoutSubviews()
        self.dimmingView.frame = self.containerView!.bounds
        self.presentedView?.frame = self.frameOfPresentedViewInContainerView
    }

    //通知表示控制器表示动画即将启动
    override func presentationTransitionWillBegin() {
        self.containerView?.insertSubview(self.dimmingView, at: 0)
        // transitionCoordinator 转场协调器，用于present 或 dissmiss 时协调其他动画
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        }, completion: { (context) in
            
        })
    }
    // 通知表示控制器表示动画已完成
    override func presentationTransitionDidEnd(_ completed: Bool) {
        if completed == false {
            dimmingView.removeFromSuperview()
        }
    }
    // 通知表示控制器解散动画即将开始
    override func dismissalTransitionWillBegin() {
//        print("通知表示控制器解散动画即将开始" + #function)
        self.presentedViewController.transitionCoordinator?.animate(alongsideTransition: { (context) in
            self.dimmingView.backgroundColor = UIColor.clear
        }, completion: { (context) in
            
        })
    }
    override func dismissalTransitionDidEnd(_ completed: Bool) {
//        print("通知表示控制器解散动画已完成" + #function)
        if completed == true {
            dimmingView.removeFromSuperview()
        }
    }
    
    @objc func dismissAction() {
        self.presentedViewController.dismiss(animated: true, completion: nil)
    }
}


/// 交互动画
class MKInteractiveTransition: UIPercentDrivenInteractiveTransition, UIGestureRecognizerDelegate {

    var viewController : UIViewController?
    var interative = false

    init(viewController:UIViewController) {
        super.init()
        self.viewController = viewController
        let pan = UIPanGestureRecognizer.init(target: self, action: #selector(handleGesture))
        pan.delegate = self
        viewController.view.addGestureRecognizer(pan)

    }

    @objc func handleGesture(panGesture: UIPanGestureRecognizer) {
        let transitionY = panGesture.translation(in: panGesture.view).y
        let persent = transitionY / (panGesture.view?.frame.height)!
        // 速度
        let speed = panGesture.velocity(in: panGesture.view)

        switch panGesture.state {
        case .began:
            self.interative = true
            self.viewController?.dismiss(animated: true, completion: nil)
            
        case .changed:
            self.update(persent)
        case .ended:
            self.interative = false
            if persent > 0.5 || speed.y > 920 {
                self.finish()
            }else {
                self.cancel()
            }
       
        default:
           break
        }
    }

}

public class HSCoverVerticalTransition: NSObject {
    
    var viewController : UIViewController?
    var interactive : MKInteractiveTransition?
    
    public init(present viewController:UIViewController) {
        super.init()
        self.viewController = viewController
        self.viewController!.modalPresentationStyle = .custom
    }
    public init(present viewController:UIViewController, dismiss enabal:Bool) {
        super.init()
        self.viewController = viewController
        self.viewController!.modalPresentationStyle = .custom
        if enabal {
            let interactive = MKInteractiveTransition.init(viewController: viewController)
            self.interactive = interactive
        }
    }
    
    // 过度动画
    func animateTransitionPresent(transitionContext: UIViewControllerContextTransitioning) {
//        if let to = transitionContext.viewController(forKey: .to){
            let to = transitionContext.viewController(forKey: .to)!
            transitionContext.containerView.addSubview(to.view)
            // 结束位置
            let finalFrame = transitionContext.finalFrame(for: to)
            to.view.frame = finalFrame
            to.view.transform = CGAffineTransform.init(translationX: 0, y: finalFrame.height)
            UIView.animate(withDuration: self.transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                to.view.transform = CGAffineTransform.init(translationX: 0, y: 0)
            }) { (finished) in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
//        }
    }
    
    func animateTransitionDismiss(transitionContext: UIViewControllerContextTransitioning) {
        if let from = transitionContext.viewController(forKey: .from) {
            let finalFrame = transitionContext.finalFrame(for: from)
            UIView.animate(withDuration: 0.25, animations: {
                from.view.transform = CGAffineTransform.init(translationX: 0, y: finalFrame.height)
            }) { (finished) in
                print(!transitionContext.transitionWasCancelled)
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        }

    }
    
}

extension HSCoverVerticalTransition: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
//    UIViewControllerAnimatedTransitioning
    // 转换动画的持续时间
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return (transitionContext?.isAnimated ?? false) ? 0.3 : 0.0
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if let to = transitionContext.viewController(forKey: .to) {
            if to.isBeingPresented {
                self.animateTransitionPresent(transitionContext: transitionContext)
            }
        }
        if let from = transitionContext.viewController(forKey: .from) {
            if from.isBeingDismissed {
                self.animateTransitionDismiss(transitionContext: transitionContext)
            }
        }
    }

//    UIViewControllerTransitioningDelegate

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self as UIViewControllerAnimatedTransitioning
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self as UIViewControllerAnimatedTransitioning
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return (self.interactive?.interative ?? false) ? self.interactive : nil
    }

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let vc = MKPresentationController.init(presentedViewController: presented, presenting: presenting)
        return vc
    }
    
}
