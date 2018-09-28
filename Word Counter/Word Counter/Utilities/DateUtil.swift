//
//  DateUtil.swift
//  Word Counter
//
//  Created by Sagar on 28/09/18.
//  Copyright © 2018 Sagar. All rights reserved.
//

import UIKit

class DateUtil: NSObject {
    private static var logsDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = Constants.logsDateFormat
        return formatter
    }()
    
    public static func logsDateString(from date:Date) -> String {
        return self.logsDateFormatter.string(from: date)
    }
}
