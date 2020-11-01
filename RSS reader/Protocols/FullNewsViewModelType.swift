//
//  FullNewsViewModelType.swift
//  RSS reader
//
//  Created by Дмитрий on 29.10.2020.
//

import Foundation
import UIKit

protocol FullNewsViewModelType {
    var title: String { get }
    var image: UIImage? { get }
    var fullText: String { get }
}
