//
//  DecibelsView.swift
//  narugakuruga
//
//  Created by 森田将嵩 on 2025/03/18.
//

import SwiftUI

struct DecibelsView: View {
    @StateObject private var decibelViewModel = DecibelViewModel()
    @State var TargetDecibel: Float = 0.0
    @State var judgeScore = false

    var body: some View {
        VStack {
            Text(judgeScore ? "成功！" : "あとちょっと！")
            Text("デシベル: \(String(format: "%.1f", decibelViewModel.decibels)) dB")
                .padding()

            if !decibelViewModel.isRecording {
                TextField("Float", value: $TargetDecibel, format: .number)
                    .textFieldStyle(.roundedBorder)

                    .keyboardType(.decimalPad)
            }
            Button(action: {
                if decibelViewModel.isRecording {
                    decibelViewModel.stopRecording()
                } else {
                    decibelViewModel.startRecording()
                }
            }) {
                Text(decibelViewModel.isRecording ? "停止" : "計測開始")
                    .font(.title)
                    .padding()
                    .frame(width: 200, height: 50)
                    .background(decibelViewModel.isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .onAppear {
                decibelViewModel.targetDecibel = TargetDecibel
            }
            // onChangeの新しい使用方法
            .onChange(of: decibelViewModel.decibels) {
                judgeScore = decibelViewModel.decibels > TargetDecibel
            }
        }
    }
}

#Preview {
    DecibelsView()
}
