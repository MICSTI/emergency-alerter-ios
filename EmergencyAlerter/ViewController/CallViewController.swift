//
//  CallViewController.swift
//  EmergencyAlerter
//
//  Created by Mayerhofer Florian on 17/11/2017.
//  Copyright © 2017 T11. All rights reserved.
//


import UIKit

class CallViewController: UIViewController {
    
    @IBOutlet weak var CallButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // add click target to call button
        CallButton.addTarget(self, action: #selector(self.callButtonClicked), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func callButtonClicked() {
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.autoreverse],
                    animations: {
                        UIView.setAnimationRepeatCount(5)
                        
                        self.CallButton.transform = CGAffineTransform(scaleX: 0.45, y: 0.45)
                        self.CallButton.backgroundColor = UIColor.red
                    },
                    completion: { _ in
                        self.CallButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.CallButton.backgroundColor = UIColor(red: 192.0 / 255.0, green: 57.0 / 255.0, blue: 43.0 / 255.0, alpha: 1.0)
                    }
        )
        
        
    }
}

