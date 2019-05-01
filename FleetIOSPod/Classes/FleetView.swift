//
//  FleetView.swift
//  FleetIOSPod
//
//  Created by Steve Sheets on 4/15/19.
//

import UIKit

// MARK: Global Variables

/// Default animatiomn style for in animation.
public var g_fleet_view_default_in_animatin = UIView.animStyle.fade

/// Default animatiomn style for out animation.
public var g_fleet_view_default_out_animatin = UIView.animStyle.fade

// MARK: Extensions

// Extension to UIView for animation
extension UIView {
    
    // MARK: Enum
    
    /// Different styles of view animation
    ///
    /// - fade: Simple Disolve
    /// - shiftLeft: shift leftward
    /// - shiftRight: shift rightward
    /// - shiftUp: shift upward
    /// - shiftDown: shift downward
    public enum animStyle {
        case fade
        case shiftLeft
        case shiftRight
        case shiftUp
        case shiftDown
    }
    
    /// Different cross overlay of view animation
    ///
    /// - sync: sequential
    /// - async: simultanious
    /// - staggered: out start, 50% of time, in starts
    public enum animOverlay {
        case sync
        case async
        case stagger
    }
    
    // MARK: Public Methods
    
    /// Hide the visible view in animated manner
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    ///   - anim: type of animation
    public func animOut(withAnim anim:animStyle? = nil,
                        withDuration duration: TimeInterval = 1.5,
                        withCompletion block:FleetView.SimpleClosure? = nil) {
        let anim = anim ?? animStyle.fade
        
        switch anim {
        case .fade:
            animFadeOut(withDuration: duration, withCompletion: block)
        case .shiftLeft:
            animShiftLeftOut(withDuration: duration, withCompletion: block)
        case .shiftRight:
            animShiftRightOut(withDuration: duration, withCompletion: block)
        case .shiftUp:
            animShiftTopOut(withDuration: duration, withCompletion: block)
        case .shiftDown:
            animShiftBottomOut(withDuration: duration, withCompletion: block)
        }
    }
    
    /// Show the hidden view in animated manner
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    ///   - anim: type of animation
    public func animIn(withAnim anim:animStyle? = nil,
                       withDuration duration: TimeInterval = 1.5,
                       withCompletion block:FleetView.SimpleClosure? = nil) {
        let useAnim = anim ?? animStyle.fade
        
        switch useAnim {
        case .fade:
            animFadeIn(withDuration: duration, withCompletion: block)
        case .shiftLeft:
            animShiftLeftIn(withDuration: duration, withCompletion: block)
        case .shiftRight:
            animShiftRightIn(withDuration: duration, withCompletion: block)
        case .shiftUp:
            animShiftTopIn(withDuration: duration, withCompletion: block)
        case .shiftDown:
            animShiftBottomIn(withDuration: duration, withCompletion: block)
        }
    }
    
    /// Hide the visible view in a fade manner.
    /// Starting witha visible view, fade it out (alpha to zero, then hide, and reset alpha back to 1)
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animFadeOut(withDuration duration: TimeInterval = 1.5,
                            withCompletion block:FleetView.SimpleClosure? = nil) {
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 0.0},
                       completion: { finished in
                        self.isHidden = true
                        self.alpha = 1.0
                        
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Show the hidden view in a fade manner.
    /// Starting witha hidden view, fade it in (alpha to 0, unhide, alpha to 1)
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animFadeIn(withDuration duration: TimeInterval = 1.5,
                           withCompletion block:FleetView.SimpleClosure? = nil) {
        alpha = 0.0
        isHidden = false;
        UIView.animate(withDuration: duration,
                       animations: { self.alpha = 1.0},
                       completion: { finished in
                        if let block = block {
                            block()
                        }
        } )
    }
    
    
    /// Hide the visible view in a shirt right manner.
    /// Starting witha visible view, shift it outside, hide it, place it in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftRightOut(withDuration duration: TimeInterval = 1.5,
                                  withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.x = centerSpot.x + FleetRootViewController.RootWidth()
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = hiddenSpot},
                       completion: { finished in
                        self.isHidden = true
                        self.center = centerSpot
                        
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Show the hidden view in a shirt right manner.
    /// Starting witha hidden view, place it outside, show it, shift in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftRightIn(withDuration duration: TimeInterval = 1.5,
                                 withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.x = centerSpot.x + FleetRootViewController.RootWidth()
        self.center = hiddenSpot
        isHidden = false;
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = centerSpot },
                       completion: { finished in
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Hide the visible view in a shirt left manner.
    /// Starting witha visible view, shift it outside, hide it, place it in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftLeftOut(withDuration duration: TimeInterval = 1.5,
                                 withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.x = centerSpot.x - FleetRootViewController.RootWidth()
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = hiddenSpot},
                       completion: { finished in
                        self.isHidden = true
                        self.center = centerSpot
                        
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Show the hidden view in a shirt left manner.
    /// Starting witha hidden view, place it outside, show it, shift in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftLeftIn(withDuration duration: TimeInterval = 1.5,
                                withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.x = centerSpot.x - FleetRootViewController.RootWidth()
        self.center = hiddenSpot
        isHidden = false;
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = centerSpot },
                       completion: { finished in
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Hide the visible view in a shirt right manner.
    /// Starting witha visible view, shift it outside, hide it, place it in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftTopOut(withDuration duration: TimeInterval = 1.5,
                                withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.y = centerSpot.y + FleetRootViewController.RootHeight()
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = hiddenSpot},
                       completion: { finished in
                        self.isHidden = true
                        self.center = centerSpot
                        
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Show the hidden view in a fade manner.
    /// Starting witha hidden view, place it outside, show it, shift in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftTopIn(withDuration duration: TimeInterval = 1.5,
                               withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.y = centerSpot.y + FleetRootViewController.RootHeight()
        self.center = hiddenSpot
        isHidden = false;
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = centerSpot },
                       completion: { finished in
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Hide the visible view in a fade manner.
    /// Starting witha visible view, shift it outside, hide it, place it in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftBottomOut(withDuration duration: TimeInterval = 1.5,
                                   withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.y = centerSpot.y - FleetRootViewController.RootHeight()
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = hiddenSpot},
                       completion: { finished in
                        self.isHidden = true
                        self.center = centerSpot
                        
                        if let block = block {
                            block()
                        }
        } )
    }
    
    /// Show the hidden view in a fade manner.
    /// Starting witha hidden view, place it outside, show it, shift in
    ///
    /// - Parameters:
    ///   - block: CLosure to invoke after animation is done
    ///   - duration: duration of animation
    public func animShiftBottomIn(withDuration duration: TimeInterval = 1.5,
                                  withCompletion block:FleetView.SimpleClosure? = nil) {
        let centerSpot = center
        var hiddenSpot = center
        hiddenSpot.y = centerSpot.y - FleetRootViewController.RootHeight()
        self.center = hiddenSpot
        isHidden = false;
        
        UIView.animate(withDuration: duration,
                       animations: { self.center = centerSpot },
                       completion: { finished in
                        if let block = block {
                            block()
                        }
        } )
    }
}

// Extension to UIView for Layout Constraints
extension NSLayoutConstraint {
    
    /// Class function to activate contraints, as well as setting appropriate views translatesAutoresizingMaskIntoConstraints to false.
    ///
    /// - Parameter constraints: Array of NSLayoutConstraint to activate
    public class func useAndActivateConstraints(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            if let view = constraint.firstItem as? UIView {
                view.translatesAutoresizingMaskIntoConstraints = false
            }
        }
        activate(constraints)
    }
}



// MARK: Class Methods

/// View class for Fleet
public class FleetView: UIView {
    
    // MARK: Typealias
    
    /// Simpliest Closure (passed nothing, returned nothing)
    public typealias SimpleClosure = () -> Void
    
}
