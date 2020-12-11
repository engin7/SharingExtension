//
//  ViewController.swift
//  SharingExtension
//
//  Created by Engin KUK on 10.12.2020.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    var importedElements: [Any] = []
    
    let userDefaults = UserDefaults()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let data = userDefaults.object(forKey: "data") ?? UIImage()
        importedElements.append(data)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        importedElements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath as IndexPath)
        // text or image
        cell.layer.contents = (importedElements[indexPath.row] as AnyObject).cgImage as Any?
//        cell.textLabel?.text = importedElements[indexPath.row] as? String
        return cell
    }
    
    
    func importElements(url: URL) {
        

        
        
    }
     

}

