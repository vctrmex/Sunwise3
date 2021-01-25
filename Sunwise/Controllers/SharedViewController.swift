//
//  SharedViewController.swift
//  Sunwise
//
//  Created by victor manzanero on 22/01/21.
//

import UIKit
import SafariServices

class SharedViewController: UIViewController, SFSafariViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func compartir(_ sender: Any) {
        
        let text = "This is some text that I want to share."

                // set up activity view controller
                let textToShare = [ text ]
                let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

                // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func video(_ sender: Any) {
        
        guard let url = URL(string: "https://youtu.be/1B7-Ff-1Kos") else {
            // We should handle an invalid stringURL
            return
        }

        // Present SFSafariViewController
        let safariVC = SFSafariViewController(url: url)
        safariVC.delegate = self
        present(safariVC, animated: true, completion: nil)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
