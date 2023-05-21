//
//  Common.swift
//  RelaxOn
//
//  Created by Doyeon on 2023/05/17.
//

/**
 Public 하게 쓰여지는 프로퍼티 & 함수 등
 */

import Foundation

/**
 Bundle에 있는 mp3 파일 경로 불러오는 기능
 */
func getPathUrl(forResource: String, musicExtension: MusicExtension) -> URL? {
    Bundle.main.url(forResource: forResource, withExtension: musicExtension.rawValue) ?? nil
}

/**
 온보딩화면 이미지 프로퍼티
 */
var onBoardingImagesLight: [String] = ["1-light",
                                       "2-light",
                                       "3-light",
                                       "4-light"]
var onBoardingImageDark: [String] = ["1-dark",
                                    "2-dark",
                                    "3-dark",
                                    "4-dark"]
