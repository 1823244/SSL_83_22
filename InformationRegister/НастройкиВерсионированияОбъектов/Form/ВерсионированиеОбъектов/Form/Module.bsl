﻿

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЗаполнитьТипыОбъектовВДеревеЗначений();
	ЗаполнитьСпискиВыбора();
	
	Элементы.Очистить.Видимость = Ложь;
	Элементы.Расписание.Заголовок = ТекущееРасписание();
	АвтоматическиУдалятьУстаревшиеВерсии = АвтоматическаяОчисткаВключена();
	Элементы.Расписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
	Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = ТекстСостоянияПодсчет();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДеревоОбъектовМетаданных

&НаКлиенте
Процедура ДеревоОбъектовМетаданныхПередНачаломИзменения(Элемент, Отказ)
	
	Если Элемент.ТекущиеДанные.ПолучитьРодителя() = Неопределено Тогда
		Отказ = Истина;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ВариантВерсионирования Тогда
		ЗаполнитьСписокВыбора(Элементы.ДеревоОбъектовМетаданных.ТекущийЭлемент);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	ЗаписатьТекущиеНастройкиПоОбъекту(ТекущиеДанные.ТипОбъекта, ТекущиеДанные.ВариантВерсионирования, ТекущиеДанные.СрокХраненияВерсий);
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьВариантВерсионированияНеВерсионировать(Команда)
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.НеВерсионировать"));	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьРежимВерсионированияПриЗаписи(Команда)
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи"));	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВариантВерсионированияПриПроведении(Команда)
	
	Если ВыбранТипДокументовБезВозможностиПроведения() Тогда
		ПоказатьПредупреждение(, НСтр("ru = 'Документам, которые не могут быть проведены, установлен режим версионирования ""Версионировать при записи"".'"));
	КонецЕсли;
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении"));	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьНастройкиПоУмолчанию(Команда)
	
	УстановитьВариантВерсионированияДляВыделенныхСтрок(Неопределено);
	
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ЗаполнитьТипыОбъектовВДеревеЗначений();
	ОбновитьИнформациюОбУстаревшихВерсиях();
	Для Каждого Элемент Из ДеревоОбъектовМетаданных.ПолучитьЭлементы() Цикл
		Элементы.ДеревоОбъектовМетаданных.Развернуть(Элемент.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура Очистить(Команда)
	ПрерватьФоновоеЗадание();
	ЗапуститьРегламентноеЗадание();
	НачатьОбновлениеИнформацииОбУстаревшихВерсиях();
	ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследнююНеделю(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследнююНеделю"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследнийМесяц(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследнийМесяц"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследниеТриМесяца(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследниеТриМесяца"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследниеШестьМесяцев(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследниеШестьМесяцев"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ЗаПоследнийГод(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.ЗаПоследнийГод"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура Бессрочно(Команда)
	УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(
		ПредопределенноеЗначение("Перечисление.СрокиХраненияВерсий.Бессрочно"));
	ОбновитьИнформациюОбУстаревшихВерсиях();
КонецПроцедуры

&НаКлиенте
Процедура ВерсионироватьПриСтарте(Команда)
	УстановитьВариантВерсионированияДляВыделенныхСтрок(
		ПредопределенноеЗначение("Перечисление.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте"));
КонецПроцедуры

&НаКлиенте
Процедура НастроитьРасписание(Команда)
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(ТекущееРасписание());
	ОписаниеОповещения = Новый ОписаниеОповещения("НастроитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
КонецПроцедуры

&НаКлиенте
Процедура КоличествоИОбъемХранимыхВерсийОбъектов(Команда)
	ОткрытьФорму("Отчет.АнализВерсийОбъектов.ФормаОбъекта");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗаполнитьСписокВыбора(Элемент)
	
	СтрокаДерева = Элементы.ДеревоОбъектовМетаданных.ТекущиеДанные;
	
	Элемент.СписокВыбора.Очистить();
	
	Если СтрокаДерева.КлассОбъекта = "КлассДокументы" И СтрокаДерева.Проводится Тогда
		СписокВыбора = СписокВыбораДокументы;
	ИначеЕсли СтрокаДерева.КлассОбъекта = "КлассБизнесПроцессы" Тогда
		СписокВыбора = СписокВыбораБизнесПроцессы;
	Иначе
		СписокВыбора = СписокВыбораСправочники;
	КонецЕсли;
	
	Для Каждого ЭлементСписка Из СписокВыбора Цикл
		Элемент.СписокВыбора.Добавить(ЭлементСписка.Значение);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьТипыОбъектовВДеревеЗначений()
	
	НастройкиВерсионирования = ТекущиеНастройкиВерсионирования();
	
	ДеревоОМ = РеквизитФормыВЗначение("ДеревоОбъектовМетаданных");
	ДеревоОМ.Строки.Очистить();
	
	// Тип параметра команды ИсторияИзменений содержит состав объектов для которых 
	// применяется версионирование.
	МассивТипов = Метаданные.ОбщиеКоманды.ИсторияИзменений.ТипПараметраКоманды.Типы();
	ЕстьСправочники = Ложь;
	ЕстьДокументы = Ложь;
	ВсеСправочники = Справочники.ТипВсеСсылки();
	ВсеДокументы = Документы.ТипВсеСсылки();
	УзелСправочники = Неопределено;
	УзелДокументы = Неопределено;
	УзелБизнесПроцессы = Неопределено;
	
	Для Каждого Тип Из МассивТипов Цикл
		Если ВсеСправочники.СодержитТип(Тип) Тогда
			Если УзелСправочники = НеОпределено Тогда
				УзелСправочники = ДеревоОМ.Строки.Добавить();
				УзелСправочники.СинонимНаименованияОбъекта = НСтр("ru = 'Справочники'");
				УзелСправочники.КлассОбъекта = "01КлассСправочникиКорень";
				УзелСправочники.КодКартинки = 2;
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелСправочники.Строки.Добавить();
			НоваяСтрокаТаблицы.КодКартинки = 19;
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассСправочники";
		ИначеЕсли ВсеДокументы.СодержитТип(Тип) Тогда
			Если УзелДокументы = НеОпределено Тогда
				УзелДокументы = ДеревоОМ.Строки.Добавить();
				УзелДокументы.СинонимНаименованияОбъекта = НСтр("ru = 'Документы'");
				УзелДокументы.КлассОбъекта = "02КлассДокументыКорень";
				УзелДокументы.КодКартинки = 3;
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелДокументы.Строки.Добавить();
			НоваяСтрокаТаблицы.КодКартинки = 20;
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассДокументы";
		ИначеЕсли БизнесПроцессы.ТипВсеСсылки().СодержитТип(Тип) Тогда
			Если УзелБизнесПроцессы = Неопределено Тогда
				УзелБизнесПроцессы = ДеревоОМ.Строки.Добавить();
				УзелБизнесПроцессы.СинонимНаименованияОбъекта = НСтр("ru = 'Бизнес-процессы'");
				УзелБизнесПроцессы.КлассОбъекта = "03БизнесПроцессыКорень";
				УзелБизнесПроцессы.ТипОбъекта = "БизнесПроцессы";
			КонецЕсли;
			НоваяСтрокаТаблицы = УзелБизнесПроцессы.Строки.Добавить();
			НоваяСтрокаТаблицы.КлассОбъекта = "КлассБизнесПроцессы";
		КонецЕсли;
		МетаданныеОбъекта = Метаданные.НайтиПоТипу(Тип);
		НоваяСтрокаТаблицы.ТипОбъекта = ОбщегоНазначения.ИдентификаторОбъектаМетаданных(Тип);
		НоваяСтрокаТаблицы.СинонимНаименованияОбъекта = МетаданныеОбъекта.Синоним;
		
		НайденныеНастройки = НастройкиВерсионирования.НайтиСтроки(Новый Структура("ТипОбъекта", НоваяСтрокаТаблицы.ТипОбъекта));
		Если НайденныеНастройки.Количество() > 0 Тогда
			НоваяСтрокаТаблицы.ВариантВерсионирования = НайденныеНастройки[0].ВариантВерсионирования;
			НоваяСтрокаТаблицы.СрокХраненияВерсий = НайденныеНастройки[0].СрокХраненияВерсий;
			Если Не ЗначениеЗаполнено(НайденныеНастройки[0].СрокХраненияВерсий) Тогда
				НоваяСтрокаТаблицы.СрокХраненияВерсий = Перечисления.СрокиХраненияВерсий.Бессрочно;
			КонецЕсли;
		Иначе
			НоваяСтрокаТаблицы.ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать;
			НоваяСтрокаТаблицы.СрокХраненияВерсий = Перечисления.СрокиХраненияВерсий.Бессрочно;
		КонецЕсли;
		
		Если НоваяСтрокаТаблицы.КлассОбъекта = "КлассДокументы" Тогда
			НоваяСтрокаТаблицы.Проводится = ? (МетаданныеОбъекта.Проведение = Метаданные.СвойстваОбъектов.Проведение.Разрешить, Истина, Ложь);
		КонецЕсли;
	КонецЦикла;
	ДеревоОМ.Строки.Сортировать("КлассОбъекта");
	Для Каждого УзелВерхнегоУровня Из ДеревоОМ.Строки Цикл
		УзелВерхнегоУровня.Строки.Сортировать("СинонимНаименованияОбъекта");
	КонецЦикла;
	ЗначениеВРеквизитФормы(ДеревоОМ, "ДеревоОбъектовМетаданных");
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранТипДокументовБезВозможностиПроведения()
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.КлассОбъекта = "КлассДокументы" И Не ЭлементДерева.Проводится Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Ложь;
	
КонецФункции

&НаСервере
Процедура УстановитьВариантВерсионированияДляВыделенныхСтрок(Знач ВариантВерсионирования)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда 
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьВариантВерсионированияДляЭлементаДерева(ПодчиненныйЭлементДерева, ВариантВерсионирования);
			КонецЦикла;
		Иначе
			УстановитьВариантВерсионированияДляЭлементаДерева(ЭлементДерева, ВариантВерсионирования);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВариантВерсионированияДляЭлементаДерева(ЭлементДерева, Знач ВариантВерсионирования)
	
	Если ВариантВерсионирования = Неопределено Тогда
		Если ЭлементДерева.КлассОбъекта = "КлассДокументы" Тогда
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении;
		ИначеЕсли ЭлементДерева.ПолучитьРодителя().ТипОбъекта = "БизнесПроцессы" Тогда
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте;
		Иначе
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать;
		КонецЕсли;
	КонецЕсли;
	
	Если ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении
		И Не ЭлементДерева.Проводится 
		Или ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте
		И ЭлементДерева.КлассОбъекта <> "КлассБизнесПроцессы" Тогда
			ВариантВерсионирования = Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи;
	КонецЕсли;
	
	ЭлементДерева.ВариантВерсионирования = ВариантВерсионирования;
	
	ЗаписатьТекущиеНастройкиПоОбъекту(ЭлементДерева.ТипОбъекта, ВариантВерсионирования, ЭлементДерева.СрокХраненияВерсий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСрокХраненияВерсийДляВыбранныхОбъектов(СрокХраненияВерсий)
	
	Для Каждого ИдентификаторСтроки Из Элементы.ДеревоОбъектовМетаданных.ВыделенныеСтроки Цикл
		ЭлементДерева = ДеревоОбъектовМетаданных.НайтиПоИдентификатору(ИдентификаторСтроки);
		Если ЭлементДерева.ПолучитьРодителя() = Неопределено Тогда
			Для Каждого ПодчиненныйЭлементДерева Из ЭлементДерева.ПолучитьЭлементы() Цикл
				УстановитьСрокХраненияВерсийДляВыбранногоОбъекта(ПодчиненныйЭлементДерева, СрокХраненияВерсий);
			КонецЦикла;
		Иначе
			УстановитьСрокХраненияВерсийДляВыбранногоОбъекта(ЭлементДерева, СрокХраненияВерсий);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьСрокХраненияВерсийДляВыбранногоОбъекта(ВыбранныйОбъект, СрокХраненияВерсий)
	
	ВыбранныйОбъект.СрокХраненияВерсий = СрокХраненияВерсий;
	ЗаписатьТекущиеНастройкиПоОбъекту(ВыбранныйОбъект.ТипОбъекта, ВыбранныйОбъект.ВариантВерсионирования, СрокХраненияВерсий);
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьТекущиеНастройкиПоОбъекту(ТипОбъекта, ВариантВерсионирования, СрокХраненияВерсий)
	ВерсионированиеОбъектов.ЗаписатьНастройкуВерсионированияПоОбъекту(ТипОбъекта, ВариантВерсионирования, СрокХраненияВерсий);
КонецПроцедуры

&НаСервере
Функция ТекущиеНастройкиВерсионирования()
	УстановитьПривилегированныйРежим(Истина);
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиВерсионированияОбъектов.ТипОбъекта КАК ТипОбъекта,
	|	НастройкиВерсионированияОбъектов.Вариант КАК ВариантВерсионирования,
	|	НастройкиВерсионированияОбъектов.СрокХраненияВерсий КАК СрокХраненияВерсий
	|ИЗ
	|	РегистрСведений.НастройкиВерсионированияОбъектов КАК НастройкиВерсионированияОбъектов";
	Запрос = Новый Запрос(ТекстЗапроса);
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

&НаКлиенте
Процедура НастроитьРасписаниеЗавершение(Расписание, ДополнительныеПараметры) Экспорт
	Если Расписание = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьРасписаниеРегламентногоЗадания(Расписание);
	Элементы.Расписание.Заголовок = Расписание;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьРасписаниеРегламентногоЗадания(Расписание);
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Если СписокЗаданий.Количество() = 0 Тогда
				ПараметрыЗадания.Вставить("Расписание", Расписание);
				МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
			Иначе
				ПараметрыЗадания = Новый Структура("Расписание", Расписание);
				Для Каждого Задание Из СписокЗаданий Цикл
					МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов);
		РегламентноеЗадание.Расписание = Расписание;
		РегламентноеЗадание.Записать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ТекущееРасписание()
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание.Расписание;
			КонецЦикла;
		
			Возврат Новый РасписаниеРегламентногоЗадания;
		КонецЕсли;
	Иначе
		Возврат РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов).Расписание;
	КонецЕсли;
КонецФункции

&НаКлиенте
Процедура АвтоматическиУдалятьУстаревшиеВерсииПриИзменении(Элемент)
	ВключитьОтключитьРегламентноеЗадание(АвтоматическиУдалятьУстаревшиеВерсии);
	Элементы.Расписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
	Элементы.НастроитьРасписание.Доступность = АвтоматическиУдалятьУстаревшиеВерсии;
КонецПроцедуры

&НаСервере
Процедура ВключитьОтключитьРегламентноеЗадание(Использование)
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Если СписокЗаданий.Количество() = 0 Тогда
				ПараметрыЗадания.Вставить("Использование", Использование);
				МодульОчередьЗаданий.ДобавитьЗадание(ПараметрыЗадания);
			Иначе
				ПараметрыЗадания = Новый Структура("Использование", Использование);
				Для Каждого Задание Из СписокЗаданий Цикл
					МодульОчередьЗаданий.ИзменитьЗадание(Задание.Идентификатор, ПараметрыЗадания);
				КонецЦикла;
			КонецЕсли;
		КонецЕсли;
	Иначе
		РегламентноеЗадание = РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов);
		РегламентноеЗадание.Использование = Не РегламентноеЗадание.Использование;
		РегламентноеЗадание.Записать();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВыполнениеФоновогоЗадания()
	Если Не ЗаданиеВыполнено(ИдентификаторФоновогоЗадания) Тогда
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 5, Истина);
	Иначе
		ИдентификаторФоновогоЗадания = "";
		Если ТекущееФоновоеЗадание = "Подсчет" Тогда
			ВывестиИнформациюОбУстаревшихВерсиях();
			Возврат;
		КонецЕсли;
		ТекущееФоновоеЗадание = "";
		ОбновитьИнформациюОбУстаревшихВерсиях();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторФоновогоЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторФоновогоЗадания);
КонецФункции

&НаСервереБезКонтекста
Процедура ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания)
	ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
КонецПроцедуры

&НаСервере
Процедура ЗапуститьРегламентноеЗадание()
	
	РегламентноеЗаданиеМетаданные = Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов;
	
	Отбор = Новый Структура;
	ИмяМетода = РегламентноеЗаданиеМетаданные.ИмяМетода;
	Отбор.Вставить("ИмяМетода", ИмяМетода);
	
	Отбор.Вставить("Состояние", СостояниеФоновогоЗадания.Активно);
	ФоновыеЗаданияОчистки = ФоновыеЗадания.ПолучитьФоновыеЗадания(Отбор);
	Если ФоновыеЗаданияОчистки.Количество() > 0 Тогда
		ИдентификаторФоновогоЗадания = ФоновыеЗаданияОчистки[0].УникальныйИдентификатор;
	Иначе
		НаименованиеФоновогоЗадания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Запуск вручную: %1'"), РегламентноеЗаданиеМетаданные.Синоним);
		ФоновоеЗадание = ФоновыеЗадания.Выполнить(РегламентноеЗаданиеМетаданные.ИмяМетода, , , НаименованиеФоновогоЗадания);
		ИдентификаторФоновогоЗадания = ФоновоеЗадание.УникальныйИдентификатор;
	КонецЕсли;
	
	ТекущееФоновоеЗадание = "Очистка";
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформациюОбУстаревшихВерсиях()
	ОтключитьОбработчикОжидания("НачатьОбновлениеИнформацииОбУстаревшихВерсиях");
	Если ТекущееФоновоеЗадание = "Подсчет" И ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		ПрерватьФоновоеЗадание();
	КонецЕсли;
	ПодключитьОбработчикОжидания("НачатьОбновлениеИнформацииОбУстаревшихВерсиях", 2, Истина);
КонецПроцедуры

&НаКлиенте
Процедура ПрерватьФоновоеЗадание()
	ОтменитьВыполнениеЗадания(ИдентификаторФоновогоЗадания);
	ОтключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания");
	ТекущееФоновоеЗадание = "";
	ИдентификаторФоновогоЗадания = "";
КонецПроцедуры

&НаКлиенте
Процедура НачатьОбновлениеИнформацииОбУстаревшихВерсиях()
	
	Элементы.Очистить.Видимость = ТекущееФоновоеЗадание <> "Очистка";
	Если ЗначениеЗаполнено(ИдентификаторФоновогоЗадания) Тогда
		Если ТекущееФоновоеЗадание = "Подсчет" Тогда
			Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = ТекстСостоянияПодсчет();
		Иначе
			Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = ТекстСостоянияОчистка();
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ВыполнитьПоискУстаревшихВерсий() Тогда
		ВывестиИнформациюОбУстаревшихВерсиях();
	Иначе
		НачатьОбновлениеИнформацииОбУстаревшихВерсиях();
		ПодключитьОбработчикОжидания("ПроверитьВыполнениеФоновогоЗадания", 2, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСостоянияПодсчет()
	Возврат НСтр("ru = 'Поиск устаревших версий...'");
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ТекстСостоянияОчистка()
	Возврат НСтр("ru = 'Выполняется очистка устаревших версий...'");
КонецФункции

&НаСервере
Функция ВыполнитьПоискУстаревшихВерсий()
	РезультатВыполнения = ДлительныеОперации.ЗапуститьВыполнениеВФоне(УникальныйИдентификатор,
		"ВерсионированиеОбъектов.ИнформацияОбУстаревшихВерсияхВФоне", Новый Структура);
	АдресРезультата = РезультатВыполнения.АдресХранилища;
	Если Не РезультатВыполнения.ЗаданиеВыполнено Тогда
		ТекущееФоновоеЗадание = "Подсчет";
		ИдентификаторФоновогоЗадания = РезультатВыполнения.ИдентификаторЗадания;
	КонецЕсли;
	Возврат РезультатВыполнения.ЗаданиеВыполнено;
КонецФункции

&НаКлиенте
Процедура ВывестиИнформациюОбУстаревшихВерсиях()
	
	ИнформацияОбУстаревшихВерсиях = ПолучитьИзВременногоХранилища(АдресРезультата);
	Если ИнформацияОбУстаревшихВерсиях = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.Очистить.Видимость = ИнформацияОбУстаревшихВерсиях.РазмерДанных > 0;
	Если ИнформацияОбУстаревшихВерсиях.РазмерДанных > 0 Тогда
		Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Всего устаревших версий: %1 (%2)'"),
			ИнформацияОбУстаревшихВерсиях.КоличествоВерсий,
			ИнформацияОбУстаревшихВерсиях.РазмерДанныхСтрокой);
	Иначе
		Элементы.ИнформацияОбУстаревшихВерсиях.Заголовок = НСтр("ru = 'Всего устаревших версий: нет'");
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСпискиВыбора()
	
	СписокВыбораСправочники = Новый СписокЗначений;
	СписокВыбораСправочники.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи);
	СписокВыбораСправочники.Добавить(Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать);
	
	СписокВыбораДокументы = Новый СписокЗначений;
	СписокВыбораДокументы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи);
	СписокВыбораДокументы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриПроведении);
	СписокВыбораДокументы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать);
	
	СписокВыбораБизнесПроцессы = Новый СписокЗначений;
	СписокВыбораБизнесПроцессы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриЗаписи);
	СписокВыбораБизнесПроцессы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.ВерсионироватьПриСтарте);
	СписокВыбораБизнесПроцессы.Добавить(Перечисления.ВариантыВерсионированияОбъектов.НеВерсионировать);
	
КонецПроцедуры

&НаСервере
Функция АвтоматическаяОчисткаВключена()
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ОбластьДанных = ОбщегоНазначения.ЗначениеРазделителяСеанса();
		ИмяМетода = Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов.ИмяМетода;
		
		ПараметрыЗадания = Новый Структура;
		ПараметрыЗадания.Вставить("ИмяМетода", ИмяМетода);
		ПараметрыЗадания.Вставить("ОбластьДанных", ОбластьДанных);
		
		Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаВМоделиСервиса.ОчередьЗаданий") Тогда
			МодульОчередьЗаданий = ОбщегоНазначения.ОбщийМодуль("ОчередьЗаданий");
			
			УстановитьПривилегированныйРежим(Истина);
			
			СписокЗаданий = МодульОчередьЗаданий.ПолучитьЗадания(ПараметрыЗадания);
			Для Каждого Задание Из СписокЗаданий Цикл
				Возврат Задание.Использование;
			КонецЦикла;
		КонецЕсли;
	Иначе
		Возврат РегламентныеЗадания.НайтиПредопределенное(Метаданные.РегламентныеЗадания.ОчисткаУстаревшихВерсийОбъектов).Использование;
	КонецЕсли;
	
	Возврат Ложь;
КонецФункции
#КонецОбласти
