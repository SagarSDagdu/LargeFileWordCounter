//
//  StreamReader.swift
//  Word Counter
//
//  Created by Sagar on 26/09/18.
//  Copyright © 2018 Sagar. All rights reserved.
//

import UIKit

class StreamReader: NSObject {
    private let encoding : String.Encoding
    private let chunkSize : Int //Number of bytes to read at a time
    private var fileHandle : FileHandle!
    private let delimData : Data
    private var buffer : Data
    private var reachedEndOfFile : Bool
    
    init?(path: String, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {
        guard let fileHandle = FileHandle(forReadingAtPath: path),
            let delimiterData = delimiter.data(using: encoding) else {
                return nil
        }
        
        self.encoding = encoding
        self.chunkSize = chunkSize
        self.fileHandle = fileHandle
        self.delimData = delimiterData
        self.buffer = Data(capacity: chunkSize)
        self.reachedEndOfFile = false
    }
    
    deinit {
        self.close()
    }
    
    func nextLine() -> String? {
        precondition(self.fileHandle != nil, "Cannot open file")
        
        while !self.reachedEndOfFile {
            if let range = self.buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: self.buffer.subdata(in: 0..<range.lowerBound), encoding: self.encoding)
                // Remove line (and the delimiter) from the buffer:
                self.buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = self.fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                self.buffer.append(tmpData)
            } else {
                // EOF or read error.
                self.reachedEndOfFile = true
                if self.buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: self.buffer as Data, encoding: self.encoding)
                    self.buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    private func close() -> Void {
        self.fileHandle?.closeFile()
        self.fileHandle = nil
    }
}
