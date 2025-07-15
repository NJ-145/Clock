//
//  Singleton.swift
//  Clock
//
//  Created by imac-2626 on 2024/11/19.
//

import Foundation

class day_value {
    // 儲存被選中的天數
    var select = [Int]()
    static let shared = day_value()
    // 讓這個類別無法被外部初始化，強制讓外部只能使用 shared 這個單例物件
    private init() {}
}

class sound_value {
    var select = "放射(預設值)"
    static let shared = sound_value()
    private init() {}
}
