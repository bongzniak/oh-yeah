import UIKit

extension UIFont {
    public static func regular(ofSize size: CGFloat) -> UIFont {
        DesignSystemFontFamily.Pretendard.regular.font(size: size)
    }
    
    public static func medium(ofSize size: CGFloat) -> UIFont {
        DesignSystemFontFamily.Pretendard.medium.font(size: size)
    }
    
    public static func bold(ofSize size: CGFloat) -> UIFont {
        DesignSystemFontFamily.Pretendard.bold.font(size: size)
    }
}
