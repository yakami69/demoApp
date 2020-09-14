//
//  Date.swift
//  
//
//  Created by Narendra Bdr Kathayat on 12/18/19.
//
import Foundation

public enum SupportedFormat: String {
    case mmddyyspace = "MM dd yyyy"
    case mmddyyline = "MM-dd-yyyy"
    case mmddyyslash = "MM/dd/yyyy"
    case yyyymmddline = "yyyy-MM-dd"
    case ddmmyyspace = "dd MM yyyy"
    case ddmmyyline = "dd-MM-yyyy"
    case ddmmyyslash = "dd / MM / yyyy"
    case yymmddThhmmsszline = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    case yymmddThhmmsszetcgmt = "yyyy-MM-dd HH:mm:ss VV"
    case yyyyMMddHHmm = "yyyy-MM-dd HH:mm"
    case yymmddslash = "yyyy/MM/dd"
    case ddmmyyyyslash = "dd/MM/yyyy"
    case hhmm24 = "HH:mm"
    case hhmm12 = "hh:mm"
    case ddMMyy = "dd/MM/yy"
    case mmYY = "MM/YY"
}

public extension Date {
    
    /// convert Date to UTC time zone string in provided format
    /// - Parameter format: Supported format
    /// - Returns: Date as string in the form of provided format at UTC time zone
    func toUTCString(format: SupportedFormat) -> String {
        return self.toUTCString(format: format.rawValue)
    }
    
    /// convert Date to UTC time zone string in provided format
    /// - Parameter format: format string
    /// - Returns: Date as string in the form of provided format at UTC time zone
    func toUTCString(format: String) -> String {
        let dateFormatter = Date.dateFormatter(timeZone: TimeZone.UTCTimeZone, locale: Locale.enUSPosix, dateFormat: format)
        return dateFormatter.string(from: self)
    }
    
    /// convert Date to Device current time zone string in provided format
    /// - Parameter format: Supported format
    /// - Returns: Date as string in the form of provided format at device's local time zone
    func toLocalTimeZoneString(format: SupportedFormat) -> String {
        return self.toLocalTimeZoneString(format: format.rawValue)
    }
    
    /// convert Date to Device current time zone string in provided format
    /// - Parameter format: format string
    /// - Returns: Date as string in the form of provided format at device's local time zone
    func toLocalTimeZoneString(format: String) -> String {
        let dateFormatter = Date.dateFormatter(timeZone: TimeZone.current, locale: Locale.enUSPosix, dateFormat: format)
        return dateFormatter.string(from: self)
    }
    
    func toString(format: SupportedFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.string(from: self)
    }

    var dateExcludingTime: Date {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let day = Calendar.current.date(from: dateComponents)!
        return day
    }
    
    /// returns date formatter with given parameter
    /// - Parameters:
    ///   - timeZone: timeZone
    ///   - locale: locale
    ///   - dateFormat: Supported format
    /// - Returns: dateFormatter
    static func dateFormatter(timeZone: TimeZone? = nil, locale: Locale? = nil, dateFormat: SupportedFormat) -> DateFormatter {
        return Date.dateFormatter(timeZone: timeZone, locale: locale, dateFormat: dateFormat.rawValue)
    }
    
    /// returns date formatter with given parameter
    /// - Parameters:
    ///   - timeZone: timeZone
    ///   - locale: locale
    ///   - dateFormat: String with date format
    /// - Returns: dateFormatter
    static func dateFormatter(timeZone: TimeZone? = nil, locale: Locale? = nil, dateFormat: String) -> DateFormatter {
        let dateFormatter = DateFormatter()
        
        // set time zone
        if let timeZone = timeZone {
            dateFormatter.timeZone = timeZone
        }
        
        // set locale
        if let locale = locale {
            dateFormatter.locale = locale
        }
        
        // set date format
        dateFormatter.dateFormat = dateFormat
        return dateFormatter
    }
    
   /// return date format with provided format
    /// - Parameters:
    /// - date formamater
    func convertTO(format:SupportedFormat) -> Date {
         let formatter = DateFormatter()
        formatter.dateFormat = format.rawValue
        let convertedString = formatter.string(from: self)
        let convertedDate = formatter.date(from: convertedString)
        guard let date = convertedDate else {
            return Date()
        }
        return date
    }
}
