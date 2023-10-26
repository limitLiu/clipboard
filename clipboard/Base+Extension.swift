import AppKit

extension NSColor {
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        let red = CGFloat((hex & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xff)) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public class var border: NSColor {
        return NSColor(hex: 0x999999)
    }
    
    public class var title: NSColor {
        return NSColor(hex: 0x0, alpha: 0.95)
    }
    
    public class var random: NSColor {
        let red = CGFloat(arc4random() % 256) / 255.0
        let green = CGFloat(arc4random() % 256) / 255.0
        let blue = CGFloat(arc4random() % 256) / 255.0
        return NSColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}

extension String {
    subscript(_ i: Int) -> String {
        let idx1 = index(startIndex, offsetBy: i)
        let idx2 = index(idx1, offsetBy: 1)
        return String(self[idx1..<idx2])
    }
    
    subscript (range: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return String(self[start ..< end])
    }
    
    subscript (range: CountableClosedRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: range.lowerBound)
        let end = self.index(startIndex, offsetBy: range.upperBound - range.lowerBound)
        return String(self[start...end])
    }
    
}

extension NSFont {
    public class func font(ofSize fontSize: CGFloat) -> NSFont {
        return Self.font(ofSize: fontSize, weight: .regular)
    }
    
    public class func font(ofSize fontSize: CGFloat, weight: Weight) -> NSFont {
        if NSFontManager.hasHYLiLiangHeiJ {
            return NSFont(name: CUSTOM_FONT, size: fontSize)!
        }
        return NSFont.systemFont(ofSize: fontSize, weight: weight)
    }
}

fileprivate let CUSTOM_FONT: String = "SFMono Nerd Font"
extension NSFontManager {
    class var hasHYLiLiangHeiJ: Bool {
        return shared.availableFontFamilies.contains { $0 == CUSTOM_FONT }
    }
}

extension Data {
    func split() -> Int {
        var value: UInt32 = 0
        let data = NSData(bytes: [UInt8](self), length: count)
        data.getBytes(&value, length: count)
        value = UInt32(bigEndian: value)
        return Int(value)
    }
    
    func subdata(location: Int, length: Int) -> Self {
        return self.subdata(in: Range(NSRange(location: location, length: length))!)
    }
}

extension Date {
    var hours: Int {
        return Calendar.current.component(.hour, from: self)
    }
    
    var minutes: Int {
        return Calendar.current.component(.minute, from: self)
    }
    var second: Int {
        return Calendar.current.component(.second, from: self)
    }
    
    var stringValue: String {
        return "\(hours.stringValue):\(minutes.stringValue):\(second.stringValue)"
    }
    
    static var now: Date {
        return self.init()
    }
}

extension Int {
    var stringValue: String {
        return self >= 10 ? "\(self)" : "0\(self)"
    }
}
