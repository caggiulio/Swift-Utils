//
//  DateFormat
//  Created by Nunzio Giulio Caggegi
//

import Foundation

/// The object that contains the string `template` to use in the `formatted(format:isLocalizedBySystem:)` method.
public struct DateFormat {
  
  /// The instance of `DateFormat`.
  public static var customFormat = DateFormat()
  
  // MARK: - Enums
  
  /// The separator for the `dateTemplate`.
  public enum DateSeparator: String, CaseIterable {
    /// The dash separator.
    case dash = "-"
    
    /// The backslash separator.
    case backslash = "/"
    
    /// The empty space separator.
    case emptySpace = " "
  }
  
  /// The separator for the `timeTemplate`.
  public enum TimeSeparator: String, CaseIterable {
    /// The colon separator.
    case colon = ":"
    
    /// The point separator.
    case point = "."
    
    /// The empty space separator.
    case emptySpace = " "
  }
  
  /// The separator used to separate `dateTemplate` and `timeTemplate`.
  public enum DateTimeSeparator: String, CaseIterable {
    /// The comma separator. An empty space is added after comma.
    case comma = ", "
    
    /// The empty space separator.
    case emptySpace = " "
    
    /// The standard ISO8601 date and time separator.
    case standard = "'T'"
  }
  
  // MARK: - Stored Properties
  
  /// The final template to use in a `DateFormatter`.
  var template: String = ""
  
  /// The `String` date format value.
  private let dateTemplate: String
  
  /// The `String` time format value.
  private let timeTemplate: String
  
  /// The date separator. Defaults to `.dash`.
  private let dateSeparator: DateSeparator
  
  /// The time separator. Defaults to `.colon`.
  private let timeSeparator: TimeSeparator
  
  /// The separator used to separate `dateTemplate` and `timeTemplate`. Is `.comma` by default.
  private let dateAndTimeSeparator: DateTimeSeparator
  
  /// Whether the date is placed before the time in the final template.
  private let isDateBeforeTime: Bool
  
  // MARK: - Init
  
  /// The init of the `DateFormat`.
  /// - Parameters:
  ///   - dateTemplate: The `String` date format value.
  ///   - timeTemplate: The `String` time format value.
  ///   - dateSeparator: The date separator. Defaults to `.dash`.
  ///   - timeSeparator: The time separator. Defaults to `.colon`.
  ///   - dateAndTimeSeparator: The separator used to separate `dateTemplate` and `timeTemplate`. Defaults to `.comma`.
  ///   - isDateBeforeTime: Whether the date is before the time in the final template. Defaults to `true`.
  public init(
    dateTemplate: String = "",
    timeTemplate: String = "",
    dateSeparator: DateSeparator = .dash,
    timeSeparator: TimeSeparator = .colon,
    dateAndTimeSeparator: DateTimeSeparator = .comma,
    isDateBeforeTime: Bool = true
  ) {
    self.dateTemplate = dateTemplate
    self.timeTemplate = timeTemplate
    self.dateSeparator = dateSeparator
    self.timeSeparator = timeSeparator
    self.dateAndTimeSeparator = dateAndTimeSeparator
    self.isDateBeforeTime = isDateBeforeTime
    self.buildTemplate()
  }
  
  /// The method used to append and update the `dateTemplate`. If `dateTemplate` is empty, the separator will be not added.
  /// - Parameter element: The element to append.
  /// - Returns: The new `DateFormat` with the updated `dateTemplate`.
  private func appending(dateElement: String) -> DateFormat {
    if dateTemplate.isEmpty {
      return DateFormat(
        dateTemplate: "\(dateTemplate)\(dateElement)",
        timeTemplate: timeTemplate,
        dateSeparator: dateSeparator,
        timeSeparator: timeSeparator,
        dateAndTimeSeparator: dateAndTimeSeparator,
        isDateBeforeTime: isDateBeforeTime
      )
    } else {
      return DateFormat(
        dateTemplate: "\(dateTemplate)\(dateSeparator.rawValue)\(dateElement)",
        timeTemplate: timeTemplate,
        dateSeparator: dateSeparator,
        timeSeparator: timeSeparator,
        dateAndTimeSeparator: dateAndTimeSeparator,
        isDateBeforeTime: isDateBeforeTime
      )
    }
  }
  
  /// The method used to append and update the `timeTemplate`. If `timeTemplate` is empty, the separator will be not added.
  /// - Parameter element: The element to append.
  /// - Returns: The new `DateFormat` with the updated `timeTemplate`.
  private func appending(timeElement: String) -> DateFormat {
    let isDateTemplateEmpty = dateTemplate.isEmpty
    
    if timeTemplate.isEmpty {
      return DateFormat(
        dateTemplate: dateTemplate,
        timeTemplate: "\(timeTemplate)\(timeElement)",
        dateSeparator: dateSeparator,
        timeSeparator: timeSeparator,
        dateAndTimeSeparator: dateAndTimeSeparator,
        isDateBeforeTime: isDateTemplateEmpty.inverted
      )
    } else {
      return DateFormat(
        dateTemplate: dateTemplate,
        timeTemplate: "\(timeTemplate)\(timeSeparator.rawValue)\(timeElement)",
        dateSeparator: dateSeparator,
        timeSeparator: timeSeparator,
        dateAndTimeSeparator: dateAndTimeSeparator,
        isDateBeforeTime: isDateTemplateEmpty.inverted
      )
    }
  }
  
  /// Builds the final template to use in a `DateFormatter`. There are 4 cases:
  /// - The case in which `dateTemplate` is empty and `timeTemplate` is not empty.
  /// - The case in which `dateTemplate` is not empty and `timeTemplate` is empty.
  /// - The case in which `dateTemplate` is empty and `timeTemplate` is empty.
  /// - The case in which `dateTemplate` is not empty and `timeTemplate` is not empty.
  private mutating func buildTemplate() {
    let isDateTemplateEmpty = dateTemplate.isEmpty
    let isTimeTemplateEmpty = timeTemplate.isEmpty
    
    switch (isDateTemplateEmpty, isTimeTemplateEmpty) {
    case (true, false):
      template = timeTemplate
      
    case (false, true):
      template = dateTemplate
      
    case (true, true):
      template = ""
      
    case (false, false):
      if isDateBeforeTime {
        template = "\(dateTemplate)\(dateAndTimeSeparator.rawValue)\(timeTemplate)"
      } else {
        template = "\(timeTemplate)\(dateAndTimeSeparator.rawValue)\(dateTemplate)"
      }
    }
  }
}


// MARK: - Years Symbols

extension DateFormat {
  /// The year format.
  public enum Year {
    /// The short year format.
    /// - Note: i.e. "yy". ex. 23
    case short
    
    /// The full year format.
    /// - Note: i.e. "yyyy". ex. 2023
    case full
  }
  
  /// Append the year to date format `dateTemplate`.
  /// - Parameter format: The format for the Year rendering. Defaults to `.short`.
  /// - Returns: The updated date format dateTemplate
  public func year(_ format: Year = .short) -> DateFormat {
    switch format {
    case .short:
      return appending(dateElement: "yy")
      
    case .full:
      return appending(dateElement: "yyyy")
    }
  }
}

// MARK: - Quarter Symbols

extension DateFormat {
  /// The quarter format.
  public enum Quarter {
    /// The numeric quarter format.
    /// - Note: i.e. "Q". ex. 4
    case numeric
    
    /// The short quarter format.
    /// - Note: i.e. "QQQ". ex. Q4
    case short
    
    /// The full quarter format.
    /// - Note: i.e. "QQQQ". ex. 4th quarter
    case full
  }
  
  /// Append the quarter to the date format dateTemplate.
  /// - Parameter format: The format for the Quarter rendering. Defaults to `.numeric`.
  /// - Returns: The updated date format dateTemplate
  public func quarter(_ format: Quarter = .numeric) -> DateFormat {
    switch format {
    case .numeric:
      return appending(dateElement: "Q")
      
    case .short:
      return appending(dateElement: "QQQ")
      
    case .full:
      return appending(dateElement: "QQQQ")
    }
  }
}

// MARK: - Months Symbols

extension DateFormat {
  /// The month format.
  public enum Month {
    /// The numeric month format.
    /// - Note: i.e. "M". ex. 1
    case numeric
    
    /// The short month format.
    /// - Note: i.e. "MM". ex. 01
    case short
    
    /// The medium month format.
    /// - Note: i.e. "MMM". ex. Jan
    case medium
    
    /// The full year month.
    /// - Note: i.e. "MMMM". ex. January
    case full
    
    /// The narrow year month.
    /// - Note: i.e. "MMMMM". ex. J
    case narrow
  }
  
  /// Append Month to `dateTemplate`.
  /// - Parameter format: The format for the Month rendering. Defaults to `.numeric`.
  /// - Returns: The updated date format `dateTemplate`.
  public func month(_ format: Month = .numeric) -> DateFormat {
    switch format {
    case .numeric:
      return appending(dateElement: "M")
      
    case .short:
      return appending(dateElement: "MM")
      
    case .medium:
      return appending(dateElement: "MMM")
      
    case .full:
      return appending(dateElement: "MMMM")
      
    case .narrow:
      return appending(dateElement: "MMMMM")
    }
  }
}

// MARK: - Days Symbols

extension DateFormat {
  /// The day format.
  public enum Day {
    /// The one digit day format.
    /// - Note: i.e. "d". ex. 1
    case oneDigit
    
    /// The two digits day format.
    /// - Note: i.e. "dd". ex. 01
    case twoDigits
  }
  
  /// Append Day `dateTemplate`.
  /// - Parameter format: The format for the Day rendering. Defaults to `.oneDigit`.
  /// - Returns: The updated date format dateTemplate
  public func day(_ format: Day = .twoDigits) -> DateFormat {
    switch format {
    case .oneDigit:
      return appending(dateElement: "d")
      
    case .twoDigits:
      return appending(dateElement: "dd")
    }
  }
}

// MARK: - WeekDay Symbols

extension DateFormat {
  /// The weekday format.
  public enum Weekday {
    /// The short weekday format.
    /// - Note: i.e. "E". ex. Tue
    case short
    
    /// The full weekday format.
    /// - Note: i.e. "EEEE". ex. Tuesday
    case full
    
    /// The narrow weekday format.
    /// - Note: i.e. "EEEEE". ex. T
    case narrow
  }
  
  /// Append the weekdate to the date format `dateTemplate`.
  /// - Parameter format: The format for the Weekend rendering. Defaults to `.short`.
  /// - Returns: The updated date format `dateTemplate`
  public func weekday(_ format: Weekday = .short) -> DateFormat {
    switch format {
    case .short:
      return appending(dateElement: "E")
      
    case .full:
      return appending(dateElement: "EEEE")
      
    case .narrow:
      return appending(dateElement: "EEEEE")
    }
  }
}

// MARK: - Time

extension DateFormat {
  /// Appends Hours and Minutes to `timeTemplate`.
  /// - Parameter includingFractionalSeconds: Whether the fractional seconds are included.
  /// - Returns: The updated date format `timeTemplate`.
  public func time(includingFractionalSeconds: Bool) -> DateFormat {
    return includingFractionalSeconds ? hours().minutes().fractionalSeconds() : hours().minutes()
  }
}

// MARK: - Hours Symbols

extension DateFormat {
  /// Time format for hours.
  public enum Time {
    /// The 12-hour-cycle (0-12).
    case twelve
    
    /// The 24-hour-cycle (0-24).
    case twentyfour
  }
  
  /// Append zero-padded Hours to date format `timeTemplate`. `twentyfour` by default.
  /// - Parameter format: The format for the Hours rendering. Defaults to `.twentyfour`.
  /// - Returns: The updated date format dateTemplate.
  public func hours(_ format: Time = .twentyfour) -> DateFormat {
    switch format {
    case .twelve:
      return appending(timeElement: "hh")
      
    case .twentyfour:
      return appending(timeElement: "HH")
    }
  }
}

// MARK: - Minutes Symbols

extension DateFormat {
  /// Time format for minutes.
  public enum Minutes {
    /// The one digit minutes format.
    /// - Note: i.e.: "m". ex. 5
    case oneDigit
    
    /// The two digit minutes format.
    /// - Note: i.e. "mm". ex. 05
    case twoDigits
  }
  
  /// Append Minutes to date format `timeTemplate`.
  /// - Parameter format: The format for the Minutes rendering. Defaults to `.oneDigit`.
  /// - Returns: The updated date format `timeTemplate`. `.twoDigits` by default.
  public func minutes(_ format: Minutes = .twoDigits) -> DateFormat {
    switch format {
    case .oneDigit:
      return appending(timeElement: "m")
      
    case .twoDigits:
      return appending(timeElement: "mm")
    }
  }
}

// MARK: - Seconds Symbols

extension DateFormat {
  /// Time format for seconds.
  public enum Seconds {
    /// The one digit minutes format.
    /// - Note: i.e. "s". ex. 5
    case oneDigit
    
    /// The two digit minutes format.
    /// - Note: i.e. "ss". ex. 05
    case twoDigits
  }
  
  /// Append Seconds to date format `timeTemplate`.
  /// - Parameter format: The format for the Seconds rendering. Defaults to `.oneDigit`.
  /// - Returns: The updated date format `timeTemplate`.
  public func seconds(_ format: Seconds = .twoDigits) -> DateFormat {
    switch format {
    case .oneDigit:
      return appending(timeElement: "s")
      
    case .twoDigits:
      return appending(timeElement: "ss")
    }
  }
  
  /// Append Fractional Seconds to date format `timeTemplate`.
  /// - Parameter length: Number of digits to include, zero padded. (defaults to 3).
  /// - Returns: The updated date format `timeTemplate`.
  public func fractionalSeconds(length: Int = 3) -> DateFormat {
    appending(timeElement: Array(repeating: "S", count: length).joined())
  }
}

// MARK: - TimeZone Symbols

extension DateFormat {
  /// Append Time Zone Abbreviation to date format `timeTemplate`.
  /// - Returns: The updated date format `timeTemplate`.
  public func timeZone() -> DateFormat {
    appending(timeElement: "z")
  }
  
  /// Append Time Zone Name to date format `timeTemplate`.
  /// - Returns: The updated date format `timeTemplate`.
  public func timeZoneName() -> DateFormat {
    appending(timeElement: "zzzz")
  }
}

// MARK: - Period Symbols

extension DateFormat {
  /// Append period (am/pm) to date format `timeTemplate`.
  /// - Returns: The updated `timeTemplate` template.
  public func period() -> DateFormat {
    appending(timeElement: "a")
  }
}

// MARK: - Separators

extension DateFormat {
  /// Substitutes the `DateSeparator` in `dateTemplate`.
  /// - Parameter separator: The `DateSeparator`.
  /// - Returns: The updated date format `dateTemplate`.
  public func dateSeparator(_ separator: DateSeparator) -> DateFormat {
    var newDateTemplate = dateTemplate
    
    DateSeparator.allCases.forEach {
      newDateTemplate = newDateTemplate.replacingOccurrences(of: $0.rawValue, with: separator.rawValue)
    }
    
    return DateFormat(
      dateTemplate: newDateTemplate,
      timeTemplate: timeTemplate,
      dateSeparator: dateSeparator,
      timeSeparator: timeSeparator,
      dateAndTimeSeparator: dateAndTimeSeparator,
      isDateBeforeTime: isDateBeforeTime
    )
  }
  
  /// Substitutes the `TimeSeparator` in `timeTemplate`.
  /// - Parameter separator: The `TimeSeparator`.
  /// - Returns: The updated date format `timeTemplate`.
  public func timeSeparator(_ separator: TimeSeparator) -> DateFormat {
    var newTimeTemplate = timeTemplate
    
    TimeSeparator.allCases.forEach {
      newTimeTemplate = newTimeTemplate.replacingOccurrences(of: $0.rawValue, with: separator.rawValue)
    }
    
    return DateFormat(
      dateTemplate: dateTemplate,
      timeTemplate: newTimeTemplate,
      dateSeparator: dateSeparator,
      timeSeparator: timeSeparator,
      dateAndTimeSeparator: dateAndTimeSeparator,
      isDateBeforeTime: isDateBeforeTime
    )
  }
  
  /// Substitutes the `DateAndTimeSeparator` in `template`.
  /// - Parameter separator: The `DateTimeSeparator`.
  /// - Returns: The updated date format `template`.
  public func dateTimeSeparator(_ separator: DateTimeSeparator) -> DateFormat {
    return DateFormat(
      dateTemplate: dateTemplate,
      timeTemplate: timeTemplate,
      dateSeparator: dateSeparator,
      timeSeparator: timeSeparator,
      dateAndTimeSeparator: separator,
      isDateBeforeTime: isDateBeforeTime
    )
  }
}

