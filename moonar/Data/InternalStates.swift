//
//  InternalStates.swift
//  moonar
//
//  Created by Владислав Калиниченко on 14.04.2022.
//

import SwiftUI

let greenColor: Color = Color(UIColor(red: 67 / 255, green: 255 / 255, blue: 1 / 255, alpha: 1))
let yellowColor: Color = Color(UIColor(red: 255 / 255, green: 230 / 255, blue: 0 / 255, alpha: 1))
let redColor: Color = Color(UIColor(red: 255 / 255, green: 0 / 255, blue: 61 / 255, alpha: 1))
let blueColor: Color = Color(UIColor(red: 0 / 255, green: 209 / 255, blue: 255 / 255, alpha: 1))
let darkGrayColor: Color = Color(UIColor(red: 30 / 255, green: 30 / 255, blue: 30 / 255, alpha: 1))

let greenGradient = LinearGradient(
	gradient: .init(colors: [greenColor, Color(UIColor(red: 39 / 255, green: 193 / 255, blue: 128 / 255, alpha: 1))]),
	startPoint: .init(x: 0, y: 0),
	endPoint: .init(x: 1, y: 1)
)

let whiteGradient = LinearGradient(
	gradient: .init(colors: [Color.white, Color(UIColor(red: 200 / 255, green: 200 / 255, blue: 200 / 255, alpha: 1))]),
	startPoint: .init(x: 0.5, y: 0.5),
	endPoint: .init(x: 1, y: 1)
)

enum OnboardingSteps: CaseIterable {
	case greeting
	case name
	case gender
	case date
	case disease
	case end
}

enum EmotionalStates: CaseIterable {
	case bad
	case worried
	case happy
	case calm
}

enum ControlStates: CaseIterable {
	case nextButtonForm
	case chooseAnswerForm
	case smallTypeInForm
	case bigTypeInFrom
	case emojiPickUpForm
	case nothing
}

struct Stage {
	let sentences: [String]
	let controlType: ControlStates
	var inputLabels: [textOption] = agreementOptions
	var inputLabel: String = controlLabels[1]
	let action: () -> Void
}

struct Session {
	let stages: [Stage]
}

enum SessionNames: String, CaseIterable {
	case forAgainstTechnique
	case factReassessmentTechnique
	case journalingTechnique
	case cognitiveRestructuringTechnique
	case exposureTechnique
	case playScriptTechnique
	case CBTcoreTechnique
	case challengeNegativeThoughtsTechnique
	case automaticThoughtsTechnique
	case defaultSession
	case emotionFeedback
	case admirationEmotion
	case happyEmotion
	case calmEmotion
	case sadEmotion
	case worryEmotion
	case angryEmotion
}

let sessionSymptoms = [
	"Drug or alcohol use": [SessionNames.cognitiveRestructuringTechnique, SessionNames.exposureTechnique, SessionNames.CBTcoreTechnique],
	"Social withdrawal or isolation": [SessionNames.playScriptTechnique, SessionNames.factReassessmentTechnique, SessionNames.journalingTechnique],
	"Excessive worrying or fear": [SessionNames.challengeNegativeThoughtsTechnique, SessionNames.automaticThoughtsTechnique, SessionNames.exposureTechnique],
	"Difficulty sleeping": [SessionNames.journalingTechnique, SessionNames.cognitiveRestructuringTechnique, SessionNames.factReassessmentTechnique],
	"Low energy": [SessionNames.CBTcoreTechnique, SessionNames.challengeNegativeThoughtsTechnique, SessionNames.journalingTechnique],
	"Depression or feelings of sadness": [SessionNames.challengeNegativeThoughtsTechnique, SessionNames.cognitiveRestructuringTechnique, SessionNames.CBTcoreTechnique],
	"Inability to interpret people’s emotions": [SessionNames.playScriptTechnique, SessionNames.exposureTechnique, SessionNames.factReassessmentTechnique],
	"Intense irritability or anger": [SessionNames.challengeNegativeThoughtsTechnique, SessionNames.automaticThoughtsTechnique, SessionNames.cognitiveRestructuringTechnique],
	"Obsession with my physical appearance": [SessionNames.cognitiveRestructuringTechnique, SessionNames.challengeNegativeThoughtsTechnique, SessionNames.factReassessmentTechnique],
	"Problems concentrating and learning": [SessionNames.CBTcoreTechnique, SessionNames.challengeNegativeThoughtsTechnique, SessionNames.cognitiveRestructuringTechnique],
	"Sudden mood changes": [SessionNames.playScriptTechnique, SessionNames.exposureTechnique, SessionNames.challengeNegativeThoughtsTechnique],
	"Loss of interest": [SessionNames.cognitiveRestructuringTechnique, SessionNames.CBTcoreTechnique, SessionNames.factReassessmentTechnique],
	"Major changes in eating habits": [SessionNames.cognitiveRestructuringTechnique, SessionNames.journalingTechnique, SessionNames.factReassessmentTechnique],
	"Inability to cope with daily stress": [SessionNames.CBTcoreTechnique, SessionNames.cognitiveRestructuringTechnique, SessionNames.challengeNegativeThoughtsTechnique]
] as [String : [SessionNames]]

let UbiquitousKeys = [
	"Is launching app first time",
	"User's name",
	"User's gender",
	"User's date of birth",
	"User's diseases",
	"User's wake up time",
	"User's time to go to bed",
	"First subscription offer date",
	"Subscription sheet showed second time"
]

let EmotionsUbiquitousKeys = [
	"Admiration",
	"Happiness",
	"Calmness",
	"Sadness",
	"Worryness",
	"Anger"
]

let ProductIdentifiers = [
	"month.subscription",
	"year.subscription",
	"month.subscription.trial",
	"year.subscription.trial",
]

let stateOptions = [
	"admiration_filled",
	"happiness_filled",
	"calmness_filled",
	"sadness_filled",
	"worryness_filled",
	"anger_filled"
]

var userDiseaseBools = [
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false,
	false
]

class BoolStates: ObservableObject {
	@Published var AudioBoolList = [Bool]()
	@Published var AudioIsPlayingList = [Bool]()
}
