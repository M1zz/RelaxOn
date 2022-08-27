//
//  View+Extension.swift
//  RelaxOn
//
//  Created by Moon Jongseek on 2022/08/25.
//

import SwiftUI

extension View {
    func getEncodedData(data: [MixedSound]) -> Data? {
        do {
            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(data)
            return encodedData
        } catch {
            print("Unable to Encode Note (\(error))")
        }
        return nil
    }
    
    func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}
