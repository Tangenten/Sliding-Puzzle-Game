//
//  Image.swift
//  Puzzle Game
//
//  Created by Alfred Runn on 2018-11-09.
//  Copyright © 2018 Goobers. All rights reserved.
//

import Foundation
import CoreGraphics
import UIKit

class Image {
    /// Slice image into array of tiles
    ///
    /// - Parameters:
    ///   - image: The original image.
    ///   - howMany: How many rows/columns to slice the image up into.
    ///
    /// - Returns: An array of images.
    ///
    /// - Note: The order of the images that are returned will correspond
    ///         to the `imageOrientation` of the image. If the image's
    ///         `imageOrientation` is not `.up`, take care interpreting
    ///         the order in which the tiled images are returned.
    
    static func usage(imageString: String, howMany: Int) -> [UIImage]? {
        if let image = UIImage.init(named: imageString) {
            let picArray = self.slice(image: image, into: howMany)
            return picArray
        } else {
            print("Image Slicing error")
        }
        return nil
    }
    
    static func removeRotationForImage(image: UIImage) -> UIImage {
        if image.imageOrientation == UIImage.Orientation.up {
            return image
        }
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        image.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: image.size))
        let normalizedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    static func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        let cgImage = image.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    
    //MARK: -
    static func createAPIImageDirectory() {
        let fileManager = FileManager.default
        if let tDocumentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath =  tDocumentDirectory.appendingPathComponent("APIImages")
            if !fileManager.fileExists(atPath: filePath.path) {
                do {
                    try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                } catch {
                    NSLog("Couldn't create document directory")
                }
            }
            NSLog("Document directory is \(filePath)")
        }
    }
    
    //MARK: -
    static func getImageURLsFromAPIImageDirectory() -> [URL]? {
        var stringArray = [String]()
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL.appendingPathComponent("APIImages"), includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        return nil
    }
    
    //MARK: -
    static func getImagePathsFromAPIImageDirectory() -> [String] {
        let urls = self.getImageURLsFromAPIImageDirectory()
        var stringArray = [String]()
        for url in urls! {
            let string = url.absoluteString
            string.dropFirst(6)
            stringArray.append(string)
        }
        return stringArray
    }
    
    //MARK: -
    static func clearAPIImageDirectory() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let diskCacheStorageBaseUrl = myDocuments.appendingPathComponent("APIImages")
        guard let filePaths = try? fileManager.contentsOfDirectory(at: diskCacheStorageBaseUrl, includingPropertiesForKeys: nil, options: []) else { return }
        for filePath in filePaths {
            try? fileManager.removeItem(at: filePath)
        }
    }
    //MARK: - 
    static func saveImageToAPIImageDirectory(image: UIImage, name: String) -> String {
        // get the documents directory url
        //let apiDir = Bundle.main.resourceURL!.appendingPathComponent("APIImages").path
        //Bundle.main.paths(forResourcesOfType: "jpg", inDirectory: "Images")
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        // choose a name for your image
        let fileName = name
        // create the destination file url to save your image
        let fileURL = documentsDirectory.appendingPathComponent("APIImages").appendingPathComponent(fileName)
        // get your UIImage jpeg data representation and check if the destination file url already exists
        if let data = image.jpegData(compressionQuality: 1),
            !FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                // writes the image data to disk
                try data.write(to: fileURL.appendingPathExtension("jpg"))
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
        return fileURL.absoluteString
    }
    
}
