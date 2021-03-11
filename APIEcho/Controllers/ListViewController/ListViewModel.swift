//
//  ListViewModel.swift
//  APIEcho
//
//  Created by Oleksandr Bardashevskyi on 10.03.2021.
//

import Foundation

class ListViewModel {
    func getTextStatistic(str: String) -> [TextStatisticModel] {
        var dict = [Character: Int]()
        var outputArray = [TextStatisticModel]()
        str.forEach { (char) in
            dict[char, default: 0] += 1
        }
        for (key, value) in dict {
            outputArray.append(TextStatisticModel(letter: key, count: value))
        }
        
        return outputArray.sorted { $0.letter < $1.letter }
    }
}
