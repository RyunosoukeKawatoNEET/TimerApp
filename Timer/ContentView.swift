//
//  ContentView.swift
//  Timer
//
//  Created by 川戸竜之介 on 2022/07/31.
//

import SwiftUI

struct ContentView: View {
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    @State private var seconds: Int = 0
    
    //オプション設定
    @State  var setNum: Int = 1
    @State  var restSecond: Int = 5
    @State  var showPickerSet: Bool = false
    @State  var showPickerRest: Bool = false
    
    //画面遷移
    //@State var page : Int? = 0
    @State var isShowSecondView: Bool = false
    @State var timeMoreZero:Bool = false
    
    var body: some View {
        NavigationView {
            VStack() {
                HStack(spacing : 0){
                    pickerView(num: $hour, maxnum : 24,minnum : 0,hour: $hour,minute: $minute,seconds: $seconds,timeMoreZero: $timeMoreZero)
                    Text("時間").frame(width: 50, height: 50, alignment: .leading)
                    pickerView(num: $minute, maxnum : 60,minnum : 0,hour: $hour,minute: $minute,seconds: $seconds,timeMoreZero: $timeMoreZero)
                    Text("分").frame(width:32,height: 50, alignment: .leading)
                    pickerView(num: $seconds, maxnum : 60, minnum :0,hour: $hour,minute: $minute,seconds: $seconds,timeMoreZero: $timeMoreZero)
                    Text("秒").frame(width:32,height: 50, alignment: .leading)
                }
                HStack(spacing:20){
                    //オプションの選択を可能にする
                    Button(action: {
                        withAnimation(.default){
                            //Pickerの表示・非表示を切り替える
                            self.showPickerSet.toggle()
                        }
                    }) {
                        VStack(){
                            Text("セット数").padding(.horizontal)
                            Text("\(self.setNum) 回").font(.title3)
                        }
                        .frame(width: 150.0, height: 60.0)
                        .foregroundColor(.white)
                        .background(Color.green)
                        .clipShape(Capsule())
                        //.cornerRadius(10)
                        .padding(.leading)
                        .shadow(radius: 5)
                    }
                    //オプションの選択を可能にする
                    Button(action: {
                        withAnimation(.default){
                            //Pickerの表示・非表示を切り替える
                            self.showPickerRest.toggle()
                        }
                    }) {
                        VStack(){
                            Text("休憩").padding(.horizontal)
                            Text("\(self.restSecond) 秒").font(.title3)
                        }
                        .frame(width: 150.0, height: 60.0)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Capsule())
                        //.cornerRadius(10)
                        .padding(.trailing)
                        .shadow(radius: 5)                    }
                }
                ZStack{
                    NavigationLink(destination:
                                    SecondView(totaltime:calcTime(hour: self.hour,minute: self.minute,seconds: self.seconds),setNum:self.setNum,restSecond:self.restSecond,isShowSecondView: $isShowSecondView).navigationBarHidden(true),isActive: $isShowSecondView){}
                    
                    Button(action: {
                        self.isShowSecondView = true
                    }) {
                        HStack(spacing:15){
                            Image(systemName: "play.fill").foregroundColor(.white)
                            
                            Text("開始").font(.title3)
                                .foregroundColor(.white)
                            //.background(Color.orange).cornerRadius(10).padding(.horizontal)
                        }
                        .disabled(!timeMoreZero)
                            .frame(width: 320.0,height: 60.0)
                            .background(Color.red)
                            .clipShape(Capsule())
                            .shadow(radius: 5)
                    }
                    
                    //totaltimeが0の場合はボタンを非活性に見せる
                    Button(action: {
                    }) {}
                        .frame(width: 320.0, height: 60.0)
                        .background(self.timeMoreZero ? Color(red: 0.78, green: 0.78, blue: 0.78, opacity: 0.0) :Color(red: 0.78, green: 0.78, blue: 0.78, opacity: 0.5))
                        .clipShape(Capsule())
                    
                    //下に表示するPickerのView
                    underPicker(setNum: self.$setNum, showPicker: self.$showPickerSet, minNum: 1,maxNum: 51,unit: "回").offset(y: self.showPickerSet ? 0 : UIScreen.main.bounds.height).frame(alignment: .bottom)
                    
                    underPicker(setNum: self.$restSecond, showPicker: self.$showPickerRest, minNum: 5,maxNum: 1001,unit: "秒").offset(y: self.showPickerRest ? 0 : UIScreen.main.bounds.height).frame(alignment: .bottom)
                }
            }
        }.navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewInterfaceOrientation(.portrait)
    }
}

struct underPicker: View {
    @Binding  var setNum: Int
    @Binding  var showPicker: Bool
    let minNum: Int
    let maxNum: Int
    let unit: String
    
    var body: some View {
        VStack(){
            Button(action: {
                withAnimation(.default){
                    self.showPicker = false
                }
            }) {
                HStack {
                    Spacer() //右寄せにするため使用
                    Text("完了")
                        .padding(.horizontal, 15.0)
                        .padding(.vertical, 5.0)
                }
            }
            //ユーザを入力するピッカー
            Picker(selection: self.$setNum, label: Text("")) {
                ForEach(minNum ..< maxNum, id: \.self){index in
                    if unit == "秒" && index % 5 == 0 {
                        Text("\(index) \(unit)")
                    }else if unit == "回"{
                        Text("\(index) \(unit)")
                    }
                }
            }.pickerStyle(WheelPickerStyle()).background(Color(red: 0.95, green: 0.95, blue: 0.97, opacity: 1.0))
        }.background(Color(red: 0.9, green: 0.9, blue: 0.92, opacity: 1.0)).frame(height:60)
    }
}

struct pickerView: View{
    @Binding var num:Int
    var maxnum:Int
    var minnum:Int
    
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var seconds: Int
    
    @Binding var timeMoreZero :Bool
    
    var body: some View {
        TimePicker(num: $num, maxnum : maxnum,minnum : minnum)
            .onChange(of: num){ value in
                if checkTime(hour: self.hour,minute: self.minute,seconds: self.seconds){
                    timeMoreZero = true
                }else{
                    timeMoreZero = false
                }
            }.frame(width: 70)
    }
}

func calcTime(hour:Int,minute:Int,seconds:Int) -> CGFloat {
    let totaltime = hour * 3600 + minute * 60 + seconds
    return CGFloat(totaltime)
}

func checkTime(hour:Int,minute:Int,seconds:Int) -> Bool{
    calcTime(hour:hour,minute:minute,seconds:seconds) > 0
}
