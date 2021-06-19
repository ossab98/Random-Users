//
//  String-Extention.swift
//  Random Users
//
//  Created by Ossama Abdelwahab on 19/06/21.
//

import UIKit

extension String {
    func replace(string:String, replacement:String) -> String {
        return self.replacingOccurrences(of: string, with: replacement, options: NSString.CompareOptions.literal, range: nil)
    }
    
    func removeWhitespace() -> String {
        return self.replace(string: " ", replacement: "")
    }
    
    /*
     Example:
     
     let string = "The quick brown dog jumps over the foxy lady."
     let result = string.removeWhitespace() // Thequickbrowndogjumpsoverthefoxylady
     */
}
