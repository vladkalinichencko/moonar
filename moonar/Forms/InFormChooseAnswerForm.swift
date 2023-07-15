//
//  InFormChooseAnswerForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 14.08.2022.
//

import SwiftUI

struct InFormChooseAnswerForm: View {
	@Binding var selectedOption: String
	var color: LinearGradient
	var textColor: Color
	var textOptions: [textOption]
	var mainAction: () -> Void
	var action: () -> Void
	
	var body: some View {
		VStack(spacing: 0) {
			ForEach(textOptions) { option in
				if(option.isMain) {
					Button(action: {
						selectedOption = option.text
						mainAction()
					}) {
						HStack {
							Spacer()
							Text(option.text)
								.font(.title)
								.fontWeight(.bold)
							Spacer()
						}
						.padding(25)
						.background(color)
					}
					.foregroundColor(textColor)
					.cornerRadius(15)
					.padding([.horizontal, .bottom])
					.buttonStyle(OnTapButtonState(newTextColor: textColor))
				}
				else {
					Button(action: {
						selectedOption = option.text
						action()
					}) {
						HStack {
							Spacer()
							Text(option.text)
								.font(.title)
								.fontWeight(.bold)
							Spacer()
						}
						.padding(25)
						.background(Color.black)
						.overlay(
							RoundedRectangle(cornerRadius: 15)
								.stroke(color, lineWidth: 15)
						)
					}
					.foregroundColor(textColor)
					.cornerRadius(15)
					.padding([.horizontal, .bottom])
					.buttonStyle(OnTapButtonState(newTextColor: Color.white))
				}
			}
		}
		.shadow(color: Color.black, radius: 50, x: 0, y: 0)
		.shadow(color: Color.black, radius: 50, x: 0, y: 0)
		.shadow(color: Color.black, radius: 50, x: 0, y: 0)
		.shadow(color: Color.black, radius: 50, x: 0, y: 150)
		.shadow(color: Color.black, radius: 50, x: 0, y: 150)
		.shadow(color: Color.black, radius: 50, x: 0, y: 150)
	}
}

struct InFormChooseAnswerForm_Previews: PreviewProvider {
	static var previews: some View {
		InFormChooseAnswerForm(
			selectedOption: .constant("Male"),
			color: whiteGradient,
			textColor: Color.black,
			textOptions: subscribeOptions,
			mainAction: { () -> Void in },
			action: { () -> Void in }
		)
	}
}
