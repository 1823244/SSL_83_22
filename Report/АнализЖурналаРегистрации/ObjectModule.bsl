﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровкиОбъект, СтандартнаяОбработка, АдресХранилища) 	
	СтандартнаяОбработка = Ложь;
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	Период = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Период").Значение;
	ВариантОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВариантОтчета").Значение; 
	Если ВариантОтчета = "КонтрольЖурналаРегистрации" Тогда
		РезультатФормированияОтчета = Отчеты.АнализЖурналаРегистрации.
			СформироватьОтчетКонтрольЖурналаРегистрации(Период.ДатаНачала, Период.ДатаОкончания);
		// ОтчетПустой - параметр, показывающий наличие информации в отчете. Необходим для рассылки отчетов.
		ОтчетПустой = РезультатФормированияОтчета.ОтчетПустой;
		КомпоновщикНастроек.Настройки.ДополнительныеСвойства.Вставить("ОтчетПустой", ОтчетПустой);
		ДокументРезультат.Вывести(РезультатФормированияОтчета.Отчет);
	ИначеЕсли ВариантОтчета = "ДиаграммаГанта" Тогда
		ПродолжительностьРаботыРегламентныхЗаданий(НастройкиОтчета, ДокументРезультат);
	Иначе
		ПараметрыОтчета = ПараметрыОтчетаАктивностьПользователя(НастройкиОтчета);
		ПараметрыОтчета.Вставить("ДатаНачала", Период.ДатаНачала);
		ПараметрыОтчета.Вставить("ДатаОкончания", Период.ДатаОкончания);
		ПараметрыОтчета.Вставить("ВариантОтчета", ВариантОтчета);
		КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
		МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, НастройкиОтчета, ДанныеРасшифровкиОбъект);
		ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
		ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,
			Отчеты.АнализЖурналаРегистрации.ДанныеИзЖурналаРегистрации(ПараметрыОтчета), ДанныеРасшифровкиОбъект, Истина);
        ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
		ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
		ПроцессорВывода.НачатьВывод();
		Пока Истина Цикл
			ЭлементРезультата = ПроцессорКомпоновки.Следующий();
			Если ЭлементРезультата = Неопределено Тогда
				Прервать;
			Иначе
				ПроцессорВывода.ВывестиЭлемент(ЭлементРезультата);
			КонецЕсли;
		КонецЦикла;
		ДокументРезультат.ПоказатьУровеньГруппировокСтрок(1);
		ПроцессорВывода.ЗакончитьВывод();
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	НастройкиОтчета = КомпоновщикНастроек.ПолучитьНастройки();
	ВариантОтчета = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВариантОтчета").Значение;
	Если ВариантОтчета = "ДиаграммаГанта" Тогда
		ПериодДень = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПериодДень").Значение;
		НачалоВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("НачалоВыборки");
		КонецВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("КонецВыборки");
		
		Если Не ЗначениеЗаполнено(ПериодДень.Дата) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено значение поля День!'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(НачалоВыборки.Значение)
		И ЗначениеЗаполнено(КонецВыборки.Значение)
		И НачалоВыборки.Значение > КонецВыборки.Значение
		И НачалоВыборки.Использование 
		И КонецВыборки.Использование Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Значение начала периода не может быть больше значения конца!'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ВариантОтчета = "АктивностьПользователя" Тогда
		
		Пользователь = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Пользователь").Значение;
		
		Если Не ЗначениеЗаполнено(Пользователь) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено значение поля Пользователь!'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Если Отчеты.АнализЖурналаРегистрации.ИмяПользователяИБ(Пользователь) = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Формирование отчета возможно только для пользователя, которому указано имя для входа в программу.'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	ИначеЕсли ВариантОтчета = "АнализАктивностиПользователей" Тогда
		
		ПользователиИГруппы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПользователиИГруппы").Значение;
		
		Если ТипЗнч(ПользователиИГруппы) = Тип("СправочникСсылка.Пользователи") Тогда
			
			Если Отчеты.АнализЖурналаРегистрации.ИмяПользователяИБ(ПользователиИГруппы) = Неопределено Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Формирование отчета возможно только для пользователя, которому указано имя для входа в программу.'"), , );
				Отказ = Истина;
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(ПользователиИГруппы) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Не заполнено значение поля Пользователи!'"), , );
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры
 
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПараметрыОтчетаАктивностьПользователя(НастройкиОтчета)
	
	ПользователиИГруппы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПользователиИГруппы").Значение;
	Пользователь = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("Пользователь").Значение;
	ВыводитьБизнесПроцессы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьБизнесПроцессы");
	ВыводитьЗадачи = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьЗадачи");
	ВыводитьСправочники = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьСправочники");
	ВыводитьДокументы = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ВыводитьДокументы");
	
	Если Не ВыводитьБизнесПроцессы.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьБизнесПроцессы", Ложь);
	КонецЕсли;
	Если Не ВыводитьЗадачи.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьЗадачи", Ложь);
	КонецЕсли;
	Если Не ВыводитьСправочники.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьСправочники", Ложь);
	КонецЕсли;
	Если Не ВыводитьДокументы.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ВыводитьДокументы", Ложь);
	КонецЕсли;		
	
	ПараметрыОтчета = Новый Структура;
	ПараметрыОтчета.Вставить("ПользователиИГруппы", ПользователиИГруппы);
	ПараметрыОтчета.Вставить("Пользователь", Пользователь);
	ПараметрыОтчета.Вставить("ВыводитьБизнесПроцессы", ВыводитьБизнесПроцессы.Значение);
	ПараметрыОтчета.Вставить("ВыводитьЗадачи", ВыводитьЗадачи.Значение);
	ПараметрыОтчета.Вставить("ВыводитьСправочники", ВыводитьСправочники.Значение);
	ПараметрыОтчета.Вставить("ВыводитьДокументы", ВыводитьДокументы.Значение);
	
	Возврат ПараметрыОтчета;
КонецФункции

Процедура ПродолжительностьРаботыРегламентныхЗаданий(НастройкиОтчета, ДокументРезультат)
	ВыводитьЗаголовок = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("ВыводитьЗаголовок");
	ВыводитьОтбор = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("ВыводитьОтбор");
	ЗаголовокОтчета = НастройкиОтчета.ПараметрыВывода.Элементы.Найти("Заголовок");
	ПериодДень = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ПериодДень").Значение;
	НачалоВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("НачалоВыборки");
	КонецВыборки = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("КонецВыборки");
	МинимальнаяПродолжительностьСеансовРегламентныхЗаданий = НастройкиОтчета.ПараметрыДанных.Элементы.Найти(
																"МинимальнаяПродолжительностьСеансовРегламентныхЗаданий");
	ОтображатьФоновыеЗадания = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("ОтображатьФоновыеЗадания");
	СкрытьРегламентныеЗадания = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("СкрытьРегламентныеЗадания");
	РазмерОдновременноСессий = НастройкиОтчета.ПараметрыДанных.Элементы.Найти("РазмерОдновременноСессий");
	
	// Проверка наличия флажка использовать у параметров.
	Если Не МинимальнаяПродолжительностьСеансовРегламентныхЗаданий.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("МинимальнаяПродолжительностьСеансовРегламентныхЗаданий", 0);
	КонецЕсли;
	Если Не ОтображатьФоновыеЗадания.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("ОтображатьФоновыеЗадания", Ложь);
	КонецЕсли;
	Если Не СкрытьРегламентныеЗадания.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("СкрытьРегламентныеЗадания", "");
	КонецЕсли;
	Если Не РазмерОдновременноСессий.Использование Тогда
		НастройкиОтчета.ПараметрыДанных.УстановитьЗначениеПараметра("РазмерОдновременноСессий", 0);
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(НачалоВыборки.Значение) Тогда
		ПериодДеньДатаНачала = НачалоДня(ПериодДень);
	ИначеЕсли Не НачалоВыборки.Использование Тогда
		ПериодДеньДатаНачала = НачалоДня(ПериодДень);
	Иначе
		ПериодДеньДатаНачала = Дата(Формат(ПериодДень.Дата, "ДЛФ=D") + " " + Формат(НачалоВыборки.Значение, "ДЛФ=T"));
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(КонецВыборки.Значение) Тогда
		ПериодДеньДатаОкончания = КонецДня(ПериодДень);
	ИначеЕсли Не КонецВыборки.Использование Тогда
		ПериодДеньДатаОкончания = КонецДня(ПериодДень);
	Иначе
		ПериодДеньДатаОкончания = Дата(Формат(ПериодДень.Дата, "ДЛФ=D") + " " + Формат(КонецВыборки.Значение, "ДЛФ=T"));
	КонецЕсли;
	
	ПараметрыЗаполнения = Новый Структура;
	ПараметрыЗаполнения.Вставить("ДатаНачала", ПериодДеньДатаНачала);
	ПараметрыЗаполнения.Вставить("ДатаОкончания", ПериодДеньДатаОкончания);
	ПараметрыЗаполнения.Вставить("РазмерОдновременноСессий", РазмерОдновременноСессий.Значение);
	ПараметрыЗаполнения.Вставить("МинимальнаяПродолжительностьСеансовРегламентныхЗаданий", 
								  МинимальнаяПродолжительностьСеансовРегламентныхЗаданий.Значение);
	ПараметрыЗаполнения.Вставить("ОтображатьФоновыеЗадания", ОтображатьФоновыеЗадания.Значение);
	ПараметрыЗаполнения.Вставить("ВыводитьЗаголовок", ВыводитьЗаголовок);
	ПараметрыЗаполнения.Вставить("ВыводитьОтбор", ВыводитьОтбор);
	ПараметрыЗаполнения.Вставить("ЗаголовокОтчета", ЗаголовокОтчета);
	ПараметрыЗаполнения.Вставить("СкрытьРегламентныеЗадания", СкрытьРегламентныеЗадания.Значение);
	
	РезультатФормированияОтчета = Отчеты.АнализЖурналаРегистрации.
									СформироватьОтчетПоПродолжительностиРаботыРегламентныхЗаданий(ПараметрыЗаполнения);
	ДокументРезультат.Вывести(РезультатФормированияОтчета.Отчет);
КонецПроцедуры    

#КонецОбласти

#КонецЕсли