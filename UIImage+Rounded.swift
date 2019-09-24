import UIKit

extension UIImage {

    func scaleImageToSize(newSize: CGSize) -> UIImage? {
        let widthRatio = newSize.width / size.width
        let heightRatio = newSize.height / size.height
        let ratio = max(widthRatio, heightRatio)
        
        var scaledImageRectangle = CGRect.zero
        scaledImageRectangle.size.width = size.width * ratio
        scaledImageRectangle.size.height = size.height * ratio
        scaledImageRectangle.origin.x = (newSize.width - scaledImageRectangle.size.width) / 2
        scaledImageRectangle.origin.y = (newSize.height - scaledImageRectangle.size.height) / 2
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        draw(in: scaledImageRectangle)
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return scaledImage
    }
    
    func roundedToRadius(_ radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
