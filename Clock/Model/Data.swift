//
//  Data.swift
//  Clock
//
//  Created by imac-2626 on 2024/10/4.
//

import Foundation
import RealmSwift

class ClockTime : Object {
    @Persisted(primaryKey: true) var uuid: ObjectId
    @Persisted var clockPeriod: String = ""
    @Persisted var clockTime: String = ""
    @Persisted var clockRepeat: String = ""
    @Persisted var clockTag: String = ""
    @Persisted var clockSound: String = ""
    @Persisted var clockRemLat: Bool = true
    
    convenience init(clockPeriod: String, clockTime: String, clockRepeat: String, clockTag: String,
                     clockSound: String, clockRemLat: Bool) {
        self.init()
        self.clockPeriod = clockPeriod
        self.clockTime = clockTime
        self.clockRepeat = clockRepeat
        self.clockTag = clockTag
        self.clockSound = clockSound
        self.clockRemLat = clockRemLat
    }
}
