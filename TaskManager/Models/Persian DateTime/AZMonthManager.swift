//
//  AZMonthManager.swift
//  AZCalendarSwift
//
//  Created by Ali on 4/13/17.
//  Copyright © 2017 Ali Azadeh. All rights reserved.
//

import Foundation
public class AZMonthManager {
    
    public static func getMonthName(calendar: CalendarType, monthNumber: Int) -> String {
        var result: String = ""
        switch calendar {
        case .persian :
            result = AZPersianMonthType(rawValue: monthNumber)!.description
            break
        case .gregorian :
            result = AZGregorianMonthType(rawValue: monthNumber)!.description
            break
        default:
            break
        }
        return result
    }

    static func getPersianMonthInfo(monthNumber: Int) -> AZPersianMonthType? {
        if monthNumber >= 1 && monthNumber <= 12 {
            return AZPersianMonthType(rawValue : monthNumber)
        }else{
            return nil
        }

    }
    static func getGregorianMonthInfo(monthNumber: Int) -> AZGregorianMonthType? {

        if monthNumber >= 1 && monthNumber <= 12 {
            return AZGregorianMonthType(rawValue : monthNumber)
        }else{
            return nil
        }

    }

}
