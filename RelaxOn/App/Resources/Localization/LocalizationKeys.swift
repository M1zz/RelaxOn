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
        static let enterSoundName = "create_sound.enter_sound_name"
        static let selectedLayers = "create_sound.selected_layers"
        static let selectOriginalSound = "create_sound.select_original_sound"
        static let combineMultipleSounds = "create_sound.combine_multiple_sounds"
        static let originalSounds = "create_sound.original_sounds"
        static let tapToSelectMultiple = "create_sound.tap_to_select_multiple"
        static let backgroundMusic = "create_sound.background_music"
        static let optionalAmbience = "create_sound.optional_ambience"
        static let deselect = "create_sound.deselect"
        static let backgroundMusicVolume = "create_sound.background_music_volume"
    }

    // MARK: - Common
    enum Common {
        static let save = "common.save"
        static let cancel = "common.cancel"
        static let remove = "common.remove"
        static let reset = "common.reset"
        static let done = "common.done"
        static let next = "common.next"
        static let filter = "common.filter"
        static let customized = "common.customized"
        static let variation = "common.variation"
        static let quiet = "common.quiet"
        static let loud = "common.loud"
        static let tapToCustomize = "common.tap_to_customize"
    }

    // MARK: - Alert
    enum Alert {
        static let soundName = "alert.sound_name"
        static let enterName = "alert.enter_name"
        static let enterDescription = "alert.enter_description"
        static let saveFailed = "alert.save_failed"
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
        static let piano = "background.piano"
        static let guitar = "background.guitar"
        static let ambient = "background.ambient"
        static let lofi = "background.lofi"
        static let meditation = "background.meditation"
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
        static let min = "customize.min"
        static let base = "customize.base"
        static let max = "customize.max"
        static let seconds = "customize.seconds"
        static let variationDescription = "customize.variation_description"
        static let variationDescriptionSeconds = "customize.variation_description_seconds"
        static let variationDescriptionPercent = "customize.variation_description_percent"
        static let findYourSound = "customize.find_your_sound"
        static let adjustSlider = "customize.adjust_slider"
        static let variationRange = "customize.variation_range"
    }

    // MARK: - Tab
    enum Tab {
        static let listen = "tab.listen"
    }

    // MARK: - Onboarding
    enum Onboarding {
        static let skip = "onboarding.skip"
        static let next = "onboarding.next"
        static let start = "onboarding.start"
        static let title1 = "onboarding.title1"
        static let title2 = "onboarding.title2"
        static let title3 = "onboarding.title3"
        static let title4 = "onboarding.title4"
        static let desc1 = "onboarding.desc1"
        static let desc2 = "onboarding.desc2"
        static let desc3 = "onboarding.desc3"
        static let desc4 = "onboarding.desc4"
    }

    // MARK: - Listen View
    enum Listen {
        static let selectSoundToPlay = "listen.select_sound_to_play"
        static let relaxWithWhiteNoise = "listen.relax_with_white_noise"
        static let playSoundForCampfire = "listen.play_sound_for_campfire"
        static let savedSounds = "listen.saved_sounds"
        static let noSavedSounds = "listen.no_saved_sounds"
        static let createFirstSound = "listen.create_first_sound"
        static let newSoundCreate = "listen.new_sound_create"
        static let mySounds = "listen.my_sounds"
        static let searchResults = "listen.search_results"
        static let noSearchResults = "listen.no_search_results"
        static let soundSearch = "listen.sound_search"
        static let presets = "listen.presets"
        static let recommendationMorning = "listen.recommendation_morning"
        static let recommendationFocus = "listen.recommendation_focus"
        static let recommendationEvening = "listen.recommendation_evening"
        static let recommendationSleep = "listen.recommendation_sleep"
        static let layerCount = "listen.layer_count"
        static let campfire = "listen.campfire"
        static let campfireDescription = "listen.campfire_description"
        static let rainSound = "listen.rain_sound"
        static let rainSoundDescription = "listen.rain_sound_description"
        static let heavyRain = "listen.heavy_rain"
        static let heavyRainDescription = "listen.heavy_rain_description"
    }

    // MARK: - Timer
    enum Timer {
        static let title = "timer.title"
        static let sleepTimer = "timer.sleep_timer"
        static let forGoodSleep = "timer.for_good_sleep"
        static let autoStopDescription = "timer.auto_stop_description"
        static let startTimer = "timer.start_timer"
        static let remainingTime = "timer.remaining_time"
        static let stop = "timer.stop"
        static let pause = "timer.pause"
        static let resume = "timer.resume"
        static let hours = "timer.hours"
        static let minutes = "timer.minutes"
    }

    // MARK: - Player
    enum Player {
        static let spatialAudio = "player.spatial_audio"
        static let positionAdjust = "player.position_adjust"
        static let layer = "player.layer"
        static let layerFormat = "player.layer_format"
        static let distance = "player.distance"
        static let angle = "player.angle"
        static let height = "player.height"
        static let realTimePlaying = "player.real_time_playing"
        static let hasVariation = "player.has_variation"
    }

    // MARK: - Sample Sounds
    enum Sample {
        static let morningMeditation = "sample.morning_meditation"
        static let focusTime = "sample.focus_time"
        static let sleepHelper = "sample.sleep_helper"
        static let rainFeeling = "sample.rain_feeling"
        static let calmNight = "sample.calm_night"
        static let caveWater = "sample.cave_water"
        static let meditationBell = "sample.meditation_bell"
        static let dawnBirds = "sample.dawn_birds"
        static let restTime = "sample.rest_time"
        static let natureSound = "sample.nature_sound"
    }

    // MARK: - Preset Sounds (New)
    enum PresetNew {
        enum DeepSleep {
            static let name = "preset_new.deep_sleep.name"
            static let description = "preset_new.deep_sleep.description"
        }
        enum RainSleep {
            static let name = "preset_new.rain_sleep.name"
            static let description = "preset_new.rain_sleep.description"
        }
        enum WhiteNoiseSleep {
            static let name = "preset_new.white_noise_sleep.name"
            static let description = "preset_new.white_noise_sleep.description"
        }
        enum CafeFocus {
            static let name = "preset_new.cafe_focus.name"
            static let description = "preset_new.cafe_focus.description"
        }
        enum DeepFocus {
            static let name = "preset_new.deep_focus.name"
            static let description = "preset_new.deep_focus.description"
        }
        enum StudyTime {
            static let name = "preset_new.study_time.name"
            static let description = "preset_new.study_time.description"
        }
        enum MeditationTime {
            static let name = "preset_new.meditation_time.name"
            static let description = "preset_new.meditation_time.description"
        }
        enum YogaStretching {
            static let name = "preset_new.yoga_stretching.name"
            static let description = "preset_new.yoga_stretching.description"
        }
        enum ForestWalk {
            static let name = "preset_new.forest_walk.name"
            static let description = "preset_new.forest_walk.description"
        }
        enum CaveExplore {
            static let name = "preset_new.cave_explore.name"
            static let description = "preset_new.cave_explore.description"
        }
        enum OceanWave {
            static let name = "preset_new.ocean_wave.name"
            static let description = "preset_new.ocean_wave.description"
        }
        enum SummerRain {
            static let name = "preset_new.summer_rain.name"
            static let description = "preset_new.summer_rain.description"
        }
    }

    // MARK: - Preset Categories
    enum PresetCategory {
        static let sleep = "preset_category.sleep"
        static let focus = "preset_category.focus"
        static let meditation = "preset_category.meditation"
        static let nature = "preset_category.nature"
        static let rain = "preset_category.rain"
    }
}
