//
//  ContentView.swift
//  clipboard
//
//  Created by limit on 2023/10/26.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var model: DataModel
    
    var body: some View {
        List(model.data ?? [], id: \.date) { item in
            HStack {
                Text(item.date.stringValue).padding()
                Text(item.pasted).padding()
            }
        }
    }
}
