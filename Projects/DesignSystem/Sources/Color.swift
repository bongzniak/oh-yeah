
import UIKit

public typealias OHColor = UIColor

extension UIColor {
    // MARK:  Overlay
    /// #000000, 0.2
    public static var overlay1: OHColor {
        DesignSystemAsset.Colors.overlay1.color
    }
    /// #000000, 0.5
    public static var overlay2: OHColor {
        DesignSystemAsset.Colors.overlay2.color
    }
    /// #000000, 0.8
    public static var overlay3: OHColor {
        DesignSystemAsset.Colors.overlay3.color
    }
    
    // MARK:  Theme basic
    public static var ohWhite: OHColor {
        DesignSystemAsset.Colors.white.color
    }
    public static var ohBlack: OHColor {
        DesignSystemAsset.Colors.black.color
    }
    
    // MARK:  Theme gray
    /// #FBFBFD
    public static var gray1: OHColor {
        DesignSystemAsset.Colors.gray1.color
    }
    /// #F7F7F9
    public static var gray2: OHColor {
        DesignSystemAsset.Colors.gray2.color
    }
    /// #EBEBF1
    public static var gray3: OHColor {
        DesignSystemAsset.Colors.gray3.color
    }
    /// #D5D5DE
    public static var gray4: OHColor {
        DesignSystemAsset.Colors.gray4.color
    }
    /// #BAB9C6
    public static var gray5: OHColor {
        DesignSystemAsset.Colors.gray5.color
    }
    /// #A4A3AE
    public static var gray6: OHColor {
        DesignSystemAsset.Colors.gray6.color
    }
    /// #72717D
    public static var gray7: OHColor {
        DesignSystemAsset.Colors.gray7.color
    }
    /// #5E5D69
    public static var gray8: OHColor {
        DesignSystemAsset.Colors.gray8.color
    }
    /// #3F3E49
    public static var gray9: OHColor {
        DesignSystemAsset.Colors.gray9.color
    }
    /// #121214
    public static var gray10: OHColor {
        DesignSystemAsset.Colors.gray10.color
    }
    
    // MARK:  Theme blue
    /// #F3F4FE
    public static var blue1: OHColor {
        DesignSystemAsset.Colors.blue1.color
    }
    /// #E6E3FC
    public static var blue2: OHColor {
        DesignSystemAsset.Colors.blue2.color
    }
    /// #D1CBFF
    public static var blue3: OHColor {
        DesignSystemAsset.Colors.blue3.color
    }
    /// #9A9FF7
    public static var blue4: OHColor {
        DesignSystemAsset.Colors.blue4.color
    }
    /// #5E66FF
    public static var blue5: OHColor {
        DesignSystemAsset.Colors.blue5.color
    }
    /// #3640F0
    public static var blue6: OHColor {
        DesignSystemAsset.Colors.blue6.color
    }
    /// #000CD9
    public static var blue7: OHColor {
        DesignSystemAsset.Colors.blue7.color
    }
    /// #0A13B0
    public static var blue8: OHColor {
        DesignSystemAsset.Colors.blue8.color
    }
}

extension UIColor {
    convenience init(assetNamed: String) {
        guard let _ = UIColor(named: assetNamed)
        else {
            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }
        
        self.init(named: assetNamed)!
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        if hex.hasPrefix("#") {
            var hexColor = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexColor = hexColor.replacingOccurrences(of: "#", with: "")
            
            if hexColor.count == 6 {
                let scanner = Scanner(string: hexColor)
                var rgbValue: UInt64 = 0
                scanner.scanHexInt64(&rgbValue)
                let r: CGFloat = CGFloat((rgbValue & 0xff0000) >> 16) / 255
                let g: CGFloat = CGFloat((rgbValue & 0xff00) >> 8) / 255
                let b: CGFloat = CGFloat(rgbValue & 0xff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: alpha)
                return
            }
        }
        self.init(red: 0, green: 0, blue: 0, alpha: alpha)
    }
}
