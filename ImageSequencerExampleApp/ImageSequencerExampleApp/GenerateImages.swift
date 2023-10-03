import Foundation
import UIKit
import CoreImage

enum GenerateImages {
    
    static func generate(with size: CGSize, numberOfImages: Int, frameGenerated: (Int) -> ()) -> [URL] {
        var images: [URL] = []
            for i in 1...numberOfImages {
                autoreleasepool {
                    let image = UIGraphicsImageRenderer(size: size).image { rendererContext in
                        UIColor.black.setFill()
                        rendererContext.fill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
                        let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.alignment = NSTextAlignment.center
                        "\(i)".draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height),
                                    withAttributes: [.font: UIFont.systemFont(ofSize: size.width / 2),
                                                     .foregroundColor: UIColor.white,
                                                     .paragraphStyle: paragraphStyle])
                    }
                    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                    if let filePath = paths.first?.appendingPathComponent("\(i).jpeg") {
                        try? image.jpegData(compressionQuality: 0.9)?.write(to: filePath, options: .atomic)
                        images.append(filePath)
                        frameGenerated(i)
                    }
                }                
            }
        return images
    }
}
