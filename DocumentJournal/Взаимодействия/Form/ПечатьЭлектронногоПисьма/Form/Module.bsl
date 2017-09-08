﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("Письмо") Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Письмо = Параметры.Письмо;
	
	Если ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоВходящее") Тогда
		
		ТекстHTML = Взаимодействия.СформироватьТекстHTMLДляВходящегоПисьма(Письмо);
		
	ИначеЕсли ТипЗнч(Письмо) = Тип("ДокументСсылка.ЭлектронноеПисьмоИсходящее") Тогда
		
		ТекстHTML = Взаимодействия.СформироватьТекстHTMLДляИсходящегоПисьма(Письмо);
		
	Иначе
		
		Отказ = Истина;
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТекстHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка)
	
	ВзаимодействияКлиент.ПолеHTMLПриНажатии(Элемент, ДанныеСобытия, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТекстHTMLДокументСформирован(Элемент)
	
	Если Не ФормаДиалогаПечатиПриОткрытииОткрывалась Тогда
		Элементы.ТекстHTML.Документ.execCommand("Print");
		ФормаДиалогаПечатиПриОткрытииОткрывалась = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
