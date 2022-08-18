//
//  TimePicker.swift
//  Timer
//
//  Created by 川戸竜之介 on 2022/07/31.
//
import SwiftUI

struct TimePicker: UIViewRepresentable {
    
    var num: Binding<Int>
    var maxnum: Int
    var minnum: Int
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    
    func makeUIView(context: UIViewRepresentableContext<TimePicker>) -> UIPickerView {
        let picker = UIPickerView()
        
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<TimePicker>) {
        view.selectRow(num.wrappedValue, inComponent: 0, animated: false)
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: TimePicker
        
        init(_ pickerView: TimePicker) {
            parent = pickerView
        }
        ///列数の定義
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
        ///各行の値の最大値を定義
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return parent.maxnum - parent.minnum
        }
        
        ///Pickerの描画の幅
        func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
            return 60
        }
        
        ///Pickerの描画の高さ
        func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
            return 45
        }
        
        ///フォーマットの指定とComponentの返り値の数値をString型にして出力
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return String(format: "%2d", row + parent.minnum)
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
                parent.num.wrappedValue = row
        }
    }
}

