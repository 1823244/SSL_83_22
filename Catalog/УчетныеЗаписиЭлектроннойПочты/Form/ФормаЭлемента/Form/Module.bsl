﻿

&НаКлиенте
Перем РазрешенияПолучены;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.БлокироватьВладельца Тогда
		РежимОткрытияОкна = РежимОткрытияОкнаФормы.БлокироватьОкноВладельца;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Объект.ИспользоватьДляОтправки = Истина;
		Объект.ИспользоватьДляПолучения = Истина;
	КонецЕсли;
	
	УдалятьПисьмаССервера = Объект.ПериодХраненияСообщенийНаСервере > 0;
	Если Не УдалятьПисьмаССервера Тогда
		Объект.ПериодХраненияСообщенийНаСервере = 10;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемПодтверждениеПолучено", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОписаниеОповещения, Отказ);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если Не УдалятьПисьмаССервера Тогда
		Объект.ПериодХраненияСообщенийНаСервере = 0;
	КонецЕсли;
	
	Если Объект.ПротоколВходящейПочты = "IMAP" Тогда
		Объект.ОставлятьКопииСообщенийНаСервере = Истина;
		Объект.ПериодХраненияСообщенийНаСервере = 0;
	КонецЕсли;
	
	Если РазрешенияПолучены <> Истина Тогда
		Если Не ПроверитьЗаполнение() Тогда 
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		
		Запрос = СоздатьЗапросНаИспользованиеВнешнихРесурсов();
		ОповещениеОЗакрытии = Новый ОписаниеОповещения("ПолучениеРазрешенийЗавершение", ЭтотОбъект, ПараметрыЗаписи);
		
		РаботаВБезопасномРежимеКлиент.ПрименитьЗапросыНаИспользованиеВнешнихРесурсов(
			ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Запрос), ЭтотОбъект, ОповещениеОЗакрытии);
		
		Отказ = Истина;
	КонецЕсли;
	РазрешенияПолучены = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Если ПараметрыЗаписи.Свойство("ЗаписатьИЗакрыть") Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПротоколПриИзменении(Элемент)
	
	Если Объект.ПротоколВходящейПочты = "IMAP" Тогда
		Если Лев(Объект.СерверВходящейПочты, 4) = "pop." Тогда
			Объект.СерверВходящейПочты = "imap." + Сред(Объект.СерверВходящейПочты, 5);
		КонецЕсли
	Иначе
		Если ПустаяСтрока(Объект.ПротоколВходящейПочты) Тогда
			Объект.ПротоколВходящейПочты = "POP";
		КонецЕсли;
		Если Лев(Объект.СерверВходящейПочты, 5) = "imap." Тогда
			Объект.СерверВходящейПочты = "pop." + Сред(Объект.СерверВходящейПочты, 6);
		КонецЕсли;
	КонецЕсли;
	
	УстановитьПортВходящейПочты();
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура СерверВходящейПочтыПриИзменении(Элемент)
	Объект.СерверВходящейПочты = СокрЛП(НРег(Объект.СерверВходящейПочты));
КонецПроцедуры

&НаКлиенте
Процедура СерверИсходящейПочтыПриИзменении(Элемент)
	Объект.СерверИсходящейПочты = СокрЛП(НРег(Объект.СерверИсходящейПочты));
КонецПроцедуры

&НаКлиенте
Процедура АдресЭлектроннойПочтыПриИзменении(Элемент)
	Объект.АдресЭлектроннойПочты = СокрЛП(Объект.АдресЭлектроннойПочты);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗащищенноеСоединениеДляИсходящейПочтыПриИзменении(Элемент)
	УстановитьПортИсходящейПочты();
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьЗащищенноеСоединениеДляВходящейПочтыПриИзменении(Элемент)
	УстановитьПортВходящейПочты();
КонецПроцедуры

&НаКлиенте
Процедура ОставлятьКопииПисемНаСервереПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

&НаКлиенте
Процедура УдалятьПисьмаССервераПриИзменении(Элемент)
	УстановитьДоступностьЭлементов();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПортВходящейПочты()
	Если Объект.ПротоколВходящейПочты = "IMAP" Тогда
		Если Объект.ИспользоватьЗащищенноеСоединениеДляВходящейПочты Тогда
			Объект.ПортСервераВходящейПочты = 993;
		Иначе
			Объект.ПортСервераВходящейПочты = 143;
		КонецЕсли;
	Иначе
		Если Объект.ИспользоватьЗащищенноеСоединениеДляВходящейПочты Тогда
			Объект.ПортСервераВходящейПочты = 995;
		Иначе
			Объект.ПортСервераВходящейПочты = 110;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПортИсходящейПочты()
	Если Объект.ИспользоватьЗащищенноеСоединениеДляИсходящейПочты Тогда
		Объект.ПортСервераИсходящейПочты = 465;
	Иначе
		Объект.ПортСервераИсходящейПочты = 25;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПодтверждениеПолучено(РезультатВопроса, ДополнительныеПараметры) Экспорт
	Записать(Новый Структура("ЗаписатьИЗакрыть"));
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	ИспользуетсяПротоколPOP = Объект.ПротоколВходящейПочты = "POP";
	Элементы.POPПередSMTP.Видимость = ИспользуетсяПротоколPOP;
	Элементы.ОставлятьПисьмаНаСервере.Видимость = ИспользуетсяПротоколPOP;
	
	Элементы.НастройкаПериодаХраненияПисем.Доступность = Объект.ОставлятьКопииСообщенийНаСервере;
	Элементы.ПериодХраненияСообщенийНаСервере.Доступность = УдалятьПисьмаССервера;
КонецПроцедуры

&НаКлиенте
Процедура ПолучениеРазрешенийЗавершение(Результат, ПараметрыЗаписи) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		РазрешенияПолучены = Истина;
		Записать(ПараметрыЗаписи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция СоздатьЗапросНаИспользованиеВнешнихРесурсов()
	
	Возврат РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
		Разрешения(), Объект.Ссылка);
	
КонецФункции

&НаСервере
Функция Разрешения()
	
	Результат = Новый Массив;
	
	Если Объект.ИспользоватьДляОтправки Тогда
		Результат.Добавить(
			РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				"SMTP",
				Объект.СерверИсходящейПочты,
				Объект.ПортСервераИсходящейПочты,
				НСтр("ru = 'Электронная почта.'")));
	КонецЕсли;
	
	Если Объект.ИспользоватьДляПолучения Тогда
		Результат.Добавить(
			РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
				Объект.ПротоколВходящейПочты,
				Объект.СерверВходящейПочты,
				Объект.ПортСервераВходящейПочты,
				НСтр("ru = 'Электронная почта.'")));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
