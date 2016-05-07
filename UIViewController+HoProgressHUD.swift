//
//  UIViewController+HoHUD.swift
//  TaoLueFM
//
//  Created by ZanderHo on 16/4/29.
//  Copyright © 2016年 ZanderHo. All rights reserved.
//

import UIKit

typealias HoHudIdentifier = Int

extension UIViewController {
    
    private func ho_delayOnMainQueueWithSeconds(seconds: Double, task: (() -> ())?) {
        let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * seconds))
        
        dispatch_after(popTime, dispatch_get_main_queue()) {
            
            if let completion = task {
                completion()
            }
            
        }
    }
    
    
    func ho_showHUDWithText(text: String?, duration: Double) {
        guard let messageText = text else {
            return
        }
        
        let bgView: UIView = {
            
            let bgView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0))
            bgView.backgroundColor = UIColor.clearColor()
            bgView.translatesAutoresizingMaskIntoConstraints = false
            bgView.alpha = 0.0
            
            return bgView
            
        }()
        
        var parentView = self.view
        
        //MARK: 在UITableViewController上, 对于self.tableView不能加约束布局
        if self.view is UITableView {
            parentView = UIApplication.sharedApplication().keyWindow
        }
        
        parentView.addSubview(bgView)
        
        let top = NSLayoutConstraint(item: bgView, attribute: .Top, relatedBy: .Equal, toItem: parentView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: bgView, attribute: .Leading, relatedBy: .Equal, toItem: parentView, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: bgView, attribute: .Bottom, relatedBy: .Equal, toItem: parentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: bgView, attribute: .Trailing, relatedBy: .Equal, toItem: parentView, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activateConstraints([top, leading, bottom, trailing])
        
        
        //
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(16.0)]
        let rect = messageText.boundingRectWithSize(CGSize(width: 300.0, height: 21.0), options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        
        let width = CGRectGetWidth(rect) + 30.0
        let height = CGRectGetHeight(rect) + 30.0
        
        let transparentView: UIView = {
            
            let transparentView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
            transparentView.backgroundColor = UIColor.blackColor()
            transparentView.alpha = 0.7
            transparentView.translatesAutoresizingMaskIntoConstraints = false
            transparentView.layer.cornerRadius = 5.0
            transparentView.layer.masksToBounds = true
            
            let widthConstraint = NSLayoutConstraint(item: transparentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width)
            let heightConstraint = NSLayoutConstraint(item: transparentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
            NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint])
            
            return transparentView
            
        }()
        bgView.addSubview(transparentView)
        
        let centerX = NSLayoutConstraint(item: transparentView, attribute: .CenterX, relatedBy: .Equal, toItem: bgView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: transparentView, attribute: .CenterY, relatedBy: .Equal, toItem: bgView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activateConstraints([centerX, centerY])
        
        
        //
        let label: UILabel = {
            
            let label = UILabel(frame: CGRect(x: 15.0, y: 15.0, width: CGRectGetWidth(rect), height: CGRectGetHeight(rect)))
            label.translatesAutoresizingMaskIntoConstraints = false
            label.backgroundColor = UIColor.clearColor()
            label.textAlignment = .Center
            label.font = UIFont.systemFontOfSize(15.0)
            label.textColor = UIColor.whiteColor()
            label.text = messageText
            return label
            
        }()
        
        bgView.addSubview(label)
        
        let labelCenterX = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: bgView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let labelCenterY = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: bgView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        let labelLeading = NSLayoutConstraint(item: label, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: transparentView, attribute: .Leading, multiplier: 1.0, constant: 10.0)
        let labelTrailing = NSLayoutConstraint(item: label, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: transparentView, attribute: .Trailing, multiplier: 1.0, constant: -10.0)
        NSLayoutConstraint.activateConstraints([labelCenterX, labelCenterY, labelLeading, labelTrailing])
        
        //
        UIView.animateWithDuration(0.3, animations: {
            
            bgView.alpha = 1.0
            
        }) { (finish) in
            
            self.hz_delayOnMainQueueWithSeconds(duration, task: {
                
                UIView.animateWithDuration(0.3, animations: {
                    
                    bgView.alpha = 0.0
                    
                    }, completion: { (finish) in
                        
                        bgView.removeFromSuperview()
                        
                })
                
            })
            
        }
    }
    
    func ho_showLoadingHUD() -> HoHudIdentifier {
        let bgView: UIView = {
            
            let bgView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320.0, height: 568.0))
            bgView.backgroundColor = UIColor.clearColor()
            bgView.translatesAutoresizingMaskIntoConstraints = false
            bgView.alpha = 0.0
            
            return bgView
            
        }()
        
        var parentView = self.view
        
        //MARK: 在UITableViewController上, 对于self.tableView不能加约束布局
        if self.view is UITableView {
            parentView = UIApplication.sharedApplication().keyWindow
        }
        
        parentView.addSubview(bgView)
        
        let min: UInt32 = 40000
        let max: UInt32 = 50000
        var viewTag = Int(arc4random_uniform(max - min) + min)
        var checkView = parentView.viewWithTag(viewTag)
        while checkView != nil {
            #if DEBUG
                print("\(#function), tag: \(viewTag)")
            #endif
            
            viewTag = Int(arc4random_uniform(max - min) + min)
            checkView = parentView.viewWithTag(viewTag)
        }
        
        let foundIndentifier = viewTag
        bgView.tag = foundIndentifier
        
        
        let top = NSLayoutConstraint(item: bgView, attribute: .Top, relatedBy: .Equal, toItem: parentView, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let leading = NSLayoutConstraint(item: bgView, attribute: .Leading, relatedBy: .Equal, toItem: parentView, attribute: .Leading, multiplier: 1.0, constant: 0.0)
        let bottom = NSLayoutConstraint(item: bgView, attribute: .Bottom, relatedBy: .Equal, toItem: parentView, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        let trailing = NSLayoutConstraint(item: bgView, attribute: .Trailing, relatedBy: .Equal, toItem: parentView, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activateConstraints([top, leading, bottom, trailing])
        
        
        //
        let width: CGFloat = 60.0
        let height: CGFloat = 60.0
        let transparentView: UIView = {
            
            let transparentView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: width, height: height))
            transparentView.backgroundColor = UIColor.blackColor()
            transparentView.alpha = 0.7
            transparentView.translatesAutoresizingMaskIntoConstraints = false
            transparentView.layer.cornerRadius = 5.0
            transparentView.layer.masksToBounds = true
            
            let widthConstraint = NSLayoutConstraint(item: transparentView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: width)
            let heightConstraint = NSLayoutConstraint(item: transparentView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: height)
            NSLayoutConstraint.activateConstraints([widthConstraint, heightConstraint])
            
            return transparentView
            
        }()
        bgView.addSubview(transparentView)
        
        let centerX = NSLayoutConstraint(item: transparentView, attribute: .CenterX, relatedBy: .Equal, toItem: bgView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let centerY = NSLayoutConstraint(item: transparentView, attribute: .CenterY, relatedBy: .Equal, toItem: bgView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activateConstraints([centerX, centerY])
        
        
        //
        let indicator: UIActivityIndicatorView = {
            
            let indicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.startAnimating()
            return indicator
            
        }()
        bgView.addSubview(indicator)
        
        let indicatorCenterX = NSLayoutConstraint(item: indicator, attribute: .CenterX, relatedBy: .Equal, toItem: bgView, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
        let indicatorCenterY = NSLayoutConstraint(item: indicator, attribute: .CenterY, relatedBy: .Equal, toItem: bgView, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
        NSLayoutConstraint.activateConstraints([indicatorCenterX, indicatorCenterY])
        
        self.view.layoutIfNeeded()
        
        //
        UIView.animateWithDuration(0.3) {
            
            bgView.alpha = 1.0
            
        }
        
        return foundIndentifier
    }
    
    
    func ho_dismissLoadingHUDWithIdentifier(identifier: HoHoHudIdentifier, afterDelaySeconds seconds: Double, animated: Bool) {
        var parentView = self.view
        if self.view is UITableView {
            parentView = UIApplication.sharedApplication().keyWindow
        }
        
        let hud = parentView.viewWithTag(identifier)
        if let foundHud = hud {
            if animated {
                self.hz_delayOnMainQueueWithSeconds(seconds, task: { 
                    
                    UIView.animateWithDuration(0.3, animations: { 
                        
                        foundHud.alpha = 0.0
                        
                        }, completion: { (finish) in
                            
                            foundHud.removeFromSuperview()
                            
                    })
                    
                })
            }
            else {
                self.hz_delayOnMainQueueWithSeconds(seconds, task: { 
                    
                    foundHud.removeFromSuperview()
                    
                })
            }
        }
    }
    
}