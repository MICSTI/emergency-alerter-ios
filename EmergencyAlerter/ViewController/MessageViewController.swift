/*
 Copyright (C) 2017 by F. Mayerhofer, M. Stifter & A. Butja
 
 Abstract:
    A view controller that lets the user send emergency text messages to preconfigured emergency contacts.
 */


import UIKit

class MessageViewController: UIViewController {
    
    @IBOutlet weak var MessageButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // add click target to call button
        MessageButton.addTarget(self, action: #selector(self.messageButtonClicked), for: .touchUpInside)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func messageButtonClicked() {
        UIView.animate(withDuration: 1.0,
                       delay: 0,
                       options: [.autoreverse],
                       animations: {
                        UIView.setAnimationRepeatCount(5)
                        
                        self.MessageButton.transform = CGAffineTransform(scaleX: 0.45, y: 0.45)
                        self.MessageButton.backgroundColor = UIColor(red: 249.0 / 255.0, green: 105.0 / 255.0, blue: 14.0 / 255.0, alpha: 1.0)
        },
                       completion: { _ in
                        self.MessageButton.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                        self.MessageButton.backgroundColor = UIColor(red: 211.0 / 255.0, green: 84.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0)
        }
        )
        
        
    }
}


