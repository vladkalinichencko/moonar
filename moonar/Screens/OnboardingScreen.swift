//
//  ContentView.swift
//  moonar
//
//  Created by Владислав Калиниченко on 05.04.2022.
//

import SwiftUI

struct OnboardingScreen: View {
	@State private var userName: String = ""
	@State private var userGender: String = ""
	@State private var userDate: Date = Date()
	@State private var userDiseases: [Bool] = userDiseaseBools
	
	@State private var onboardingStep = OnboardingSteps.greeting
	@Binding var isLaunchingAppSecondTime: Bool

    var body: some View {
		GeometryReader { geo in
			ZStack {
				Background(color: Color.black)

				ScrollView(showsIndicators: false) {
					VStack {
						Color(.clear)
							.frame(height: 50)
						switch onboardingStep {
							case .greeting:
								VStack {
									TextBlock(textMessage: moonarPhrases[0], animationDelay: 0)
									TextBlock(textMessage: moonarPhrases[1], animationDelay: 1)
									TextBlock(textMessage: moonarPhrases[2], animationDelay: 2)
								}
							case .name:
								VStack {
									TextBlock(textMessage: moonarPhrases[3], animationDelay: 0)
								}
							case .gender:
								VStack {
									TextBlock(textMessage: moonarPhrases[4], animationDelay: 0)
								}
							case .date:
								VStack {
									TextBlock(textMessage: moonarPhrases[5], animationDelay: 0)
								}
							case .disease:
								VStack {
									TextBlock(textMessage: moonarPhrases[6], animationDelay: 0)
									TextBlock(textMessage: moonarPhrases[7], animationDelay: 1)
								}
							case .end:
								VStack {
									TextBlock(textMessage: moonarPhrases[8], animationDelay: 0)
									TextBlock(textMessage: moonarPhrases[9], animationDelay: 1)
								}
						}
						Color(.clear)
							.frame(height: 300)
					}
				}

				switch onboardingStep {
					case .greeting:
						NextButtonForm(
							color: .constant(Color.white),
							textColor: .constant(Color.black),
							text: controlLabels[0],
							action: { () -> Void in
								withAnimation(.spring().speed(0.5)) {
									onboardingStep = .name
								}
							}
						)
					case .name:
						TypeInForm(
							text: $userName,
							color: .constant(Color.white),
							textColor: .constant(Color.black),
							action: { () -> Void in
								NSUbiquitousKeyValueStore.default.set(userName, forKey: UbiquitousKeys[1])
								NSUbiquitousKeyValueStore.default.synchronize()
								
								withAnimation(.spring().speed(0.5)) {
									onboardingStep = .gender
								}
							}
						)
					case .gender:
						ChooseAnswerForm(
							selectedOption: $userGender,
							color: .constant(Color.white),
							textColor: .constant(Color.black),
							textOptions: genderOptions,
							action: { () -> Void in
								NSUbiquitousKeyValueStore.default.set(userGender, forKey: UbiquitousKeys[2])
								NSUbiquitousKeyValueStore.default.synchronize()
								
								withAnimation(.spring().speed(0.5)) {
									onboardingStep = .date
								}
							}
						)
					case .date:
						DatePickerForm(
							birthDate: $userDate,
							color: .constant(Color.white),
							textColor: .constant(Color.black),
							action: { () -> Void in
								NSUbiquitousKeyValueStore.default.set(userDate, forKey: UbiquitousKeys[3])
								NSUbiquitousKeyValueStore.default.synchronize()
								
								withAnimation(.spring().speed(0.5)) {
									onboardingStep = .disease
								}
							}
						)
					case .disease:
						ChooseAnswerFormWithSheet(
							color: .constant(Color.white),
							textColor: .constant(Color.black),
							textOptions: isHavingSymptomsOptions,
							sheetView:
								AnyView(
									PickUpFormSheet(
										pickUpList: symptomOptions,
										sheetPickedUpValues: $userDiseases,
										color: .constant(Color.white),
										textColor: .constant(Color.black),
										action: { () -> Void in
											NSUbiquitousKeyValueStore.default.set(userDiseases, forKey: UbiquitousKeys[4])
											NSUbiquitousKeyValueStore.default.synchronize()
											
											withAnimation(.spring().speed(0.5)) {
												onboardingStep = .end
											}
										}
									)
								),
							exitAction: { () -> Void in
								withAnimation(.spring().speed(0.5)) {
									onboardingStep = .end
								}
							}
						)
					case .end:
						NextButtonFormWithSheet(
							color: .constant(Color.white),
							textColor: .constant(Color.black),
							sheetView: AnyView(
								SubscriptionWithTrialOfferSheet(
									mainAction: { () -> Void in
										isLaunchingAppSecondTime = true
										
										NSUbiquitousKeyValueStore.default.set(isLaunchingAppSecondTime, forKey: UbiquitousKeys[0])
										
										NSUbiquitousKeyValueStore.default.set(Date(), forKey: UbiquitousKeys[7])
										NSUbiquitousKeyValueStore.default.set(false, forKey: UbiquitousKeys[8])
										
										NSUbiquitousKeyValueStore.default.set(
											Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!,
											forKey: UbiquitousKeys[5]
										)
										NSUbiquitousKeyValueStore.default.set(
											Calendar.current.date(from: DateComponents(hour: 20, minute: 0))!,
											forKey: UbiquitousKeys[6]
										)
										
										NSUbiquitousKeyValueStore.default.synchronize()
									},
									action: { () -> Void in
										isLaunchingAppSecondTime = true
										
										NSUbiquitousKeyValueStore.default.set(isLaunchingAppSecondTime, forKey: UbiquitousKeys[0])
										
										NSUbiquitousKeyValueStore.default.set(Date(), forKey: UbiquitousKeys[7])
										NSUbiquitousKeyValueStore.default.set(false, forKey: UbiquitousKeys[8])
										
										NSUbiquitousKeyValueStore.default.set(
											Calendar.current.date(from: DateComponents(hour: 9, minute: 0))!,
											forKey: UbiquitousKeys[5]
										)
										NSUbiquitousKeyValueStore.default.set(
											Calendar.current.date(from: DateComponents(hour: 20, minute: 0))!,
											forKey: UbiquitousKeys[6]
										)
										
										NSUbiquitousKeyValueStore.default.synchronize()
									}
								)
							),
							text: controlLabels[0]
						)
				}
			}
		}
    }
}
