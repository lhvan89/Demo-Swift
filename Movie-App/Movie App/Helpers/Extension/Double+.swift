//
//  Double+.swift
//  Movie App
//
//  Created by lhvan on 11/4/16.
//  Copyright © 2016 lhvan. All rights reserved.
//

import Foundation

extension Double {
    func convertToStringWithOneDecimal() -> String {
        return String(format: "%.1f", self)
    }
}
