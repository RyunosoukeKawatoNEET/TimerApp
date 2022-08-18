//
//  SecondView.swift
//  Timer
//
//  Created by 川戸竜之介 on 2022/08/16.
//

import SwiftUI
import UserNotifications

struct SecondView: View {
    var totaltime : CGFloat
    
    @State var start = false
    @State var to : CGFloat = 0
    @State var count : CGFloat = 0
    @State var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack{
            //Text("\(self.totaltime)")
            CircleV(to : self.$to,count : self.$count,totaltime : self.totaltime)
            ButtonV(start : self.$start,to : self.$to,count : self.$count,totaltime : self.totaltime)
        }
        .onReceive(self.time) { (_) in
            if self.start{
                if self.count != self.totaltime{
                    self.count += 0.1
                    //進捗バーをアニメーションで変化させる
                    withAnimation(.default){
                        self.to = CGFloat(self.count) / CGFloat(self.totaltime)
                    }
                }
                else{
                    self.start.toggle()
                }
            }
        }
    }
}

struct CircleV : View{
    @Binding var to: CGFloat
    @Binding var count: CGFloat
    var totaltime:CGFloat
    
    var body: some View{
        ZStack{
            Circle().trim(from: 0, to: 1)
            //storoke 円を輪にする
            //linecap 円の形
            //trim トリミング
                .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 35,lineCap: .round))
                .frame(width: 280, height: 280)
            
            //rotationEffect 起点を指定して、回転させる
            Circle().trim(from: (1 - self.to), to: 1)
                .stroke(Color.red, style: StrokeStyle(lineWidth: 35,lineCap: .round))
                .frame(width: 280, height: 280)
                .rotationEffect(.init(degrees: -90))
            
            VStack{
                Text("\(Int(self.count))").font(.system(size: 65))
                    .fontWeight(.bold)
                
                Text("Of \(Int(self.totaltime))").font(.title).padding(.top)
            }
        }
    }
}

struct ButtonV : View{
    @Binding var start : Bool
    @Binding var to : CGFloat
    @Binding var count : CGFloat
    var totaltime: CGFloat
    
    var body: some View{
        //spacing 余白を設定する
        HStack(spacing:20){
            Button(action: {
                
                if self.count == self.totaltime{
                    self.count = 0
                    withAnimation(.default){
                        self.to = 0
                    }
                }
                
                self.start.toggle()
                
            }){
                HStack(spacing:15){
                    
                    Image(systemName: self.start ? "pause.fill" : "play.fill")
                        .foregroundColor(.white)
                    
                    Text(self.start ? "pause":"play")
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                .background(Color.red)
                .clipShape(Capsule())
            }
            
            Button(action: {
                
                self.count = 0
                
                withAnimation(.default){
                    self.to = 0
                }
            }){
                HStack(spacing:15){
                    
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.red)
                    
                    Text("Restart")
                        .foregroundColor(.red)
                }
                .padding(.vertical)
                .frame(width: (UIScreen.main.bounds.width / 2) - 55)
                .background(
                    
                    Capsule()
                        .stroke(Color.red, lineWidth: 2)
                )
            }
        }
        .padding(.top, 55)
    }
}
