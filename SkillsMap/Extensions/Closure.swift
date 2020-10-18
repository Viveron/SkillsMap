//
//  Closure.swift
//  SkillsMap
//
//  Created by Victor Shabanov on 17.10.2020.
//  Copyright © 2020 GOTO: 2020. All rights reserved.
//

import Foundation

public typealias Closure<Value, Result> = (Value) -> Result
public typealias ValueClosure<Value> = Closure<Value, Void>
public typealias ResultClosure<Result> = () -> Result
public typealias VoidClosure = ResultClosure<Void>

public typealias ThrowsClosure<Value, Result> = (Value) throws -> Result
public typealias ThrowsValueClosure<Value> = ThrowsClosure<Value, Void>
public typealias ThrowsResultClosure<Result> = () throws -> Result
public typealias ThrowsVoidClosure = ThrowsResultClosure<Void>
