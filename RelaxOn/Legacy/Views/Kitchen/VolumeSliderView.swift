//
//  VolumeSliderView.swift
//  RelaxOn
//
//  Created by Minkyeong Ko on 2022/09/14.
//

import SwiftUI
import MediaPlayer
import UIKit

struct VolumeSliderView: UIViewRepresentable {
    let volumeView = MPVolumeView(frame: .zero)
    
   func makeUIView(context: Context) -> MPVolumeView {
       volumeView
   }

   func updateUIView(_ view: MPVolumeView, context: Context) {}
}

struct VolumeSliderView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeSliderView()
    }
}

extension MPVolumeView {
    static func setVolume(_ volume: Float) -> Void {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            slider?.value = volume
        }
    }
    
    static func getVolume() -> Float {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        var volume: Float = 0.0

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.01) {
            volume = slider?.value ?? 0.0
        }
        
        return volume
    }
}

import AVFoundation

//final class VolumeObserver: ObservableObject {
//
//    @Published var volume: Float = AVAudioSession.sharedInstance().outputVolume
//
//    // Audio session object
//    private let session = AVAudioSession.sharedInstance()
//
//    // Observer
//    private var progressObserver: NSKeyValueObservation!
//
//    func subscribe() {
//
//        progressObserver = session.observe(\.outputVolume) { [self] (session, value) in
//            DispatchQueue.main.async {
//                self.volume = session.outputVolume
//                print("test")
//            }
//        }
//    }
//
//    func unsubscribe() {
//        self.progressObserver.invalidate()
//    }
//
//    init() {
//        subscribe()
//    }
//}
