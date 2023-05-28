//
//  Extensions.swift
//  Banking
//
//  Created by Karen Mirakyan on 10.03.23.
//

import Foundation
import SwiftUI
import AVKit
import FirebaseFirestore
import Combine


extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    var keyWindow: UIWindow? {
        connectedScenes
            .compactMap {
                $0 as? UIWindowScene
            }
            .flatMap {
                $0.windows
            }
            .first {
                $0.isKeyWindow
            }
    }
}


// Rounded Corner extension
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    func getRootViewController() -> UIViewController {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .init() }
        
        guard let root = screen.windows.first?.rootViewController else { return .init() }
        
        return root
    }
    
    @ViewBuilder
    func valueChanged<T: Equatable>(value: T, onChange: @escaping (T) -> Void) -> some View {
        if #available(iOS 14.0, tvOS 14.0, macOS 11.0, watchOS 7.0, *) {
            self.onChange(of: value, perform: onChange)
        } else {
            self.onReceive(Just(value)) { value in
                onChange(value)
            }
        }
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}


extension String {
    
    var digits: [Int] {
        var result = [Int]()
        
        for char in self {
            if let number = Int(String(char)) {
                result.append(number)
            }
        }
        return result
    }
    
    func extractDigits() -> Int {
        var tmp = ""
        let arr = Array( self )
        for i in arr {
            if i.isNumber {
                tmp += String( i )
            }
        }
        return Int( String( tmp ) )!
    }
    
    var isSingleEmoji: Bool { count == 1 && containsEmoji }
    
    var containsEmoji: Bool { contains { $0.isEmoji } }
    
    var containsOnlyEmoji: Bool { !isEmpty && !contains { !$0.isEmoji } }
    
    var emojiString: String { emojis.map { String($0) }.reduce("", +) }
    
    var emojis: [Character] { filter { $0.isEmoji } }
    
    var emojiScalars: [UnicodeScalar] { filter { $0.isEmoji }.flatMap { $0.unicodeScalars } }
    
    func onlyNumbers() -> String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    var formattedCreditCard: String {
        return format(with: CardTextField.cardNumber, phone: self)
    }
    
    var formattedExpiredDate: String {
        return format(with: CardTextField.dateExpiration, phone: self)
    }
    
    var formattedCvv: String {
        return format(with: CardTextField.cvv, phone: self)
    }
    
    func format(with maskType: CardTextField, phone: String) -> String {
        let mask = maskType.mask
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                result.append(numbers[index])
                index = numbers.index(after: index)
                
            } else {
                result.append(ch)
            }
        }
        return result
    }
    
    //Validate Email
    
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
}

extension Character {
    /// A simple emoji is one scalar and presented to the user as an Emoji
    var isSimpleEmoji: Bool {
        guard let firstScalar = unicodeScalars.first else { return false }
        return firstScalar.properties.isEmoji && firstScalar.value > 0x238C
    }
    
    /// Checks if the scalars will be merged into an emoji
    var isCombinedIntoEmoji: Bool { unicodeScalars.count > 1 && unicodeScalars.first?.properties.isEmoji ?? false }
    
    var isEmoji: Bool { isSimpleEmoji || isCombinedIntoEmoji }
}

extension Int {
    
    var numberString: String {
        
        guard self < 10 else { return "0" }
        
        return String(self)
    }
}

private struct SafeAreaInsetsKey: EnvironmentKey {
    static var defaultValue: EdgeInsets {
        UIApplication.shared.keyWindow?.safeAreaInsets.swiftUiInsets ?? EdgeInsets()
    }
}

extension EnvironmentValues {
    var safeAreaInsets: EdgeInsets {
        self[SafeAreaInsetsKey.self]
    }
}

private extension UIEdgeInsets {
    var swiftUiInsets: EdgeInsets {
        EdgeInsets(top: top, leading: left, bottom: bottom, trailing: right)
    }
}


extension Array where Element: Comparable {
    func containsSameElements(as other: [Element]) -> Bool {
        return self.count == other.count && self.sorted() == other.sorted()
    }
}


extension Image {
    init?(base64String: String) {
        guard let data = Data(base64Encoded: base64String) else { return nil }
#if os(macOS)
        guard let image = NSImage(data: data) else { return nil }
        self.init(nsImage: image)
#elseif os(iOS)
        guard let image = UIImage(data: data) else { return nil }
        self.init(uiImage: image)
#else
        return nil
#endif
    }
}


extension Array
{
    mutating func move(from sourceIndex: Int, to destinationIndex: Int)
    {
        guard
            sourceIndex != destinationIndex
                && Swift.min(sourceIndex, destinationIndex) >= 0
                && Swift.max(sourceIndex, destinationIndex) < count
        else {
            return
        }
        
        let direction = sourceIndex < destinationIndex ? 1 : -1
        var sourceIndex = sourceIndex
        
        repeat {
            let nextSourceIndex = sourceIndex + direction
            swapAt(sourceIndex, nextSourceIndex)
            sourceIndex = nextSourceIndex
        }
        while sourceIndex != destinationIndex
    }
}

extension Data {
    func getAVAsset() -> AVAsset {
        let directory = NSTemporaryDirectory()
        let fileName = "\(NSUUID().uuidString).mov"
        let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName])
        try! self.write(to: fullURL!)
        let asset = AVAsset(url: fullURL!)
        return asset
    }
}

extension Date {
    
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
    
    var millisecondsSince1970: Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
    
    func getAgeFromBirthDate() -> String {
        
        let calender = Calendar.current
        
        let age = calender.dateComponents([.year], from: self, to: Date())
        
        return String(age.year!)
    }
    
    func countTimeBetweenDates() -> String {
        
        let currentDate = Date().toGlobalTime()
        
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale(identifier: "en_US")
        formatter.unitsStyle = .short
        let string = formatter.localizedString(for: self, relativeTo: currentDate)
        
        return currentDate.millisecondsSince1970 - self.millisecondsSince1970 < 3000 ? NSLocalizedString("justNow", comment: "") : string
    }
    
    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    
    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = self.timeIntervalSince1970
        
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        
        
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
}

extension Formatter {
    // create static date formatters for your date representations
    static let preciseLocalTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    static let preciseGMTTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }()
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}


struct NetworkReconnection: ViewModifier {
    
    let action: (() -> Void)
    func body(content: Content) -> some View {
        content
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name(rawValue: "network_reconnection_notification"))) { _ in
                action()
            }
        
    }
}

// special extension for set data in firestore
extension FirebaseFirestore.DocumentReference {
    func setData<T: Encodable>(from: T, merge: Bool = false) async throws {
        let encoder = Firestore.Encoder()
        let data = try encoder.encode(from)
        try await setData(data, merge: merge)
    }
}

extension Date {
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
}


extension CardValidationTF {
    
    public static func cleanCreditCardNo(_ creditCardNo: String) -> String {
        return creditCardNo.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
    }
    
    public static func isExpDateValid(_ expDate: String?) -> Bool {
        guard let expDate = expDate else {
            return false
        }
        guard expDate.count == 5 else {
            return false
        }
        
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yy"
        
        guard let date = dateFormatter.date(from: expDate) else {
            return false
        }
        
        var calendar = Calendar.init(identifier: .gregorian)
        calendar.timeZone = TimeZone.current
        
        let dayRange = calendar.range(of: .day, in: .month, for: date)
        var comps = calendar.dateComponents([.year, .month, .day], from: date)
        comps.day = dayRange?.count ?? 1
        comps.hour = 24
        comps.minute = 0
        comps.second = 0
        
        guard let aNewDate = calendar.date(from: comps) else {
            return false
        }
        
        let curMonth = Calendar.current.component(.month, from: Date())
        let curYear = Calendar.current.component(.year, from: Date())
        
        let dateNow = dateFormatter.date(from: "\(curMonth < 10 ? "0\(curMonth)" : "\(curMonth)")/\(String(curYear).suffix(2))")!
        
        guard aNewDate.compare(dateNow) == .orderedDescending else {
            return false
        }
        
        return true
    }
    
    public static func isCvvValid(_ cvv: String?) -> Bool {
        guard let cvv = cvv else {
            return false
        }
        
        if (cvv.count == 3) {
            return true
        }
        
        return false
    }
    
    public static func isCardHolderNameValid(_ name: String) -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z][a-z]+(?: [A-Z][a-z\\-]*)*(?: [A-Z][a-z]*(?:-[A-Z][a-z]*)?)$"
)
        let range = NSRange(name.startIndex..., in: name)
        return regex.firstMatch(in: name, options: [], range: range) != nil
    }
}




class Currency {
    static let shared: Currency = Currency()

    private var cache: [String:String] = [:]

    func findSymbol(currencyCode:String) -> String {
        if let hit = cache[currencyCode] { return hit }
        guard currencyCode.count < 4 else { return "" }

        let symbol = findSymbolBy(currencyCode)
        cache[currencyCode] = symbol

        return symbol
    }

    private func findSymbolBy(_ currencyCode: String) -> String {
        var candidates: [String] = []
        let locales = NSLocale.availableLocaleIdentifiers

        for localeId in locales {
            guard let symbol = findSymbolBy(localeId, currencyCode) else { continue }
            if symbol.count == 1 { return symbol }
            candidates.append(symbol)
        }

        return candidates.sorted(by: { $0.count < $1.count }).first ?? ""
    }

    private func findSymbolBy(_ localeId: String, _ currencyCode: String) -> String? {
        let locale = Locale(identifier: localeId)
        return currencyCode.caseInsensitiveCompare(locale.currency?.identifier ?? "") == .orderedSame
            ? locale.currencySymbol : nil
    }
}

extension String {
    var currencySymbol: String { return Currency.shared.findSymbol(currencyCode: self) }
    
    func isFullNameValid() -> Bool {
        let regex = try! NSRegularExpression(pattern: "^[A-Z][a-z]+(?: [A-Z][a-z\\-]*)*(?: [A-Z][a-z]*(?:-[A-Z][a-z]*)?)$"
)
        let range = NSRange(self.startIndex..., in: self)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
    
    func isQrValid() -> Bool {
        let regex = try! NSRegularExpression(pattern: "[a-fA-F0-9]{8}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{4}-[a-fA-F0-9]{12}")
        let range = NSRange(self.startIndex..., in: self)
        return regex.firstMatch(in: self, options: [], range: range) != nil
    }
}

extension CIImage {
    
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }

    /// Inverts the colors.
    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }

        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }

    /// Converts all black to transparent.
    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }
    
    func tinted(using color: UIColor) -> CIImage?
    {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage

        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

        return filter.outputImage!
    }
}


extension URL {
    func valueOf(_ queryParameterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParameterName })?.value
    }
}
