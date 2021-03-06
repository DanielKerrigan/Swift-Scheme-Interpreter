//
//  SchemeError.swift
//  Scheme-Interpreter
//
//  Created by Dan Kerrigan on 7/5/16.
//  Copyright © 2016 Dan Kerrigan. All rights reserved.
//

import Foundation

enum SchemeError: Error {
    case syntax(String)
    case evaluator(String)
}
