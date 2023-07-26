//
//  Date+Extensions.swift
//  CSGOEventList
//
//  Created by Joao Marcus Dionisio Araujo on 25/07/23.
//

import Foundation

extension Date {

    func dayOfTheWeek() -> String? {
        let weekdays = [
            "Domingo",
            "Segunda",
            "Terça",
            "Quarta",
            "Quinta",
            "Sexta",
            "Sábado"
        ]

        let calendar: NSCalendar = NSCalendar.current as NSCalendar
        calendar.locale = Locale(identifier: "pt_BR")
        let components: NSDateComponents = calendar.components(.weekday, from: self as Date) as NSDateComponents
        return weekdays[components.weekday - 1]
    }

    func isSevenDaysAfter() -> Bool {
        let calendar = Calendar.current
        let now = Date()
        let sevenDaysAfter = calendar.date(byAdding: .day, value: 7, to: now)
        return self >= (sevenDaysAfter ?? now)
    }

    func getDateStringFormatted() -> String {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM' 'HH:mm"
        dateFormatter.locale = Locale(identifier: "pt_BR")

        return dateFormatter.string(from: self)
    }
}
