//
//  PersianMonthType.swift
//  SwiftSample
//
//  Created by Ali on 10/6/17.
//  Copyright © 2017 Ali Azadeh. All rights reserved.
//

import Foundation
enum AZPersianMonthType: Int, CustomStringConvertible {
    
    case farvardin = 1
    case ordibehesht = 2
    case khordad = 3
    case tir = 4
    case mordad = 5
    case shahrivar = 6
    case mehr = 7
    case aban = 8
    case azar = 9
    case dey = 10
    case bahman = 11
    case esfand = 12
    
    var description: String {
        switch self {
        case .farvardin:
            return "فروردین"
        case .ordibehesht:
            return "اردیبهشت"
        case .khordad:
            return "خرداد"
        case .tir:
            return "تیر"
        case .mordad:
            return "مرداد"
        case .shahrivar:
            return "شهریور"
        case .mehr:
            return "مهر"
        case .aban:
            return "آبان"
        case .azar:
            return "آذر"
        case .dey:
            return "دی"
        case .bahman:
            return "بهمن"
        case .esfand:
            return "اسفند"
        }
    }
    
    
}
