import UIKit

extension UIColor {

    class var lightColor: UIColor {
        return UIColor.init(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 1);
    }

    class var tableviewBackgroundColor: UIColor {
        return UIColor.init(red: 249.0/255.0, green: 250.0/255.0, blue: 251.0/255.0, alpha: 1);
    }

    class var blackTextColor: UIColor {
        return UIColor.init(red: 79.0/255.0, green: 80.0/255.0, blue: 81.0/255.0, alpha: 1);
    }

    

    // MARK: - Init
    // swiftlint:disable: next name
    // swiftlint:disable: identifier_name
    private convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        // swiftlint:disable:identifier name
        let alpha, red, green, blue: UInt32
        switch hex.count {
        // RGB (12-bit)  #rgb
        case 3:
            (alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        // RGB (24-bit)  #rrggbb
        case 6:
            (alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        // ARGB (32-bit) #aarrggbb
        case 8:
            (alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (alpha, red, green, blue) = (0xff, 0x80, 0x80, 0x80)
        }

        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    // swiftlint:enable next name
    // swiftlint:enable: identifier_name
}
