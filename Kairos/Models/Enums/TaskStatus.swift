//
//  TaskStatus.swift
//  Kairos
//
//  Created by Despina Misheva on 10.11.25.
//

import Foundation

//There is no omitted or not complete here and there wont be since Ill need workers to mark them as not complete at specified times
enum TaskStatus: String, Codable {
    case pending
    case completed
}
