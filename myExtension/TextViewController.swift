//
//  TextViewController.swift
//  myExtension
//
//  Created by Engin KUK on 15.12.2020.
//

import UIKit

class TextViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    @IBAction func cancelAction(_ sender: Any) {
        shareVC?.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
    }
    
    @IBAction func nextAction(_ sender: Any) {
        shareVC?.textNextButtonPressed()
    }
    
    
    var shareVC : ShareViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shareVC = self.parent?.parent as? ShareViewController
        // Do any additional setup after loading the view.
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
