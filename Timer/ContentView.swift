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
    @State  var setnum: Int = 1
    @State  var showPicker: Bool = false
    
    //画面遷移
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
                HStack(spacing:20){
                    //オプションの選択を可能にする
                    Button(action: {
                        withAnimation(.default){
                            //Pickerの表示・非表示を切り替える
                            self.showPicker.toggle()
                        }
                    }) {
                        VStack(){
                            Text("セット数").padding(.horizontal).padding(.top)
                            Text("\(self.setnum) 回").padding()
                            Spacer()
                        }
                        .frame(width: 150.0, height: 80.0)
                        .foregroundColor(.white).background(Color.blue).cornerRadius(10).padding(.leading)
                    }
                    //オプションの選択を可能にする
                    Button(action: {
                        withAnimation(.default){
                            //Pickerの表示・非表示を切り替える
                            self.showPicker.toggle()
                        }
                    }) {
                        VStack(){
                            Text("休憩").padding(.horizontal).padding(.top)
                            Text("\(setnum)" + "秒").padding()
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
                    }.frame(width: 320.0, height: 60.0).foregroundColor(.white).background(gradientView(start:Color.orange,end: Color.orange.opacity(0.5))).cornerRadius(10).padding(.horizontal)
                    
                    NavigationLink(destination : SecondView(totaltime:CGFloat((self.hour*3600)+(self.minute*60)+self.seconds)),tag: 1, selection: $page) {  }
                    
                    playerPicker(setnum: self.$setnum, showPicker: self.$showPicker).offset(y: self.showPicker ? 0 : UIScreen.main.bounds.height).frame(alignment: .bottom)
                }
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

struct playerPicker: View {
    @Binding  var setnum: Int
    @Binding  var showPicker: Bool
    
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
            Picker(selection: self.$setnum, label: Text("")) {
                ForEach(1..<51){index in
                    Text("\(index)")
                }
            }.pickerStyle(WheelPickerStyle()).background(Color(red: 0.95, green: 0.95, blue: 0.97, opacity: 1.0))
        }.background(Color(red: 0.9, green: 0.9, blue: 0.92, opacity: 1.0)).frame(height:60)
    }
}


func gradientView(start: Color, end: Color) -> LinearGradient {
    return LinearGradient(
        gradient: Gradient(colors: [start, end]),
        startPoint: .leading,
        endPoint: .trailing)
}
