//
//  Products.swift
//  TheReservist
//
//  Created by Marcus Kida on 23/09/2014.
//  Copyright (c) 2014 Marcus Kida. All rights reserved.
//

import Foundation

class Products {
    
    let json = JSON(data: NSData(contentsOfFile: NSBundle.mainBundle().pathForResource("parts", ofType: "json")!))
    
    func name(partNumber: String) -> String? {
        return property(partNumber, key: "localizedName")
    }
    
    func color(partNumber: String) -> String? {
        return property(partNumber, key: "colorName")
    }
    
    func size(partNumber: String) -> String? {
        return property(partNumber, key: "size")
    }
    
    func colorUrl(partNumber: String) -> NSURL? {
        if let urlString = property(partNumber, key: "colorUrl") {
            return NSURL(string: urlString)
        }
        return nil;
    }
    
    func colorUrl2x(partNumber: String) -> NSURL? {
        if let urlString = property(partNumber, key: "colorUrl2x") {
            return NSURL(string: urlString)
        }
        return nil;
    }
    
    private func property(partNumber: String, key: String) -> String? {
        if let product = json[partNumber].dictionaryValue {
            if let name = product[key] {
                return name.stringValue;
            }
        }
        return nil
    }
}