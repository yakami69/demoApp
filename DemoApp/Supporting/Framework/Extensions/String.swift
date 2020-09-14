//
//  File.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//

import Foundation
import UIKit

public extension String {
    
    // MARK: - UTC to Date
    
    /// change UTC Time zone string with provided format to Date
    /// - Parameter format: format of string
    /// - Returns: Date
    func  utcStringToDate(with  format: SupportedFormat) -> Date? {
        return self.utcStringToDate(with: format.rawValue)
    }
    
    /// change UTC Time zone string with provided format to Date
    /// - Parameter format: format of string
    /// - Returns: Date
    func  utcStringToDate(with  format: String) -> Date? {
        let formatter = Date.dateFormatter(timeZone: TimeZone.UTCTimeZone, locale: Locale.enUSPosix, dateFormat: format)
        let date = formatter.date(from: self)
        return date
    }
    
    // MARK: - local to Date
    
    /// converts date string in local time zone of device to Date
    /// - Parameter withFormat: format of date string in local time zone of device
    /// - Returns: formatted date string
    func localStringToDate(withFormat: SupportedFormat) -> Date? {
        return self.localStringToDate(withFormat: withFormat.rawValue)
    }
    
    /// converts date string in local time zone of device to Date
    /// - Parameter withFormat: format of date string in local time zone of device
    /// - Returns: formatted date string
    func localStringToDate(withFormat: String) -> Date? {
        return Date.dateFormatter(timeZone: TimeZone.current, locale: Locale.enUSPosix, dateFormat: withFormat).date(from: self)
    }
    
    // MARK: - UTC to local
    
    /// converts date in UTC time zone string to local timeZone date string
    /// - Parameters:
    ///   - withFormat: format of UTC time zone string
    ///   - toFormat: format to be converted to in device local time zone
    /// - Returns: formatted date string
    func utcStringToLocalString(withFormat: SupportedFormat, toFormat: SupportedFormat) -> String? {
        self.utcStringToLocalString(withFormat: withFormat.rawValue, toFormat: toFormat.rawValue)
    }
    
    /// converts date in UTC time zone string to local timeZone date string
    /// - Parameters:
    ///   - withFormat: format of UTC time zone string
    ///   - toFormat: format to be converted to in device local time zone
    /// - Returns: formatted date string
    func utcStringToLocalString(withFormat: String, toFormat: String) -> String? {
        guard let date = self.utcStringToDate(with: withFormat) else {
            return nil
        }
        return date.toLocalTimeZoneString(format: toFormat)
    }
    
    // MARK: - local to UTC
    
    /// converts date in local time zone string to utc timeZone date string
    /// - Parameters:
    ///   - withFormat: format of Local time zone string
    ///   - toFormat: format to be converted to in utc time zone
    /// - Returns: formatted date string
    func localStringToUtcString(withFormat: SupportedFormat, toFormat: SupportedFormat) -> String? {
        self.localStringToUtcString(withFormat: withFormat.rawValue, toFormat: toFormat.rawValue)
    }
    
    /// converts date in local time zone string to utc timeZone date string
    /// - Parameters:
    ///   - withFormat: format of Local time zone string
    ///   - toFormat: format to be converted to in utc time zone
    /// - Returns: formatted date string
    func localStringToUtcString(withFormat: String, toFormat: String) -> String? {
        guard let date = self.localStringToDate(withFormat: withFormat) else {
            return nil
        }
        return date.toUTCString(format: toFormat)
    }
    
    // MARK: - others
    
    /// trim whitespace of string
    var trim: String {
        return self.trimmingCharacters(in: .whitespaces)
    }

    var trimPhone: String {
        var phoneNumberCharacterSet = CharacterSet.decimalDigits
        phoneNumberCharacterSet.insert("+")
        return self.trimmingCharacters(in: phoneNumberCharacterSet.inverted)
    }
    
    /// String to date
    ///
    /// - Parameter format: format of string
    /// - Returns: Date
    func toDate(withFormat format: SupportedFormat = .ddmmyyslash) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        let date = formatter.date(from: self)
        return date
    }
    
    /// Validates a string with the provided pattern
    /// - Parameter pattern: mostly the regex pattern
    func validate(withPattern pattern: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
        return predicate.evaluate(with: self)
    }
    
    /// Helper to convert the string HTML to attributed HTML
    func attributedHTML() -> NSMutableAttributedString? {
        guard let data = self.data(using: .utf8) else { return nil }
        let options = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html]
        do {
            let htmlAttributes = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
            return htmlAttributes
        } catch {
            debugPrint("Unable to create html attributes \(error.localizedDescription)")
            return nil
        }
    }
    
    /// set attributes on string and return resulting NSAttributedString
    /// - Parameters:
    ///   - fontStyle: font style. (with font and size)
    ///   - lineHeight: line height. "defaults to font point size or font size"
    ///   - textColor: text color. "defaults white"
    ///   - characterSpacing: character spacing or kern
    ///   - alignment: alignment
    ///   - lineBreakMode: line break mode
    func setAttributes(fontStyle: UIFont, lineHeight: CGFloat? = nil, textColor: UIColor = UIColor.white, characterSpacing: Double = 0.0, alignment: NSTextAlignment = NSTextAlignment.left, lineBreakMode: NSLineBreakMode = .byWordWrapping) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.addAttributes(fontStyle: fontStyle, lineHeight: lineHeight, textColor: textColor, characterSpacing: characterSpacing, alignment: alignment, lineBreakMode: lineBreakMode)

        return attributedString
    }
}
