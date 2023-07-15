//
//  MoonarScreen.swift
//  moonar
//
//  Created by Владислав Калиниченко on 09.04.2022.
//

import SwiftUI
import NaturalLanguage

struct MoonarScreen: View {
	@State private var sessionName: SessionNames = .defaultSession
	@State private var recommendedSession: SessionNames? = .defaultSession
	@State private var stageIndex = 0
	@State private var emotionalState = EmotionalStates.calm
	@State private var isShowingTextBlocks = true
	@State private var isShowingSubscriptionFinalOfferSheet = false
	@State private var isShowingSubscriptionWithTrialOfferSheet = false
	
	@State private var userTextInput = ""
	@State private var userAudioToTextInput = ""
	@State private var userEmotions = [false, false, false, false, false, false]
	@State private var userAudioThoughtName = ""
	@State private var selectedOption = ""
	@State private var selectedQuote = piecesOfAdvice.first
	
	@EnvironmentObject var moonarActions: MoonarViewModel
	@EnvironmentObject var audioController: AudioViewModel
	@EnvironmentObject var storeController: Subscription

	@Binding var emotionColor: Color
	@Binding var emotionTextColor: Color
	
	func processBigTypeInFormInformation() {
		if userTextInput == "" {
			moonarActions.addAudioThought(name: userAudioThoughtName)
		}
		else {
			moonarActions.addTextThought(text: userTextInput, session: sessionName.rawValue, stage: stageIndex)
			
			withAnimation(.spring().speed(0.5)) {
				emotionalState = moonarActions.emotionClassification(text: userTextInput)
			}
		}
		
		userAudioThoughtName = ""
		userTextInput = ""
		
		let temporarySessionName = sessionName
		let temporaryStageIndex = stageIndex
		let numericScore = moonarActions.emotionScore
		
		withAnimation(.spring().speed(0.5)) {
			stageIndex = 0
		
			if numericScore <= -0.9 {
				sessionName = .angryEmotion
			}
			else if numericScore <= -0.5 {
				sessionName = .worryEmotion
			}
			else if numericScore <= -0.2 {
				sessionName = .sadEmotion
			}
			else if numericScore <= 0.3 {
				sessionName = .calmEmotion
			}
			else if numericScore <= 0.8 {
				sessionName = .happyEmotion
			}
			else {
				sessionName = .admirationEmotion
			}
		}
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
			withAnimation(.spring().speed(0.5)) {
				sessionName = temporarySessionName
				stageIndex = temporaryStageIndex
			}
		}
	}
	
	func desideSession() {
		var sentence = ""
		if userTextInput == "" {
			sentence = audioController.transcribedText
		}
		else {
			sentence = userTextInput
		}
		
		print("SENTENCE")
		print(sentence)
		
		if let sentenceEmbedding = NLEmbedding.sentenceEmbedding(for: .english) {
			var minDistance = 3.0
			
			for symptomDescription in symptomOptions {
				let distance = sentenceEmbedding.distance(between: sentence, and: symptomDescription)
				
				minDistance = min(minDistance, Double(distance))
				print("EMBEDDING", symptomDescription, distance)
			}
			
			for symptomDescription in symptomOptions {
				if minDistance == Double(sentenceEmbedding.distance(between: sentence, and: symptomDescription)) {
					
					recommendedSession = sessionSymptoms[symptomDescription]?.randomElement()
					
					print("THERAPY")
					print(recommendedSession ?? "nothing")
				}
			}
			
			print("SESSION AFTER:", recommendedSession ?? "")
			sessionName = recommendedSession!
		}
	}
	
	func processEmojiPickUpForm() {
		var newEmotionValue: Double
		
		let temporarySessionName = sessionName
		let temporaryStageIndex = stageIndex
		
		for i in 0..<6 {
			if userEmotions[i] {
				newEmotionValue = NSUbiquitousKeyValueStore.default.double(forKey: EmotionsUbiquitousKeys[i]) + 1
				
				NSUbiquitousKeyValueStore.default.set(newEmotionValue, forKey: EmotionsUbiquitousKeys[i])
				
				withAnimation(.spring().speed(0.5)) {
					stageIndex = 0
					
					switch EmotionsUbiquitousKeys[i] {
						case "Happiness":
							emotionalState = .happy
							sessionName = .happyEmotion
						case "Admiration":
							emotionalState = .happy
							sessionName = .admirationEmotion
						case "Calmness":
							emotionalState = .calm
							sessionName = .calmEmotion
						case "Sadness":
							emotionalState = .calm
							sessionName = .sadEmotion
						case "Worryness":
							emotionalState = .worried
							sessionName = .worryEmotion
						case "Anger":
							emotionalState = .bad
							sessionName = .angryEmotion
						default: break
					}
				}
			}
		}
		NSUbiquitousKeyValueStore.default.synchronize()
		
		userEmotions = [false, false, false, false, false, false]
		
		userAudioThoughtName = ""
		userTextInput = ""
		
		DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
			withAnimation(.spring().speed(0.5)) {
				sessionName = temporarySessionName
				stageIndex = temporaryStageIndex
			}
		}
	}
	
	func getSessions() -> [SessionNames : Session] {
		let sessions: [SessionNames: Session] = [
			.forAgainstTechnique: Session(
				stages: [
					Stage(
						sentences:
							[
								"Describe a bright emotion and situation that caused it.",
								"Estimate the strength of your emotion."
							],
						controlType: .bigTypeInFrom,
						action: {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
							
							processBigTypeInFormInformation()
						}
					),
					Stage(
						sentences:
							[
								"Well, now tell me why this happened."
							],
						controlType: .bigTypeInFrom,
						action: {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
							
							processBigTypeInFormInformation()
						}
					),
					Stage(
						sentences:
							[
								"Assess the situation from the outside.",
								"What are the proofs of the truthfulness of your thoughts, what are the advantages and benefits for you in this type of thinking?"
							],
						controlType: .bigTypeInFrom,
						action: {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
							
							moonarActions.addTask(task: .backToPast)
							processBigTypeInFormInformation()
						}
					),
					Stage(
						sentences:
							[
								"Tell me possible refutations of your thoughts.",
								"What can say the opposite and makes you doubt?"
							],
						controlType: .bigTypeInFrom,
						action: {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
							
							processBigTypeInFormInformation()
						}
					),
					Stage(
						sentences:
							[
								"What does this situation look like now, what has changed in your attitude towards it?"
							],
						controlType: .bigTypeInFrom,
						action: {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
							
							moonarActions.addTask(task: .lookFromOtherSides)
							processBigTypeInFormInformation()
						}
					)
				]
			),
			.factReassessmentTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"Tell me about your problem.",
							"You can use either typing or speaking."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"If you can't resolve this issue, you should try different approaches.",
							"Experiment with different ones to rebuild your attitude to the situation,",
							"for instance, think of what you should do the other way around."
						],
					controlType: .chooseAnswerForm,
					inputLabels: tryOptions,
					action: {
						if selectedOption == "OK, I'll try" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 2
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
						
						selectedOption = ""
					}
				),
				Stage(
					sentences:
						[
							"Well, I will give you an example:",
							"imagine you're tormented by insomnia, you can't sleep –",
							"try not to try to fall asleep, but calmly continue to stay awake."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 2
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Alright, start recording!"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						moonarActions.addTask(task: .paradoxicalIntention)
						processBigTypeInFormInformation()
					}
				)
			]),
			.journalingTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"Tell me whatever you'd like!"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
						moonarActions.addTask(task: .doJournaling)
					}
				),
				Stage(
					sentences:
						[
							"Do you want to continue with a therapy?"
						],
					controlType: .chooseAnswerForm,
					inputLabels: agreementOptions,
					action: {
						if selectedOption == "Yes" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex = 0
								
//								sessionName = .automaticThoughtsTechnique
								desideSession()
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex = 0
								
								sessionName = .emotionFeedback
							}
						}
					}
				)
			]),
			.cognitiveRestructuringTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"Do you know what cognitive distortions are?"
						],
					controlType: .chooseAnswerForm,
					inputLabels: agreementToTellOptions,
					action: {
						if selectedOption == "No, tell me" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 2
							}
						}
					}
				),
				Stage(
					sentences:
						[
							"OK, it's quite simple:",
							"Cognitive distortions are biased perspectives we take on ourselves and the world around us.",
							"They are irrational thoughts and beliefs that we unknowingly reinforce over time.",
							"For example, perfectionists usually believe that they must always be right.",
							"Which is obviously not true, even thought these people might be very accurate."
						],
					controlType: .nextButtonForm,
					inputLabel: controlLabels[6],
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += [1, 2, 12, 13].randomElement()!
						}
					}
				),
				
				Stage(
					sentences:
						[
							"What thoughts led you to this feeling?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 16
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"What is the evidence for this thought and against it?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Are you basing this thought on facts, or on feelings?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
						moonarActions.addTask(task: .researchSupportingFacts)
					}
				),
				Stage(
					sentences:
						[
							"Is this thought black and white, when reality is more complicated?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Could you be misinterpreting the evidence?",
							"Are you making any assumptions?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Might other people have different interpretations of this same situation?",
							"What are these interpretations?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Are you looking at all the evidence, or just what supports your thought?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Could your thought be an exaggeration of what's true?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Are you having this thought out of habit, or do the facts support it?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Did someone pass this thought/belief to you?",
							"If so, are they a reliable source?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Is your thought a likely scenario, or is it the worst case scenario?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 16
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"What’s the worst that could happen in this situation?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 16
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"Tell arguments supporting this thought."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Tell arguments against this thought."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Now compare your arguments and chose the ones that sound more convincing."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"Now record your thought once again, tell yourself about situation, thoughts, feelings and consequences."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
					}
				),
			]),
			.exposureTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"I'll give you a task to draw a fear."
						],
					controlType: .nextButtonForm,
					inputLabel: controlLabels[6],
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						moonarActions.addTask(task: .drawFear)
					}
				)
			]),
			.playScriptTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"Are you afraid of some situation?"
						],
					controlType: .chooseAnswerForm,
					inputLabels: agreementOptions,
					action: {
						if selectedOption == "Yes" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex = 0
								
								while sessionName == .defaultSession ||
										sessionName == .journalingTechnique ||
										sessionName == .automaticThoughtsTechnique ||
										sessionName == .playScriptTechnique ||
										sessionName == .exposureTechnique ||
										sessionName == .emotionFeedback ||
										sessionName == .admirationEmotion ||
										sessionName == .happyEmotion ||
										sessionName == .calmEmotion ||
										sessionName == .sadEmotion ||
										sessionName == .worryEmotion ||
										sessionName == .angryEmotion {
//									sessionName = SessionNames.allCases.randomElement()!
									desideSession()
								}
							}
						}
					}
				),
				Stage(
					sentences:
						[
							"Visualize or imagine the situation and play it out in your head from start to end."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Did you become less afraid?"
						],
					controlType: .chooseAnswerForm,
					inputLabels: agreementOptions,
					action: {
						if selectedOption == "Yes" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex = 0
								
								sessionName = .emotionFeedback
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex = 0
								
//								sessionName = .exposureTechnique
								desideSession()
							}
						}
					}
				),
			]),
			.CBTcoreTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"First of all identify your thoughts."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Now try to discover how your thoughts are affecting your emotions and behavior."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Now act as a critic for yourself and",
							"find if your thoughts are precise or not.",
							"Think about how your thoughts based on facts rather than feelings."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
						moonarActions.addTask(task: .researchSupportingFacts)
					}
				),
				Stage(
					sentences:
						[
							"For the last stage",
							"replace your biased thoughts with practical ones."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
					}
				),
			]),
			.challengeNegativeThoughtsTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"Is there any substantial evidence for your thought?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Is there any evidence contrary to your thought?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Are you attempting to interpret this situation without all the evidence?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"What would your, for example, friend think about this situation?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"If you look at the situation positively, how is it different?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Will this matter a year from now?",
							"How about five years from now?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
					}
				),
			]),
			.automaticThoughtsTechnique: Session(stages: [
				Stage(
					sentences:
						[
							"Are you aware of your thoughts that lead to the problem?"
						],
					controlType: .chooseAnswerForm,
					inputLabels: tolerantAgreementOptions,
					action: {
						if selectedOption == "Yes" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex = 0
								
//								sessionName = .playScriptTechnique
								desideSession()
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
					}
				),
				Stage(
					sentences:
						[
							"Please, describe only the situation."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += [1, 3].randomElement()!
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"What could be your reaction to this situation?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Now try to overview your unconscious thoughts that lead to this reaction.",
							"Think about it and give yourself an honest answer."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += [3, 4, 8, 10].randomElement()!
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"Do you know what is ABC model?",
							"A is our activating event – situation or memory that makes us feel something.",
							"B is our belief – goal, physiological predisposition, attitude, view etc.",
							"C is consequence – our emotions and behaviour after experiencing A combined with B.",
							"You have to pay attention to B – make your beliefs rational."
						],
					controlType: .nextButtonForm,
					inputLabel: controlLabels[4],
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
					}
				),
				Stage(
					sentences:
						[
							"Now just tell me about your beliefs and thoughts on this situation."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += [1, 2, 6, 8].randomElement()!
						}
						
						moonarActions.addTask(task: .autoSuggestion)
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"Play the situation in your head til the end.",
							"What’s the worst that could happen?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"Try to reformulate the problem so that it is controlled."
						],
					controlType: .chooseAnswerForm,
					inputLabels: tryOptions,
					action: {
						if selectedOption == "OK, I'll try" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 2
							}
						}
					}
				),
				Stage(
					sentences:
						[
							"Go on!"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
					}
				),
				Stage(
					sentences:
						[
							"Well, I'll give you an example:",
							"instead of thinking «I'm lonely and nobody wants to speak with me»",
							"think «I need to start talking to people more often».",
							"This way you will know what to do."
						],
					controlType: .nextButtonForm,
					inputLabel: controlLabels[4],
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex += 1
						}
					}
				),
				Stage(
					sentences:
						[
							"Now try to reformulate problem this way."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
					}
				),
				
				Stage(
					sentences:
						[
							"Are you the center of the problem?"
						],
					controlType: .chooseAnswerForm,
					inputLabels: agreementOptions,
					action: {
						if selectedOption == "Yes" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
						else {
							stageIndex += [-4, -5, 2].randomElement()!
						}
					}
				),
				Stage(
					sentences:
						[
							"Maybe the point of concentration of this event is not in you?",
							"Please, reflect on that."
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
						moonarActions.addTask(task: .peopleDontCare)
					}
				),
				
				Stage(
					sentences:
						[
							"Do you think some single factor could affect this situation?"
						],
					controlType: .chooseAnswerForm,
					inputLabels: agreementOptions,
					action: {
						if selectedOption == "Yes" {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
						else {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += [-6, -7, -2].randomElement()!
							}
						}
					}
				),
				Stage(
					sentences:
						[
							"I suppose your misfortunes are not based on this single factor.",
							"What can you say about it?"
						],
					controlType: .bigTypeInFrom,
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .emotionFeedback
						}
						
						processBigTypeInFormInformation()
					}
				),
			]),
			.admirationEmotion: Session(stages: [
				Stage(
					sentences:
						[
							"Alright!",
							"I see you got the point!"
						],
					controlType: .nothing,
					action: {}
				)
			]),
			.happyEmotion: Session(stages: [
				Stage(
					sentences:
						[
							"Wow, I'm happy that you are happy)",
						],
					controlType: .nothing,
					action: {}
				)
			]),
			.calmEmotion: Session(stages: [
				Stage(
					sentences:
						[
							"It's good that this does not really affect your mood.",
						],
					controlType: .nothing,
					action: {}
				)
			]),
			.sadEmotion: Session(stages: [
				Stage(
					sentences:
						[
							"I got that this is quite sad",
							"but I'll try to help you)"
						],
					controlType: .nothing,
					action: {}
				)
			]),
			.worryEmotion: Session(stages: [
				Stage(
					sentences:
						[
							"I see you are worried,",
							"together we will overcome this!"
						],
					controlType: .nothing,
					action: {}
				)
			]),
			.angryEmotion: Session(stages: [
				Stage(
					sentences:
						[
							"Oh, I see this is bad.",
							"I found a great quote for you to cheer you up:",
							"«\(selectedQuote ?? "")»"
						],
					controlType: .nothing,
					action: {
						selectedQuote = piecesOfAdvice.randomElement() ?? piecesOfAdvice.first
						
						moonarActions.addAdvice(advice: selectedQuote!)
					}
				)
			]),
			.emotionFeedback: Session(stages: [
				Stage(
					sentences:
						[
							"How do you feel right now?",
						],
					controlType: .emojiPickUpForm,
					inputLabel: controlLabels[5],
					action: {
						withAnimation(.spring().speed(0.5)) {
							stageIndex = 0
							
							sessionName = .defaultSession
						}
						
						processEmojiPickUpForm()
					}
				)
			]),
			.defaultSession: Session(
				stages: [
					Stage(
						sentences:
							[
								"You can tell me everything that bothers you.",
								"I'm ready to hear you 24/7!"
							],
						controlType: .nextButtonForm,
						inputLabel: controlLabels[3],
						action: {
							withAnimation(.spring().speed(0.5)) {
								stageIndex += 1
							}
						}
					),
					Stage(
						sentences:
							[
								"Do you want to talk about specific problem you have",
								"or just record some thoughts?"
							],
						controlType: .chooseAnswerForm,
						inputLabels: startOptions,
						action: {
							if selectedOption == "Tell about problem" {
								withAnimation(.spring().speed(0.5)) {
									stageIndex += 1
								}
							}
							else {
								withAnimation(.spring().speed(0.5)) {
									stageIndex = 0
									sessionName = .journalingTechnique
								}
							}
						}
					),
					Stage(
						sentences:
							[
								"Tell me whatever you'd like!"
							],
						controlType: .bigTypeInFrom,
						action: {
							withAnimation(.spring().speed(0.5)) {
								stageIndex = 0
								desideSession()
							}
							
							processBigTypeInFormInformation()
							moonarActions.addTask(task: .doJournaling)
						}
					)
				]
			)
		]
		
		return sessions
	}

    var body: some View {
		GeometryReader { geo in
			ZStack {
				Background(color: Color.black)
				
				switch emotionalState {
					case .happy:
						HappyState(baseSize: geo.size.width)
					case .calm:
						CalmState(baseSize: geo.size.width)
					case .worried:
						WorriedState(baseSize: geo.size.width)
					case .bad:
						BadState(baseSize: geo.size.width)
				}
				
				ScrollView(showsIndicators: false) {
					VStack {
						Color(.clear)
							.frame(height: 50)
						if isShowingTextBlocks {
							ForEach(0..<getSessions()[sessionName]!.stages[stageIndex].sentences.count, id: \.self) { index in
								TextBlock(textMessage: getSessions()[sessionName]!.stages[stageIndex].sentences[index], animationDelay: Double(index))
							}
							.onChange(of: stageIndex, perform: { (_) -> Void in
								isShowingTextBlocks = false
							})
							.onChange(of: sessionName, perform: { (_) -> Void in
								isShowingTextBlocks = false
							})
						}
						else {
							Color(.clear)
								.frame(height: 100)
								.onAppear {
									isShowingTextBlocks = true
								}
						}
						Color(.clear)
							.frame(height: 300)
					}
				}
				.zIndex(2)
				
				switch getSessions()[sessionName]!.stages[stageIndex].controlType {
					case .nextButtonForm:
						NextButtonForm(
							color: $emotionColor,
							textColor: $emotionTextColor,
							text: getSessions()[sessionName]!.stages[stageIndex].inputLabel,
							action: getSessions()[sessionName]!.stages[stageIndex].action
						)
					case .chooseAnswerForm:
						ChooseAnswerForm(
							selectedOption: $selectedOption,
							color: $emotionColor,
							textColor: $emotionTextColor,
							textOptions: getSessions()[sessionName]!.stages[stageIndex].inputLabels,
							action: getSessions()[sessionName]!.stages[stageIndex].action
						)
					case .smallTypeInForm:
						TypeInForm(
							text: $userTextInput,
							color: $emotionColor,
							textColor: $emotionTextColor,
							action: getSessions()[sessionName]!.stages[stageIndex].action
						)
					case .bigTypeInFrom:
						BigTypeInForm(
							text: $userTextInput,
							audioName: $userAudioThoughtName,
							color: $emotionColor,
							textColor: $emotionTextColor,
							session: $sessionName,
							stage: $stageIndex,
							action: getSessions()[sessionName]!.stages[stageIndex].action
						)
					case .emojiPickUpForm:
						EmojiPickUpForm(
							color: $emotionColor,
							textColor: $emotionTextColor,
							itemsSelected: $userEmotions,
							emojiOptions: stateOptions,
							action: getSessions()[sessionName]!.stages[stageIndex].action
						)
					case .nothing:
						Nothing(action: getSessions()[sessionName]!.stages[stageIndex].action)
				}
			}
			.onAppear() {
				moonarActions.removeRequests()
				
				moonarActions.scheduleNotification(title: "Good morning!", text: "How do you feel?", date: (NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[5]) as? NSDate ?? Calendar.current.date(from: DateComponents(hour: 9, minute: 0))! as NSDate))
				
				moonarActions.scheduleNotification(title: "Before you fall asleep...", text: "Tell me about your day", date: (NSUbiquitousKeyValueStore.default.object(forKey: UbiquitousKeys[6]) as? NSDate ?? Calendar.current.date(from: DateComponents(hour: 20, minute: 0))! as NSDate))
				
				DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
					if !NSUbiquitousKeyValueStore.default.bool(forKey: UbiquitousKeys[8]) {
						if !storeController.isUserSubscribed {
							if storeController.trialDaysRemained() == 3 {
								isShowingSubscriptionFinalOfferSheet = true
								
								NSUbiquitousKeyValueStore.default.set(true, forKey: UbiquitousKeys[8])
								NSUbiquitousKeyValueStore.default.synchronize()
							}
						}
					}
					
					if storeController.trialDaysRemained() <= 0 && !storeController.isUserSubscribed {
						isShowingSubscriptionFinalOfferSheet = true
					}
				}
			}
			.onChange(of: emotionalState, perform: { (_) -> Void in
				switch emotionalState {
					case .happy:
						emotionColor = greenColor
						emotionTextColor = Color.white
					case .calm:
						emotionColor = blueColor
						emotionTextColor = Color.white
					case .worried:
						emotionColor = yellowColor
						emotionTextColor = Color.black
					case .bad:
						emotionColor = redColor
						emotionTextColor = Color.black
				}
			})
			.onChange(of: audioController.transcribedText, perform: { (_) -> Void in
				
				print(audioController.transcribedText)
				
				withAnimation(.spring().speed(0.5)) {
					emotionalState = moonarActions.emotionClassification(text: audioController.transcribedText)
				}
			})
			.sheet(isPresented: $isShowingSubscriptionFinalOfferSheet, content: {
				AnyView(
					SubscriptionFinalOfferSheet(daysRemained: storeController.trialDaysRemained())
				)
			})
		}
    }
}

struct MoonarScreen_Previews: PreviewProvider {
    static var previews: some View {
		MoonarScreen(emotionColor: .constant(blueColor), emotionTextColor: .constant(Color.white))
    }
}
