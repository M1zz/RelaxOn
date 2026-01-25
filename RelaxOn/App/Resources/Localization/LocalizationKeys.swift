//
//  LocalizationKeys.swift
//  RelaxOn
//
//  Type-safe localization keys for internationalization
//

import Foundation

/// Type-safe localization keys organized by feature
enum L {

    // MARK: - Sound List
    enum SoundList {
        static let title = "sound_list.title"
        static let createNew = "sound_list.create_new"
        static let sample = "sound_list.sample"
        static let recommended = "sound_list.recommended"
        static let originalSounds = "sound_list.original_sounds"
        static let searchPlaceholder = "sound_list.search_placeholder"
    }

    // MARK: - Create Sound
    enum CreateSound {
        static let title = "create_sound.title"
        static let back = "create_sound.back"
        static let create = "create_sound.create"
        static let canvasTitle = "create_sound.canvas_title"
        static let playing = "create_sound.playing"
        static let selectOriginal = "create_sound.select_original"
        static let selectBoth = "create_sound.select_both"
        static let canPlayNow = "create_sound.can_play_now"
        static let backgroundSound = "create_sound.background_sound"
        static let backgroundVolume = "create_sound.background_volume"
        static let originalSoundSelection = "create_sound.original_sound_selection"
        static let customizing = "create_sound.customizing"
        static let combinedFormat = "create_sound.combined_format"
    }

    // MARK: - Common
    enum Common {
        static let save = "common.save"
        static let cancel = "common.cancel"
        static let remove = "common.remove"
        static let reset = "common.reset"
    }

    // MARK: - Alert
    enum Alert {
        static let soundName = "alert.sound_name"
        static let enterName = "alert.enter_name"
        static let enterDescription = "alert.enter_description"
    }

    // MARK: - Category
    enum Category {
        static let none = "category.none"
        static let waterdrop = "category.waterdrop"
        static let singingBowl = "category.singing_bowl"
        static let bird = "category.bird"
    }

    // MARK: - Filter
    enum Filter {
        static let waterdrop = "filter.waterdrop"
        static let basement = "filter.basement"
        static let cave = "filter.cave"
        static let pipe = "filter.pipe"
        static let sink = "filter.sink"
        static let singingBowl = "filter.singing_bowl"
        static let focus = "filter.focus"
        static let training = "filter.training"
        static let empty = "filter.empty"
        static let vibration = "filter.vibration"
        static let bird = "filter.bird"
        static let owl = "filter.owl"
        static let woodpecker = "filter.woodpecker"
        static let forest = "filter.forest"
        static let cuckoo = "filter.cuckoo"
    }

    // MARK: - Background Sound
    enum Background {
        static let wave = "background.wave"
        static let rain = "background.rain"
        static let tv = "background.tv"
    }

    // MARK: - Presets
    enum Preset {
        enum DeepSleep {
            static let title = "preset.deep_sleep.title"
            static let description = "preset.deep_sleep.description"
        }

        enum QuickSleep {
            static let title = "preset.quick_sleep.title"
            static let description = "preset.quick_sleep.description"
        }

        enum Meditation {
            static let title = "preset.meditation.title"
            static let description = "preset.meditation.description"
        }

        enum Rest {
            static let title = "preset.rest.title"
            static let description = "preset.rest.description"
        }

        enum Focus {
            static let title = "preset.focus.title"
            static let description = "preset.focus.description"
        }

        enum Reading {
            static let title = "preset.reading.title"
            static let description = "preset.reading.description"
        }

        enum Rain {
            static let title = "preset.rain.title"
            static let description = "preset.rain.description"
        }

        enum ForestDawn {
            static let title = "preset.forest_dawn.title"
            static let description = "preset.forest_dawn.description"
        }
    }

    // MARK: - Customization
    enum Customize {
        static let volume = "customize.volume"
        static let pitch = "customize.pitch"
        static let interval = "customize.interval"
        static let variation = "customize.variation"
    }
}
