//
//  ContentView.swift
//  Timer
//
//  Created by 川戸竜之介 on 2022/07/31.
//

import SwiftUI

struct ContentView: View {
    @State private var hour: Int = 0
    @State private var minute: Int = 30
    @State private var seconds: Int = 30
    
    @State var page : Int? = 0
    @State var isShowSecondView = false
    
    @State var screen: CGSize!
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack(spacing : 0){
                    TimePicker(num: $hour, maxnum : 24,minnum : 0).frame(width: 70)
                    Text("時間").frame(width: 50, height: 50, alignment: .leading)
                    TimePicker(num: $minute, maxnum : 60, minnum: 0).frame(width: 70)
                    Text("分").frame(width:32,height: 50, alignment: .leading)
                    TimePicker(num: $seconds, maxnum : 60, minnum :5).frame(width: 70)
                    Text("秒").frame(width:32,height: 50, alignment: .leading)
                }
                HStack(spacing:0){
                    //TimePicker()
                }
                Button(action: {
                    page = 1
                }) {
                    Text("開始")
                        .padding()
                }.frame(width: 200.0, height: 60.0).foregroundColor(.white).background(gradientView(start:Color.orange,end: Color.orange.opacity(0.5))).cornerRadius(20)
                
                NavigationLink(destination : SecondView(totaltime:CGFloat((self.hour*3600)+(self.minute*60)+self.seconds)),tag: 1, selection: $page) {  }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

func gradientView(start: Color, end: Color) -> LinearGradient {
    return LinearGradient(
        gradient: Gradient(colors: [start, end]),
        startPoint: .leading,
        endPoint: .trailing)
}
