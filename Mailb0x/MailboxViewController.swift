//
//  MailboxViewController.swift
//  Mailb0x
//
//  Created by Eric Eriksson on 11/2/14.
//  Copyright (c) 2014 Eric Eriksson. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {

    @IBOutlet weak var menuVIew: UIImageView!
    @IBOutlet var totalView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var laterIconView: UIImageView!
    @IBOutlet weak var archiveIconView: UIImageView!
    @IBOutlet weak var feedImageView: UIImageView!
    @IBOutlet weak var reView: UIView!
    
    var originalLocation: CGPoint!
    var originalContentOrigin: CGPoint!
    
    @IBOutlet weak var messageContainerView: UIImageView!
    @IBOutlet weak var feedScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // makes things scrollable
        feedScrollView.contentSize = CGSize(width: 320, height: 1450)
        
        // sets reschedule modal opacity to 0
        reView.alpha = 0

        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        totalView.addGestureRecognizer(edgeGesture)
        
    }
    
    // Pan gesture recognizer and lots of conditionals
    @IBAction func onPan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        laterIconView.alpha = 1
        archiveIconView.alpha = 1

        if sender.state == UIGestureRecognizerState.Began {
            println("Began")
            originalLocation = location
            originalContentOrigin = messageContainerView.frame.origin
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            // Corrects center anchoring - moves message cell relative to finger position
            var newOrigin = originalContentOrigin.x + location.x - originalLocation.x
            messageContainerView.frame.origin.x = newOrigin
            
            // Icon positions follow message cell panning
            laterIconView.frame.origin.x = newOrigin + 330
            archiveIconView.frame.origin.x = newOrigin - 40
            

            
        } else if sender.state == UIGestureRecognizerState.Ended {
            println("Ended")
            var xOrigin = CGFloat(0)
            var iconAlpha = CGFloat(1)
            var shouldCollapse = Bool(false)
            var shouldReView = Bool(false)
            var feedOrigin = feedImageView.frame.origin.y
            
            // If gesture ends at location <= 60, animate left swipe and trigger reschedule modal
            if location.x <= 60 {
                xOrigin = -320
                iconAlpha = 0
                shouldReView = true
                
            // If gesture ends at location >= 260, animate right swipe and trigger collapse
            } else if location.x >= 260 {
                xOrigin = 640
                iconAlpha = 0
                shouldCollapse = true
            
            // If none of the above conditions are met, return message cell to original position
            } else {
                xOrigin = 0
            }
            
            // Make above transforms happen with animationary effects
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.messageContainerView.frame.origin.x = xOrigin
                self.laterIconView.alpha = iconAlpha
                self.archiveIconView.alpha = iconAlpha
                
                if shouldCollapse == true {
                    self.contentView.frame.size = CGSize(width: 0, height: 86)
                    self.feedImageView.frame.origin.y = feedOrigin-86
                }
                
                if shouldReView == true {
                    self.reView.alpha = 1
                }
            })
            
        }
    }
    
    // Reschedule overlay functionality
    @IBAction func onOverlayBtn(sender: AnyObject) {
        var feedOrigin = feedImageView.frame.origin.y
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.reView.alpha = 0
            self.contentView.frame.size = CGSize(width: 0, height: 86)
            self.feedImageView.frame.origin.y = feedOrigin-86

        })
    }
    
    // Edge Pan menu revealer
    @IBAction func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        var location = sender.locationInView(view)
        var xOrigin = CGFloat(0)

        
        if sender.state == UIGestureRecognizerState.Changed {
            originalLocation = location
            originalContentOrigin = messageContainerView.frame.origin
            
            totalView.frame.origin.x = originalLocation.x
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            if location.x >= 150 {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.totalView.frame.origin.x = 280
                })
                
            } else if location.x >= 270 {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                    self.totalView.frame.origin.x = 0
                })
            
            } else {
                UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.totalView.frame.origin.x = 0
                })
            }
        }
    }
    
    // return menu to closed position
    @IBAction func onMenuBtn(sender: AnyObject) {
        println("boo")
        UIView.animateWithDuration(0.4, animations: { () -> Void in
                self.totalView.frame.origin.x = 0
            })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
