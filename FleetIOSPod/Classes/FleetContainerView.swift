//
//  FleetContainerView.swift
//  FleetIOSPod
//
//  Created by Steve Sheets on 4/17/19.
//  Copyright © 2019 Steve Sheets. All rights reserved.
//

import UIKit

// MARK: Class

/// View to contain a UIViewController for Fleet
public class FleetContainerView: FleetView {
    
    // MARK: Typealias
    
    /// View Controller Fill Closure (passed UIViewController, returned nothing)
    public typealias ContainerFillClosure = (UIViewController?, UIViewController) -> Void

    // MARK: IBOutlets
    
    /// Parent View Controller
    @IBOutlet public weak var parentController: UIViewController?
    
    // MARK: Lazy Properties
    
    /// Stack of pushed View Controllers
    private lazy var lazyStack = [UIViewController]()
    
    // MARK: Properties
    
    /// Contains current topmost view controller
    public var bag: UIViewController? = nil
    
    /// Auto clear, or set bag view background to clear
    public var autoclearBag: Bool = true
    
    /// Animation style for push out
    public var animPushRemove = FleetView.animStyle.shiftLeft

    /// Animation style for push in
    public var animPushShow = FleetView.animStyle.shiftRight

    /// Animation style for pop out
    public var animPopRemove = FleetView.animStyle.shiftDown
    
    /// Animation style for pop in
    public var animPopShow = FleetView.animStyle.fade

    /// Cross anim for push?
    public var crossPush = UIView.animOverlay.async

    /// Cross anim for pop?
    public var crossPop = UIView.animOverlay.stagger
    
    /// Duration of normal fill animation
    public var animDuration = TimeInterval(0.5)

    // MARK: Public Methods
    
    /// Fill Container with named view controller from main storyboard
    ///
    /// - Parameter controller: name of view controller to load
    public func fill(controller: UIViewController, removeAnim:UIView.animStyle? = nil, showAnim:UIView.animStyle? = nil, crossOverlay: UIView.animOverlay? = nil, fillBlock: ContainerFillClosure? = nil) {
 
        func fillContinue(parentController: UIViewController, newController: UIViewController, oldBag: UIViewController?) {
            if autoclearBag {
                newController.view.backgroundColor = .clear
                newController.view.isOpaque = false
            }
            newController.view.isHidden = false
            parentController.addChild(newController)
            newController.view.frame = self.bounds
            self.addSubview(newController.view)

            NSLayoutConstraint.useAndActivateConstraints(constraints:[
                newController.view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                newController.view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                newController.view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                newController.view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
                ])

            newController.didMove(toParent: parentController)
 
            if let fillBlock = fillBlock {
                fillBlock(oldBag, newController)
            }
            if let outgoing = oldBag as? FleetViewController {
                outgoing.fillData(incomingController:newController)
            }
            if let incoming = newController as? FleetViewController, let oldBag = oldBag {
                incoming.fillData(outgingController: oldBag)
            }

            newController.view.animIn(withAnim: showAnim, withDuration: animDuration)
            
            bag = newController
        }

        if let parentController = parentController {
            let crossOverlay = crossOverlay ?? UIView.animOverlay.sync
            
            let oldBag = bag

            switch crossOverlay {
            case .stagger:
                 if let oldBag = oldBag {
                    oldBag.view.animOut(withAnim: removeAnim, withDuration: animDuration, withCompletion: {
                        oldBag.willMove(toParent: nil)
                        oldBag.view.removeFromSuperview()
                        oldBag.removeFromParent()
                    } )
                    
                    bag = nil
                }
                 
                 DispatchQueue.main.asyncAfter(deadline: .now() + animDuration*0.5) {
                    fillContinue(parentController: parentController, newController: controller, oldBag: oldBag)
                 }

            case .sync:
                if let oldBag = oldBag {
                    oldBag.view.animOut(withAnim: removeAnim, withDuration: animDuration, withCompletion: {
                        oldBag.willMove(toParent: nil)
                        oldBag.view.removeFromSuperview()
                        oldBag.removeFromParent()

                        fillContinue(parentController: parentController, newController: controller, oldBag: oldBag)
                    } )
                    
                    bag = nil
                }
                else {
                    fillContinue(parentController: parentController, newController: controller, oldBag: oldBag)
                }

            case .async:
                if let oldBag = oldBag {
                    oldBag.view.animOut(withAnim: removeAnim, withDuration: animDuration, withCompletion: {
                        oldBag.willMove(toParent: nil)
                        oldBag.view.removeFromSuperview()
                        oldBag.removeFromParent()
                    } )
                    
                    bag = nil
                }
                
                fillContinue(parentController: parentController, newController: controller, oldBag: oldBag)
            }
        }
    }
    
    /// Push named view controller onto stack
    ///
    /// - Parameter name: String with storyboard id
    /// - Returns: Returns View Controller created and pushed
    @discardableResult
    public func push(name: String, fillBlock: ContainerFillClosure? = nil) -> UIViewController? {
        if let mainStoryboad = g_fleet_root_view_controller?.mainStoryboad {
            let story = UIStoryboard(name: mainStoryboad, bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: name)
            
            push(controller:vc, fillBlock: fillBlock)
            
            return vc;
        }
        
        return nil;
    }

    /// Push view controller onto stack
    ///
    /// - Parameter controller: View Controller to push
    public func push(controller: UIViewController, fillBlock: ContainerFillClosure? = nil) {
        if let bag = bag {
            self.lazyStack.append(bag)
        }

        fill(controller: controller, removeAnim:animPushRemove, showAnim:animPushShow, crossOverlay: crossPush, fillBlock: fillBlock)
    }

    /// Pop container
    public func pop() {
        let old = self.lazyStack.removeLast()
        
        fill(controller: old, removeAnim:animPopRemove, showAnim:animPopShow, crossOverlay: crossPop)
    }

}


