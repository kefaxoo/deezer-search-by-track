//
//  ExtenstionTimeInterval.swift
//  deezer-search
//
//  Created by Bogdan Petrovskiy on 10.08.22.
//

import Foundation

extension TimeInterval {
    var hh_mm_ss: String {
        String(format: "%d:%02d:%02d", hour, minute, second)
    }
    
    var mm_ss: String {
        String(format: "%d:%02d", minute, second)
    }
    
    var hour: Int {
        Int((self/3600).truncatingRemainder(dividingBy: 3600))
    }
    
    var minute: Int {
        Int((self/60).truncatingRemainder(dividingBy: 60))
    }
    
    var second: Int {
        Int(truncatingRemainder(dividingBy: 60))
    }
}
