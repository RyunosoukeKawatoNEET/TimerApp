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
    
    //オプション設定
    @State  var setNum: Int = 1
    @State  var restSecond: Int = 5
    @State  var showPickerSet: Bool = false
    @State  var showPickerRest: Bool = false
        
    //画面遷移
    @State var page : Int? = 0
    @State var isShowSecondView: Bool = false
    
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
                HStack(spacing:20){
                    //オプションの選択を可能にする
                    Button(action: {
                        withAnimation(.default){
                            //Pickerの表示・非表示を切り替える
                            self.showPickerSet.toggle()
                        }
                    }) {
                        VStack(){
                            Text("セット数").padding(.horizontal).padding(.top)
                            Text("\(self.setNum) 回").padding()
                            Spacer()
                        }
                        .frame(width: 150.0, height: 80.0)
                        .foregroundColor(.white).background(Color.blue).cornerRadius(10).padding(.leading)
                    }
                    //オプションの選択を可能にする
                    Button(action: {
                        withAnimation(.default){
                            //Pickerの表示・非表示を切り替える
                            self.showPickerRest.toggle()
                        }
                    }) {
                        VStack(){
                            Text("休憩").padding(.horizontal).padding(.top)
                            Text("\(self.restSecond) 秒").padding()
                            Spacer()
                        }
                        .frame(width: 150.0, height: 80.0)
                        .foregroundColor(.white)
                        .background(Color.green).cornerRadius(10).padding(.trailing)
                    }
                }
                ZStack{
                    Button(action: {
                        page = 1
                    }) {
                        Text("開始")
                            .padding()
                    }.frame(width: 320.0, height: 60.0)
                        .foregroundColor(.white)
                        .background(Color.orange).cornerRadius(10).padding(.horizontal)

                    NavigationLink(destination:
                                    //SecondView(totaltime:CGFloat((self.hour*3600)+(self.minute*60)+self.seconds),
                                   SecondView(totaltime:calcTime(hour: self.hour,minute: self.minute,seconds: self.seconds),
                                               setNum:self.setNum,
                                               restSecond:self.restSecond),
                                   tag: 1, selection: $page) {  }
                    
                    //下に表示するPickerのView
                    underPicker(setNum: self.$setNum, showPicker: self.$showPickerSet, minNum: 1,maxNum: 50,unit: "回").offset(y: self.showPickerSet ? 0 : UIScreen.main.bounds.height).frame(alignment: .bottom)
                    
                    underPicker(setNum: self.$restSecond, showPicker: self.$showPickerRest, minNum: 5,maxNum: 1000,unit: "秒").offset(y: self.showPickerRest ? 0 : UIScreen.main.bounds.height).frame(alignment: .bottom)
                }
            }
        }
    }
    func calcTime(hour:Int,minute:Int,seconds:Int) -> CGFloat {
        //secondsの最小値の補正のため+5する
        let totaltime = hour * 3600 + minute * 60 + (seconds + 5)
        return CGFloat(totaltime)
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

