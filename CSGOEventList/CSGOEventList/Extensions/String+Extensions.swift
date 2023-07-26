//
//  String+Extensions.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 26/07/23.
//

import Foundation

extension String {

    func getDateFromString() -> Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current

        guard let date: Date = dateFormatter.date(from: self) else { return Date() }

        return date
    }
}
