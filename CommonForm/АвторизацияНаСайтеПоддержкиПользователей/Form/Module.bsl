﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Аутентификация = СтандартныеПодсистемыСервер.ПараметрыАутентификацииНаСайте();
	Если Аутентификация <> Неопределено Тогда
		Логин  = Аутентификация.Логин;
		Пароль = Аутентификация.Пароль;
	КонецЕсли;
	
	ЗапомнитьПароль = Не ПустаяСтрока(Пароль);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПерейтиКРегистрацииНаСайтеНажатие(Элемент)
	
	ПерейтиПоНавигационнойСсылке("http://users.v8.1c.ru/");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьДанныеАутентификацииИПродолжить()
	
	Если ПустаяСтрока(Логин) И Не ПустаяСтрока(Пароль) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Введите код пользователя для авторизации на сайте фирмы 1С.'"),, "Логин");
		Возврат;
	КонецЕсли;
		
	Если ПустаяСтрока(Логин) Тогда
		СохранитьДанныеАутентификации(Неопределено);
		Результат = КодВозвратаДиалога.Отмена;
	Иначе
		СохранитьДанныеАутентификации(Новый Структура("Логин,Пароль", Логин, ?(ЗапомнитьПароль, Пароль, "")));
		Результат = Новый Структура("Логин,Пароль", Логин, Пароль);
	КонецЕсли;
	
	Закрыть(Результат);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Процедура СохранитьДанныеАутентификации(Знач Аутентификация)
	
	СтандартныеПодсистемыСервер.СохранитьПараметрыАутентификацииНаСайте(Аутентификация);
	
КонецПроцедуры

#КонецОбласти
