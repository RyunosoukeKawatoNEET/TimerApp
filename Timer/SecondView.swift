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
    @Binding var isShowSecondView : Bool
    
    @State var outputSeconds : CGFloat = 5
    
    @State var isFinished :Bool = false
    @State var isStop :Bool = false
    @State var start : Bool = false
    
    @State var setCount : Int = 0
    
    @State var to : CGFloat = 0
    @State var count : CGFloat = 0
    @State var time = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    @State var page:Int? = 0
    
    var body: some View {
        VStack{
            //Text("\(self.totaltime)")
            CircleV(to : self.$to,count : self.$count,start: self.$start,outputSeconds : self.outputSeconds,setCount : self.$setCount,totaltime:self.totaltime)
            optionInfo(setNum: self.setNum,setCount: self.setCount,restSecond: self.restSecond,totaltime : self.totaltime)
            ButtonV1(isStop : self.$isStop,to : self.$to,count : self.$count,totaltime : self.totaltime,
                     setCount : self.$setCount,
                     setNum : self.setNum,outputSeconds: self.$outputSeconds,
                     isShowSecondView : $isShowSecondView,isFinished : self.$isFinished,start : self.$start)
            
            //タイマー関連の制御
            .onReceive(self.time) { (_) in
                if !isStop{
                    //継続中
                    if self.count <= self.outputSeconds{
                        self.count += 0.1
                        //進捗バーをアニメーションで変化させる
                        withAnimation(.default){
                            self.to = CGFloat(self.count) / CGFloat(self.outputSeconds)
                        }
                    //終了
                    }else{
                        //start=trueの場合は、終了条件を確認する
                        if start {
                            self.setCount += 1
                            if self.setCount == self.setNum{
                                self.isStop.toggle()
                                self.isFinished.toggle()
                            }
                        }
                        
                        if self.setCount != self.setNum{
                            self.outputSeconds = self.totaltime
                            self.count = 0
                        }
                        
                        self.start.toggle()
                        
                        //進捗バーをリセット※アニメーションなし
                        self.to = CGFloat(self.count) / CGFloat(self.outputSeconds)
                    }
                }
            }
        }
    }
}

struct CircleV : View{
    @Binding var to: CGFloat
    @Binding var count: CGFloat
    @Binding var start: Bool //true:運動中 false:休憩中
    var outputSeconds:CGFloat
    @Binding var setCount:Int //現在のセット数
    var totaltime :CGFloat
    
    var body: some View{
        ZStack{
            Circle().trim(from: 0, to: 1)
            //storoke 円を輪にする
            //linecap 円の形
            //trim トリミング
                .stroke(Color.black.opacity(0.09), style: StrokeStyle(lineWidth: 15,lineCap: .round))
                .frame(width: 280, height: 280)
            
            //rotationEffect 起点を指定して、回転させる
            Circle().trim(from: (1 - self.to), to: 1)
                .stroke(Color( self.start  ? .red : .blue ), style: StrokeStyle(lineWidth: 15,lineCap: .round))
                .frame(width: 280, height: 280)
                .rotationEffect(.init(degrees: -90))
            
            VStack{
                Text(printdata(totaltimemin:TimeInterval(self.outputSeconds - self.count + 0.99999999))).font(.system(size: 65))
                    .fontWeight(.bold)
                
                Text(outPutState(start:self.start,setCount:self.setCount,totaltime: self.totaltime)).foregroundColor(Color(self.start  ? .red : .blue ))
                }
            }
        }
    }

func outPutState(start: Bool,setCount: Int,totaltime:CGFloat) -> String{
    if (!start) && setCount == 0 {
        return "準備"
    }else if start{
        return "/ " + printdata(totaltimemin:TimeInterval(totaltime))
    }else{
        return "休憩"
    }
}

struct ButtonV1 : View{
    @Binding var isStop : Bool
    @Binding var to : CGFloat
    @Binding var count : CGFloat
    var totaltime: CGFloat
    @Binding var setCount : Int
    var setNum : Int
    
    @Binding var outputSeconds : CGFloat
    @Binding var isShowSecondView : Bool
    @Binding var isFinished : Bool
    @Binding var start : Bool
    
    var body: some View{
        //spacing 余白を設定する
        HStack(spacing:20){
            Button(action: {
                self.isStop.toggle()
                if (isFinished) {
                    
                    self.outputSeconds = 5
                    
                    self.isFinished = false
                    self.start = false
                    self.isStop = false
                    
                    self.setCount = 0
                    self.to = 0
                    self.count = 0
                }
            }){
                HStack(spacing:15){
                    Image(systemName: self.isStop ? "play.fill" : "pause.fill")
                        .foregroundColor(.white)
                    
                    Text(self.isStop ? "再開":"一時停止")
                        .foregroundColor(.white)
                }
                .padding(.vertical)
                .frame(width: 150.0)
                .background(Color.red)
                .clipShape(Capsule())
            }
            
            Button(action: {
                isShowSecondView = false
            }){
                HStack(spacing:15){
                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.red)
                    
                    Text("終了")
                        .foregroundColor(.red)
                }
                .padding(.vertical)
                .frame(width:  150.0)
                .background(
                    Capsule()
                        .stroke(Color.red)//, lineWidth: 2)
                )
            }
        }
    }
}

struct optionInfo : View{
    var setNum :Int
    var setCount :Int
    var restSecond :Int
    var totaltime:CGFloat
    
    var body:some View{
        HStack(spacing:20){
            
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(Color.green).frame(width: 150.0, height: 60.0).padding(.leading)
                .overlay(
                    VStack(){
                        Text("セット数").padding(.horizontal).padding(.leading)
                        Text("\(self.setCount) / \(self.setNum) 回").padding(.leading).font(.title3)
                    }.foregroundColor(.white)
                )
            
            RoundedRectangle(cornerRadius:10)
                .foregroundColor(Color.blue).frame(width: 150.0, height: 60.0).padding(.trailing)
                .overlay(
                    VStack(){
                        Text("休憩").padding(.horizontal).padding(.trailing)
                        Text("\(self.restSecond) 秒").padding(.trailing).font(.title3)
                    }.foregroundColor(.white)
                )
        }.padding(.top)
    }
}

func printdata(totaltimemin:TimeInterval) -> String{
    let dateFormatter = DateComponentsFormatter()
    
    dateFormatter.unitsStyle = .positional
    dateFormatter.allowedUnits = [.hour, .minute, .second]
    //dateFormatter.zeroFormattingBehavior = .pad
    return (dateFormatter.string(from: totaltimemin)!).replacingOccurrences(of: "00:", with: "")
}

