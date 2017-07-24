//
//  Array2D.swift
//  Kafka
//
//  Created by Ju on 23/07/2017.
//  Copyright © 2017 TroisYaourts. All rights reserved.
//

import Foundation

class Array2D<T> {
    
    let columns: Int
    let rows: Int
    
    var array: Array<T?>

    
    init(columns: Int, rows: Int) {
        self.columns = columns
        self.rows = rows
        array = Array<T?>(repeating: nil, count:rows * columns)
    }
    
    subscript(column: Int, row: Int) -> T? {
        get {
            return array[(row * columns) + column]
        }
        set(newValue) {
            array[(row * columns) + column] = newValue
        }
    }
}
