﻿&НаКлиенте
Перем ПеременныеКлиента;

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Представление", ПредставлениеПоля);
	Параметры.Свойство("ОграничиватьВыборУказаннымиЗначениями", ОграничиватьВыборУказаннымиЗначениями);
	ИнформацияОТипах = ОтчетыКлиентСервер.АнализТипов(Параметры.ОписаниеТипов, Истина);
	ЗначенияДляВыбора = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ЗначенияДляВыбора");
	Отмеченные = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "Отмеченные");
	
	Заголовок = НСтр("ru = 'Список выбранных'") + " (" + ПредставлениеПоля + ")";
	
	Если ИнформацияОТипах.КоличествоТипов = 0 Тогда
		ОграничиватьВыборУказаннымиЗначениями = Истина;
	ИначеЕсли Не ИнформацияОТипах.СодержитОбъектныеТипы Тогда
		Элементы.СписокПодбор.Видимость     = Ложь;
		Элементы.СписокПодборМеню.Видимость = Ложь;
		Элементы.СписокДобавить.ТолькоВоВсехДействиях = Ложь;
	КонецЕсли;
	
	Список.ТипЗначения = ИнформацияОТипах.ОписаниеТиповДляФормы;
	Если ТипЗнч(ЗначенияДляВыбора) = Тип("СписокЗначений") Тогда
		ЗначенияДляВыбора.ЗаполнитьПометки(Ложь);
		ОтчетыКлиентСервер.ДополнитьСписок(Список, ЗначенияДляВыбора, Истина);
	КонецЕсли;
	Если ТипЗнч(Отмеченные) = Тип("СписокЗначений") Тогда
		Отмеченные.ЗаполнитьПометки(Истина);
		ОтчетыКлиентСервер.ДополнитьСписок(Список, Отмеченные, Истина);
	КонецЕсли;
	
	Если ОграничиватьВыборУказаннымиЗначениями Тогда
		Элементы.СписокЗначение.ТолькоПросмотр = Истина;
		Элементы.Список.ИзменятьСоставСтрок    = Ложь;
		
		Элементы.СписокДобавлениеУдаление.Видимость     = Ложь;
		Элементы.СписокДобавлениеУдалениеМеню.Видимость = Ложь;
		
		Элементы.СписокСортировка.Видимость     = Ложь;
		Элементы.СписокСортировкаМеню.Видимость = Ложь;
		
		Элементы.СписокПеремещение.Видимость     = Ложь;
		Элементы.СписокПеремещениеМеню.Видимость = Ложь;
	КонецЕсли;
	
	ПараметрыВыбора = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "ПараметрыВыбора");
	Если ТипЗнч(ПараметрыВыбора) = Тип("Массив") Тогда
		Элементы.СписокЗначение.ПараметрыВыбора = Новый ФиксированныйМассив(ПараметрыВыбора);
	КонецЕсли;
	
	КлючСохраненияПоложенияОкна = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(Параметры, "КлючУникальности");
	Если ПустаяСтрока(КлючСохраненияПоложенияОкна) Тогда
		КлючСохраненияПоложенияОкна = Строка(Список.ТипЗначения);
	КонецЕсли;
	
	Если Не ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла") Тогда
		Элементы.СписокВставитьИзБуфераОбмена.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПеременныеКлиента = Новый Структура;
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ТАБЛИЦЫ Список

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	СтрокаИдентификатор = Элемент.ТекущаяСтрока;
	Если СтрокаИдентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокЗначенийВФорме = ЭтотОбъект[Элемент.Имя];
	ЭлементСпискаВФорме = СписокЗначенийВФорме.НайтиПоИдентификатору(СтрокаИдентификатор);
	
	ТекущаяСтрока = Элемент.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ЭлементСпискаДоНачалаИзменения = Новый Структура("Идентификатор, Пометка, Значение, Представление");
	ЗаполнитьЗначенияСвойств(ЭлементСпискаДоНачалаИзменения, ЭлементСпискаВФорме);
	ЭлементСпискаДоНачалаИзменения.Идентификатор = СтрокаИдентификатор;
	ПеременныеКлиента.Вставить("ЭлементСпискаДоНачалаИзменения", ЭлементСпискаДоНачалаИзменения);
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Если ОграничиватьВыборУказаннымиЗначениями Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередУдалением(Элемент, Отказ)
	Если ОграничиватьВыборУказаннымиЗначениями Тогда
		Отказ = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаНачалаРедактирования, ОтменаЗавершенияРедактирования)
	Если ОтменаНачалаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаИдентификатор = Элемент.ТекущаяСтрока;
	Если СтрокаИдентификатор = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СписокЗначенийВФорме = ЭтотОбъект[Элемент.Имя];
	ЭлементСпискаВФорме = СписокЗначенийВФорме.НайтиПоИдентификатору(СтрокаИдентификатор);
	
	Значение = ЭлементСпискаВФорме.Значение;
	Если Значение = Неопределено
		Или Значение = Тип("Неопределено")
		Или Значение = Новый ОписаниеТипов("Неопределено")
		Или Не ЗначениеЗаполнено(Значение) Тогда
		ОтменаЗавершенияРедактирования = Истина; // Запрет пустых значений.
	Иначе
		Для Каждого ЭлементСпискаДубльВФорме Из СписокЗначенийВФорме Цикл
			Если ЭлементСпискаДубльВФорме.Значение = Значение И ЭлементСпискаДубльВФорме <> ЭлементСпискаВФорме Тогда
				Состояние(НСтр("ru = 'Обнаружены дублирующиеся записи. Редактирование отменено.'"));
				ОтменаЗавершенияРедактирования = Истина; // Запрет дублей.
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	ЭлементСпискаДоНачалаИзменения = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПеременныеКлиента, "ЭлементСпискаДоНачалаИзменения");
	ЕстьИнформация = (ЭлементСпискаДоНачалаИзменения <> Неопределено И ЭлементСпискаДоНачалаИзменения.Идентификатор = СтрокаИдентификатор);
	Если Не ОтменаЗавершенияРедактирования И ЕстьИнформация И ЭлементСпискаДоНачалаИзменения.Значение <> Значение Тогда
		Если ОграничиватьВыборУказаннымиЗначениями Тогда
			ОтменаЗавершенияРедактирования = Истина;
		Иначе
			ЭлементСпискаВФорме.Представление = ""; // Автозаполнение представления.
			ЭлементСпискаВФорме.Пометка = Истина; // Включение флажка.
		КонецЕсли;
	КонецЕсли;
	
	Если ОтменаЗавершенияРедактирования Тогда
		// Откат значений.
		Если ЕстьИнформация Тогда
			ЗаполнитьЗначенияСвойств(ЭлементСпискаВФорме, ЭлементСпискаДоНачалаИзменения);
		КонецЕсли;
		// Перезапуск события "ПередОкончаниемРедактирования" с ОтменаНачалаРедактирования = Истина.
		Элемент.ЗакончитьРедактированиеСтроки(Истина);
	Иначе
		Если НоваяСтрока Тогда
			ЭлементСпискаВФорме.Пометка = Истина; // Включение флажка.
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СписокОбработкаВыбора(Элемент, РезультатВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	// Добавление выбранных элементов с контролем уникальности.
	Если ТипЗнч(РезультатВыбора) = Тип("Массив") Тогда
		Для Каждого Значение Из РезультатВыбора Цикл
			ОтчетыКлиентСервер.ДобавитьУникальноеЗначениеВСписок(Список, Значение, Неопределено, Истина);
		КонецЦикла;
	Иначе
		ОтчетыКлиентСервер.ДобавитьУникальноеЗначениеВСписок(Список, РезультатВыбора, Неопределено, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ КНОПОК

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьРедактирование(Команда)
	Если МодальныйРежим
		Или РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс
		Или ВладелецФормы = Неопределено Тогда
		Закрыть(Список);
	Иначе
		ОповеститьОВыборе(Список);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВставитьИзБуфераОбмена(Команда)
	ПараметрыПоиска = Новый Структура;
	ПараметрыПоиска.Вставить("ОписаниеТипов", Список.ТипЗначения);
	ПараметрыПоиска.Вставить("ПараметрыВыбора", Элементы.СписокЗначение.ПараметрыВыбора);
	ПараметрыПоиска.Вставить("ПредставлениеПоля", ПредставлениеПоля);
	ПараметрыПоиска.Вставить("Сценарий", "ПоискСсылок");
	
	ПараметрыВыполнения = Новый Структура;
	Обработчик = Новый ОписаниеОповещения("ВставитьИзБуфераОбменаЗавершение", ЭтотОбъект, ПараметрыВыполнения);
	
	МодульЗагрузкаДанныхИзФайлаКлиент = ОбщегоНазначенияКлиент.ОбщийМодуль("ЗагрузкаДанныхИзФайлаКлиент");
	МодульЗагрузкаДанныхИзФайлаКлиент.ПоказатьФормуЗаполненияСсылок(ПараметрыПоиска, Обработчик);
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВставитьИзБуфераОбменаЗавершение(НайденныеОбъекты, ПараметрыВыполнения) Экспорт
	Если НайденныеОбъекты = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Для Каждого Значение Из НайденныеОбъекты Цикл
		ОтчетыКлиентСервер.ДобавитьУникальноеЗначениеВСписок(Список, Значение, Неопределено, Истина);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти