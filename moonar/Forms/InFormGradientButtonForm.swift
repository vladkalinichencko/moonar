//
//  InFormGradientButtonForm.swift
//  moonar
//
//  Created by Владислав Калиниченко on 14.08.2022.
//

import SwiftUI

struct InFormGradientButtonForm: View {
	var color: LinearGradient
	var textColor: Color
	var text: String
	var action: () -> Void
	
	var body: some View {
		Button(action: action) {
			HStack {
				Spacer()
				Text(text)
					.font(.title)
					.fontWeight(.bold)
				
				Spacer()
			}
			.padding(25)
			.background(color)
		}
		.padding()
		.foregroundColor(textColor)
		.buttonStyle(OnTapButtonState(newTextColor: textColor))
		.shadow(color: Color.black, radius: 50, x: 0, y: 0)
		.shadow(color: Color.black, radius: 50, x: 0, y: 0)
		.shadow(color: Color.black, radius: 50, x: 0, y: 0)
		.shadow(color: Color.black, radius: 50, x: 0, y: 150)
		.shadow(color: Color.black, radius: 50, x: 0, y: 150)
		.shadow(color: Color.black, radius: 50, x: 0, y: 150)
	}
}
