import UIKit
import Social
import MobileCoreServices

class ShareViewController: SLComposeServiceViewController {
    
    var imageType = ""
    var textType = "public.text"
    var savedata = UserDefaults.init(suiteName: "group.engin.SharingExtension")
    
    // computed property
    var importedElementsArray: [[String : Any]] {
        get {
            return savedata?.value(forKey: "imported") as? [[String : Any]] ?? []
        }
        set {
            savedata?.set(newValue, forKey: "imported")
            savedata?.synchronize()
        }
    }
    
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
                         
                         if itemProvider.hasItemConformingToTypeIdentifier(textType){
                        
                                print("importing text")
                        
                            itemProvider.loadItem(forTypeIdentifier: textType, options: nil, completionHandler: { [self] (item, error) in
                                   
                                    print("Text item ===\(item)")
                                    
                                    let dict: [String : Any] = ["text" :  item]
                                    importedElementsArray.append(dict)
                                    
                                    print("TextData \(String(describing: savedata?.value(forKey: "imported")))")

                                })
                            }
                     
                         if itemProvider.hasItemConformingToTypeIdentifier(imageType){
                             print("True")
                            itemProvider.loadItem(forTypeIdentifier: imageType, options: nil, completionHandler: { [self] (item, error) in
                                 
                                 var imgData: Data!
                                 if let url = item as? URL{
                                     imgData = try! Data(contentsOf: url)
                                 }
                                 if let img = item as? UIImage{
                                    imgData = img.pngData()
                                 }
                                 print("Item ===\(item)")
                                 print("Image Data=====. \(imgData))")
                                let dict: [String : Any] = [ "imageData" : imgData, "imageText" : self.contentText]
                                 importedElementsArray.append(dict)
                                 print("ImageData \(String(describing: savedata?.value(forKey: "imported")))")
                             })
                         }
                     }
                 }
        
             self.openURL(url: NSURL(string:"containerapp://HomeVC")!)
            self.extensionContext?.completeRequest(returningItems: [], completionHandler:nil)
 
             }
   

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

    func openURL(url: NSURL) -> Bool {
        do {
            let application = try self.sharedApplication()
            return application.performSelector(inBackground: "openURL:", with: url) != nil
        }
        catch {
            return false
        }
    }

    func sharedApplication() throws -> UIApplication {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                return application
            }

            responder = responder?.next
        }

        throw NSError(domain: "UIInputViewController+sharedApplication.swift", code: 1, userInfo: nil)
    }
    
    
}
