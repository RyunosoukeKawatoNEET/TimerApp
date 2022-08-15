//
//  SecondView.swift
//  Timer
//
//  Created by 川戸竜之介 on 2022/08/16.
//

import SwiftUI

struct SecondView: View {
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var seconds: Int

    var body: some View {
        Text("\(hour)")
    }
}
