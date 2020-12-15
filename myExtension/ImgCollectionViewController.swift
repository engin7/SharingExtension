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
        shareVC?.imageNextButtonPressed()
    }
    
    var shareVC : ShareViewController?
    var imageSet: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        shareVC = self.parent?.parent as? ShareViewController

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

extension ImgCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        var height:CGFloat
        var width:CGFloat
        
        if imageSet.count == 1 {
            width  = collectionView.frame.width-30
            height = collectionView.frame.height-70
            return CGSize(width: width, height: height)
        } else {
            width  = collectionView.frame.width/2-30
            height = collectionView.frame.height/2-70
            return CGSize(width: width, height: height)
        }
    }
    
}
