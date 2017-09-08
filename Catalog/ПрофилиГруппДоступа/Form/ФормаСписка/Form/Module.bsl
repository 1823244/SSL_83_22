﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		СтандартныеПодсистемыСервер.УстановитьКлючНазначенияФормы(ЭтотОбъект, "ВыборПодбор");
	КонецЕсли;
	
	Если Параметры.РежимВыбора Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
		
		// Скрытие профиля Администратор.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "Ссылка", Справочники.ПрофилиГруппДоступа.Администратор,
			ВидСравненияКомпоновкиДанных.НеРавно, , Истина);
		
		// Отбор не помеченных на удаление.
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список, "ПометкаУдаления", Ложь, , , Истина,
			РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Обычный);
		
		Элементы.Список.РежимВыбора = Истина;
		Элементы.Список.ВыборГруппИЭлементов = Параметры.ВыборГруппИЭлементов;
		
		АвтоЗаголовок = Ложь;
		Если Параметры.ЗакрыватьПриВыборе = Ложь Тогда
			// Режим подбора.
			Элементы.Список.МножественныйВыбор = Истина;
			Элементы.Список.РежимВыделения = РежимВыделенияТаблицы.Множественный;
			
			Заголовок = НСтр("ru = 'Подбор профилей групп доступа'");
		Иначе
			Заголовок = НСтр("ru = 'Выбор профиля групп доступа'");
		КонецЕсли;
	КонецЕсли;
	
	Если Параметры.Свойство("ПрофилиСРолямиПомеченнымиНаУдаление") Тогда
		ПоказатьПрофили = "Устаревшие";
	Иначе
		ПоказатьПрофили = "ВсеПрофили";
	КонецЕсли;
	
	Если Не Параметры.РежимВыбора Тогда
		УстановитьОтбор();
	Иначе
		Элементы.ПоказатьПрофили.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовУправленияФормы

&НаКлиенте
Процедура ПоказатьПрофилиПриИзменении(Элемент)
	УстановитьОтбор();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьОтбор()
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка.Роли.Роль.ПометкаУдаления",
		Истина,
		ВидСравненияКомпоновкиДанных.Равно,, Ложь);
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
		Список,
		"Ссылка.ИдентификаторПоставляемыхДанных",
		Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
		ВидСравненияКомпоновкиДанных.Равно,, Ложь);
	
	Если ПоказатьПрофили = "Устаревшие" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка.Роли.Роль.ПометкаУдаления",
			Истина,
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
		
	ИначеЕсли ПоказатьПрофили = "Поставляемые" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка.ИдентификаторПоставляемыхДанных",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКомпоновкиДанных.НеРавно,, Истина);
		
	ИначеЕсли ПоказатьПрофили = "Непоставляемые" Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(
			Список,
			"Ссылка.ИдентификаторПоставляемыхДанных",
			Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000"),
			ВидСравненияКомпоновкиДанных.Равно,, Истина);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти