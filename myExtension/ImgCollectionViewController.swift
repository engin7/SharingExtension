//
//  CollectionViewController.swift
//  myExtension
//
//  Created by Engin KUK on 14.12.2020.
//

import UIKit
  
class ImgCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
     
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func cancelAction(_ sender: Any) {
        shareVC?.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)

    }
    
    @IBAction func nextAction(_ sender: Any) {
        shareVC?.nextButton()
    }
    
    var shareVC : ShareViewController?
    var imageSet: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        shareVC = self.parent?.parent as? ShareViewController
//        collectionView.isHidden = true
        // Do any additional setup after loading the view.
    }
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath)
        let image = imageSet[indexPath.row]
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.contents = image.cgImage
        return cell
    }

}
