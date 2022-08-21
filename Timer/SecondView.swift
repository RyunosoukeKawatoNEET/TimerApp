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
    var setNum : Int
    var restSecond : Int
    
    @State var outputSeconds : CGFloat = 5
    
    @State var start : Bool = true
    @State var reststart : Bool = true
    
    @State var to : CGFloat = 0
    @State var count : CGFloat = 0
    @State var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        
        VStack{
            //Text("\(self.totaltime)")
            CircleV(to : self.$to,count : self.$count,totaltime : self.totaltime)
            ButtonV(start : self.$start,to : self.$to,count : self.$count,totaltime : self.totaltime)
        }
        //タイマー関連の制御
        .onReceive(self.time) { (_) in
            if self.reststart{
                
            }
            if self.start{
                if self.count <= self.totaltime{
                    self.count += 0.1
                    //進捗バーをアニメーションで変化させる
                    withAnimation(.default){
                        self.to = CGFloat(self.count) / CGFloat(self.totaltime)
                    }
                }else{
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
                Text(printdata(totaltimemin:TimeInterval(self.totaltime - self.count))).font(.system(size: 65))
                    .fontWeight(.bold)
                
                Text(printdata(totaltimemin:TimeInterval(self.count))).font(.title)
                Text(printdata(totaltimemin:TimeInterval(self.totaltime))).font(.title)
            }
        }
    }
    func printdata(totaltimemin:TimeInterval) -> String{
        let dateFormatter = DateComponentsFormatter()
        
        dateFormatter.unitsStyle = .positional
        dateFormatter.allowedUnits = [.hour, .minute, .second]
        return (dateFormatter.string(from: totaltimemin)!)
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
                if self.count >= self.totaltime{
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


