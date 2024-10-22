//
//  Date+Extension.swift
//  Created by Nunzio Giulio Caggegi
//

import Foundation

public extension Date {
  /// Pretty prints the date based on the passed format.
  /// - Parameters:
  ///   - format: The format to follow when printing a date. Defaults to `.dashedDayMonthYear`.
  ///   - isLocalizedBySystem: Whether the format will be localized by the system or not. If `true`, the system will automatically choose the separator and the position in the date formatter.
  ///   - timeZone: The `TimeZone` used to format the date. Defaults to `.autoupdatingCurrent`.
  ///   - locale: The `Locale` used to format the date. Defaults to `.autoupdatingCurrent`.
  ///   - calendar: The `Calendar` used to format the date. Defaults to `.autoupdatingCurrent`.
  /// - Returns: A string representing the date after formatting it using input data.
  func formatted(
    _ format: DateFormat,
    isLocalizedBySystem: Bool = false,
    timeZone: TimeZone = .autoupdatingCurrent,
    locale: Locale = .autoupdatingCurrent,
    calendar: Calendar = .autoupdatingCurrent
  ) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.setDateFormatFromTemplate(template: format.template, isLocalizedBySystem: isLocalizedBySystem, timeZone: timeZone, locale: locale)
    
    return dateFormatter.string(from: self)
  }
}
