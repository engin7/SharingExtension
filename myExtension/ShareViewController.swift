import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var imageType = ""
    var textType = "public.text"
    
    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }
    
    override func didSelectPost() {
       
             print("In Did Post")
                 if let item = self.extensionContext?.inputItems[0] as? NSExtensionItem{
                     print("Item \(item)")
                     for ele in item.attachments!{
                         print("item.attachments!======&gt;&gt;&gt; \(ele as! NSItemProvider)")
                         let itemProvider = ele as! NSItemProvider
                         print(itemProvider)
                         if itemProvider.hasItemConformingToTypeIdentifier("public.jpeg"){
                             imageType = "public.jpeg"
                         }
                         if itemProvider.hasItemConformingToTypeIdentifier("public.png"){
                              imageType = "public.png"
                         }
                         print("imageType\(imageType)")
                         
                        
                        
                             if itemProvider.hasItemConformingToTypeIdentifier(textType){
                            
                                    print("importing text")
                            
                                    itemProvider.loadItem(forTypeIdentifier: textType, options: nil, completionHandler: { (item, error) in
                                       
                                        print("Text item ===\(item)")
                                        
                                        
                                        
                                    })
                                }
                     
 
                         if itemProvider.hasItemConformingToTypeIdentifier(imageType){
                             print("True")
                             itemProvider.loadItem(forTypeIdentifier: imageType, options: nil, completionHandler: { (item, error) in
                                 
                                 var imgData: Data!
                                 if let url = item as? URL{
                                     imgData = try! Data(contentsOf: url)
                                 }
                                 
                                 if let img = item as? UIImage{
                                    imgData = img.pngData()
                                 }
                                 print("Item ===\(item)")
                                 print("Image Data=====. \(imgData))")
                                 let dict: [String : Any] = ["imgData" :  imgData, "name" : self.contentText]
                                 let savedata =  UserDefaults.init(suiteName: "group.engin.SharingExtension")
                                 savedata?.set(dict, forKey: "img")
                                 savedata?.synchronize()
                                 print("ImageData \(String(describing: savedata?.value(forKey: "img")))")
                             })
                         }
                     }
                    
                 }
             }
   

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
