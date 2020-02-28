//
//  ImageFunctions.swift
//  
//
//  Created by TRIMECH on 23/03/2018.
//

import UIKit

class ImageFunctions: NSObject {
    //compression image

    class func convertImageToBase64(image: UIImage) -> (String) {
        
        let comressedImage = scaleUIImageToSize(image: image,size:CGSize(width: 300, height: 300))
        var imageData  = UIImageJPEGRepresentation(comressedImage,0.0)
        
        
        let base64StringToEncrypt = imageData?.base64EncodedString(options: .lineLength64Characters)
        
        return base64StringToEncrypt!
        
    }// end convertImageToBase64
    
    
    
    // convert images into base64 and keep them into string
    
    class func convertBase64ToImage(base64String: String) -> UIImage {
        let decodedimage: UIImage!
       let password = "azdrezcldkdk123dkdbnchpeqwxdplke" // returns random 32 char string
      let decrypted = AES256CBC.decryptString(base64String, password: password)

        let dataDecoded : Data = Data(base64Encoded: decrypted!, options: .ignoreUnknownCharacters)!
        decodedimage = UIImage(data: dataDecoded)
        
        return decodedimage
        
    }
    // end convertBase64ToImage
    class func scaleUIImageToSize(image: UIImage,size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
                UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        image.draw(in: CGRect(origin: .zero, size: size))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return (scaledImage)!
    }
    
}


