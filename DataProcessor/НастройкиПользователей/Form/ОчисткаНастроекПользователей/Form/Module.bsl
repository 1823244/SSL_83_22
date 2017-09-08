﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ИспользоватьВнешнихПользователей = ПолучитьФункциональнуюОпцию("ИспользоватьВнешнихПользователей");
	ПользователиКоторымОчищаютсяНастройки = Новый Структура;
	
	ПереключательКомуОчищатьНастройки = "ВыбраннымПользователям";
	ПереключательОчищаемыеНастройки   = "ОчиститьВсе";
	ОчиститьИсториюВыбораНастроек     = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ВРег(ИмяСобытия) = ВРег("ВыборПользователя") Тогда
		
		Если ПользователиКоторымОчищаютсяНастройки <> Неопределено Тогда
			Элементы.ВыбратьНастройки.Заголовок = НСтр("ru='Выбрать'");
			ВыбранныеНастройки = Неопределено;
			КоличествоНастроек = Неопределено;
		КонецЕсли;
			
		ПользователиКоторымОчищаютсяНастройки = Новый Структура("МассивПользователей", Параметр.ПользователиПриемник);
		
		КоличествоПользователей = Параметр.ПользователиПриемник.Количество();
		Если КоличествоПользователей = 1 Тогда
			Элементы.ВыбратьПользователей.Заголовок = Строка(Параметр.ПользователиПриемник[0]);
			Элементы.ГруппаОчищаемыеНастройки.Доступность = Истина;
		ИначеЕсли КоличествоПользователей > 1 Тогда
			
			ПрописьЧисла = ЧислоПрописью(
				КоличествоПользователей,
				"Л = ru_RU",
				НСтр("ru = ',,,,,,,,0'"));
			ПрописьЧислаИПредмета = ЧислоПрописью(
				КоличествоПользователей,
				"Л = ru_RU",
				НСтр("ru = 'пользователь,пользователя,пользователей,,,,,,0'"));
			ЧислоИПредмет = СтрЗаменить(
				ПрописьЧислаИПредмета,
				ПрописьЧисла,
				Формат(КоличествоПользователей, "ЧДЦ=0") + " ");
				
			Элементы.ВыбратьПользователей.Заголовок = ЧислоИПредмет;
			ПереключательОчищаемыеНастройки = "ОчиститьВсе";
		КонецЕсли;
		Элементы.ВыбратьПользователей.Подсказка = "";
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("ВыборНастроек") Тогда
		ВыбранныеНастройки = Новый Структура;
		ВыбранныеНастройки.Вставить("НастройкиОтчетов", Параметр.НастройкиОтчетов);
		ВыбранныеНастройки.Вставить("ВнешнийВид", Параметр.ВнешнийВид);
		ВыбранныеНастройки.Вставить("ПрочиеНастройки", Параметр.ПрочиеНастройки);
		ВыбранныеНастройки.Вставить("ПерсональныеНастройки", Параметр.ПерсональныеНастройки);
		ВыбранныеНастройки.Вставить("ТаблицаВариантовОтчетов", Параметр.ТаблицаВариантовОтчетов);
		ВыбранныеНастройки.Вставить("ВыбранныеВариантыОтчетов", Параметр.ВыбранныеВариантыОтчетов);
		ВыбранныеНастройки.Вставить("ПрочиеПользовательскиеНастройки",
			Параметр.ПрочиеПользовательскиеНастройки);
			
		КоличествоНастроек = Параметр.КоличествоНастроек;
		
		Если КоличествоНастроек = 0 Тогда
			ТекстЗаголовка = НСтр("ru='Выбрать'");
		ИначеЕсли КоличествоНастроек = 1 Тогда
			ПредставлениеНастройки = Параметр.ПредставленияНастроек[0];
			ТекстЗаголовка = ПредставлениеНастройки;
		Иначе
			ПрописьЧисла = ЧислоПрописью(
				КоличествоНастроек,
				"Л = ru_RU",
				НСтр("ru = ',,,,,,,,0'"));
			ПрописьЧислаИПредмета = ЧислоПрописью(
				КоличествоНастроек,
				"Л = ru_RU",
				НСтр("ru = 'настройка,настройки,настроек,,,,,,0'"));
			ТекстЗаголовка = СтрЗаменить(
				ПрописьЧислаИПредмета,
				ПрописьЧисла,
				Формат(КоличествоНастроек, "ЧДЦ=0") + " ");
		КонецЕсли;
		
		Элементы.ВыбратьНастройки.Заголовок = ТекстЗаголовка;
		Элементы.ВыбратьНастройки.Подсказка = "";
		
	ИначеЕсли ВРег(ИмяСобытия) = ВРег("ВыборНастроек_ДанныеСохранены") Тогда
		ОчиститьИсториюВыбораНастроек = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПереключательКомуОчищатьНастройкиПриИзменении(Элемент)
	
	Если ПереключательОчищаемыеНастройки = "ВыбраннымПользователям"
		И КоличествоПользователей > 1
		Или ПереключательКомуОчищатьНастройки = "ВсемПользователям" Тогда
		ПереключательОчищаемыеНастройки = "ОчиститьВсе";
	КонецЕсли;
	
	Если ПереключательКомуОчищатьНастройки = "ВыбраннымПользователям"
		И КоличествоПользователей = 1
		Или ПереключательКомуОчищатьНастройки = "ВсемПользователям" Тогда
		Элементы.ГруппаОчищаемыеНастройки.Доступность = Истина;
	Иначе
		Элементы.ГруппаОчищаемыеНастройки.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереключательОчищаемыеНастройкиПриИзменении(Элемент)
	
	Если ПереключательКомуОчищатьНастройки = "ВыбраннымПользователям"
		И КоличествоПользователей > 1 
		Или ПереключательКомуОчищатьНастройки = "ВсемПользователям" Тогда
		ПереключательОчищаемыеНастройки = "ОчиститьВсе";
		Элементы.ВыбратьНастройки.Доступность = Ложь;
		ПоказатьПредупреждение(,НСтр("ru = 'Очистка отдельных настроек доступна только при выборе одного пользователя.'"));
	ИначеЕсли ПереключательОчищаемыеНастройки = "ОчиститьВсе" Тогда
		Элементы.ВыбратьНастройки.Доступность = Ложь;
	Иначе
		Элементы.ВыбратьНастройки.Доступность = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПользователейНажатие(Элемент)
	
	Если ИспользоватьВнешнихПользователей Тогда
		ВыборТипаПользователей = Новый СписокЗначений;
		ВыборТипаПользователей.Добавить("ВнешниеПользователи", НСтр("ru = 'Внешние пользователи'"));
		ВыборТипаПользователей.Добавить("Пользователи", НСтр("ru = 'Пользователи'"));
		
		Оповещение = Новый ОписаниеОповещения("ВыбратьПользователейНажатиеВыбратьЭлемент", ЭтотОбъект);
		ВыборТипаПользователей.ПоказатьВыборЭлемента(Оповещение);
		Возврат;
	Иначе
		ТипПользователя = Тип("СправочникСсылка.Пользователи");
	КонецЕсли;
	
	ОткрытьФормуВыбораПользователей(ТипПользователя);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьНастройки(Элемент)
	
	Если КоличествоПользователей = 1 Тогда
		ПользовательСсылка = ПользователиКоторымОчищаютсяНастройки.МассивПользователей[0];
		ПараметрыФормы = Новый Структура("Пользователь, ДействиеСНастройками, ОчиститьИсториюВыбораНастроек",
			ПользовательСсылка, "Очистка", ОчиститьИсториюВыбораНастроек);
		ОткрытьФорму("Обработка.НастройкиПользователей.Форма.ВыборНастроек", ПараметрыФормы);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Очистить(Команда)
	
	ОчиститьСообщения();
	ОчисткаНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьИЗакрыть(Команда)
	
	ОчиститьСообщения();
	НастройкиОчищены = ОчисткаНастроек();
	Если НастройкиОчищены Тогда
		ОбщегоНазначенияКлиент.ОбновитьИнтерфейсПрограммы();
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьПользователейНажатиеВыбратьЭлемент(ВыбранныйВариант, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйВариант = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если ВыбранныйВариант.Значение = "Пользователи" Тогда
		ТипПользователя = Тип("СправочникСсылка.Пользователи");
	ИначеЕсли ВыбранныйВариант.Значение = "ВнешниеПользователи" Тогда
		ТипПользователя = Тип("СправочникСсылка.ВнешниеПользователи");
	КонецЕсли;
	
	ОткрытьФормуВыбораПользователей(ТипПользователя);
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПользователей(ТипПользователя)
	
	ВыбранныеПользователи = Неопределено;
	ПользователиКоторымОчищаютсяНастройки.Свойство("МассивПользователей", ВыбранныеПользователи);
	
	ПараметрыФормы = Новый Структура("Пользователь, ТипПользователя, ТипДействия, ВыбранныеПользователи",
		"", ТипПользователя, "Очистка", ВыбранныеПользователи);
	ОткрытьФорму("Обработка.НастройкиПользователей.Форма.ВыборПользователей", ПараметрыФормы);
	
КонецПроцедуры

&НаКлиенте
Функция ОчисткаНастроек()
	
	Если ПереключательКомуОчищатьНастройки = "ВыбраннымПользователям"
		И КоличествоПользователей = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выберите пользователя или пользователей,
				|которым необходимо очистить настройки.'"), , "Источник");
		Возврат Ложь;
	КонецЕсли;
	
	Если ПереключательКомуОчищатьНастройки = "ВыбраннымПользователям" Тогда
			
		Если КоличествоПользователей = 1 Тогда
			ПояснениеУКогоОчищеныНастройки = НСтр("ru = 'пользователя ""%1""'");
			ПояснениеУКогоОчищеныНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ПояснениеУКогоОчищеныНастройки, ПользователиКоторымОчищаютсяНастройки.МассивПользователей[0]);
		Иначе
			ПояснениеУКогоОчищеныНастройки = НСтр("ru = '%1 пользователям'");
			ПояснениеУКогоОчищеныНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ПояснениеУКогоОчищеныНастройки, КоличествоПользователей);
		КонецЕсли;
		
	Иначе
		ПояснениеУКогоОчищеныНастройки = НСтр("ru = 'всем пользователям'");
	КонецЕсли;
	
	Если ПереключательОчищаемыеНастройки = "ОтдельныеНастройки"
		И КоличествоНастроек = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Выберите настройки, которые необходимо очистить.'"), , "ПереключательОчищаемыеНастройки");
		Возврат Ложь;
	КонецЕсли;
	
	Если ПереключательОчищаемыеНастройки = "ОтдельныеНастройки" Тогда
		ОчиститьВыбранныеНастройки();
		
		Если КоличествоНастроек = 1 Тогда
			
			Если СтрДлина(ПредставлениеНастройки) > 24 Тогда
				ПредставлениеНастройки = Лев(ПредставлениеНастройки, 24) + "...";
			КонецЕсли;
			
			ТекстПояснения = НСтр("ru = '""%1"" очищена у %2'");
			ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстПояснения, ПредставлениеНастройки, ПояснениеУКогоОчищеныНастройки);
			
		Иначе
			
			ПрописьЧисла = ЧислоПрописью(
				КоличествоНастроек,
				"Л = ru_RU",
				НСтр("ru = ',,,,,,,,0'"));
			ПрописьЧислаИПредмета = ЧислоПрописью(
				КоличествоНастроек,
				"Л = ru_RU",
				НСтр("ru = 'настройка,настройки,настроек,,,,,,0'"));
			ПрописьПредмета = СтрЗаменить(
				ПрописьЧислаИПредмета,
				ПрописьЧисла,
				Формат(КоличествоНастроек, "ЧДЦ=0") + " ");
			
			ТекстПояснения = НСтр("ru = 'Очищено %1 у %2'");
			ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				ТекстПояснения, ПрописьПредмета, ПояснениеУКогоОчищеныНастройки);
		КонецЕсли;
		
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Очистка настроек'"), , ТекстПояснения, БиблиотекаКартинок.Информация32);
	ИначеЕсли ПереключательОчищаемыеНастройки = "ОчиститьВсе" Тогда
		ОчиститьВсеНастройки();
		
		ТекстПояснения = НСтр("ru = 'Очищены все настройки %1'");
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстПояснения, ПояснениеУКогоОчищеныНастройки);
		ПоказатьОповещениеПользователя(
			НСтр("ru = 'Очистка настроек'"), , ТекстПояснения, БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	КоличествоНастроек = 0;
	Элементы.ВыбратьНастройки.Заголовок = НСтр("ru='Выбрать'");
	Возврат Истина;
	
КонецФункции

&НаСервере
Процедура ОчиститьВыбранныеНастройки()
	
	Источник = ПользователиКоторымОчищаютсяНастройки.МассивПользователей[0];
	Пользователь = Обработки.НастройкиПользователей.ИмяПользователяИБ(Источник);
	
	Если ВыбранныеНастройки.НастройкиОтчетов.Количество() > 0 Тогда
		Обработки.НастройкиПользователей.УдалитьВыбранныеНастройки(
			Пользователь, ВыбранныеНастройки.НастройкиОтчетов, "ХранилищеПользовательскихНастроекОтчетов");
		
		Обработки.НастройкиПользователей.УдалитьВариантыОтчетов(
			ВыбранныеНастройки.ВыбранныеВариантыОтчетов, ВыбранныеНастройки.ТаблицаВариантовОтчетов, Пользователь);
	КонецЕсли;
	
	Если ВыбранныеНастройки.ВнешнийВид.Количество() > 0 Тогда
		Обработки.НастройкиПользователей.УдалитьВыбранныеНастройки(
			Пользователь, ВыбранныеНастройки.ВнешнийВид, "ХранилищеСистемныхНастроек");
	КонецЕсли;
	
	Если ВыбранныеНастройки.ПрочиеНастройки.Количество() > 0 Тогда
		Обработки.НастройкиПользователей.УдалитьВыбранныеНастройки(
			Пользователь, ВыбранныеНастройки.ПрочиеНастройки, "ХранилищеСистемныхНастроек");
	КонецЕсли;
	
	Если ВыбранныеНастройки.ПерсональныеНастройки.Количество() > 0 Тогда
		Обработки.НастройкиПользователей.УдалитьВыбранныеНастройки(
			Пользователь, ВыбранныеНастройки.ПерсональныеНастройки, "ХранилищеОбщихНастроек");
	КонецЕсли;
	
	Если ВыбранныеНастройки.ПрочиеПользовательскиеНастройки.Количество() > 0 Тогда
		СведенияОПользователе = Новый Структура;
		СведенияОПользователе.Вставить("ПользовательСсылка", Источник);
		СведенияОПользователе.Вставить("ИмяПользователяИнформационнойБазы", Пользователь);
		ПользователиСлужебный.ПриУдаленииПрочихНастроек(
			СведенияОПользователе, ВыбранныеНастройки.ПрочиеПользовательскиеНастройки);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ОчиститьВсеНастройки()
	
	МассивНастроек = Новый Массив;
	МассивНастроек.Добавить("НастройкиОтчетов");
	МассивНастроек.Добавить("НастройкиВнешнегоВида");
	МассивНастроек.Добавить("ПерсональныеНастройки");
	МассивНастроек.Добавить("ДанныеФорм");
	МассивНастроек.Добавить("Избранное");
	МассивНастроек.Добавить("НастройкиПечати");
	МассивНастроек.Добавить("ПрочиеПользовательскиеНастройки");
	
	Если ПереключательКомуОчищатьНастройки = "ВыбраннымПользователям" Тогда
		Источники = ПользователиКоторымОчищаютсяНастройки.МассивПользователей;
	Иначе
		Источники = Новый Массив;
		ТаблицаПользователей = Новый ТаблицаЗначений;
		ТаблицаПользователей.Колонки.Добавить("Пользователь");
		// Получаем список всех пользователей.
		ТаблицаПользователей = Обработки.НастройкиПользователей.ПользователиДляКопирования("", ТаблицаПользователей, Ложь, Истина);
		
		Для Каждого СтрокаТаблицы Из ТаблицаПользователей Цикл
			Источники.Добавить(СтрокаТаблицы.Пользователь);
		КонецЦикла;
		
	КонецЕсли;
	
	Обработки.НастройкиПользователей.УдалитьНастройкиПользователей(МассивНастроек, Источники);
	
КонецПроцедуры

#КонецОбласти
