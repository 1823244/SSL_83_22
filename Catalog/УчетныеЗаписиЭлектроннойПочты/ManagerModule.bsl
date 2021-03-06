﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Групповое изменение объектов.

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыРедактируемыеВГрупповойОбработке() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить("ИспользоватьДляОтправки");
	Результат.Добавить("ИспользоватьДляПолучения");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаОбъекта" И Не Параметры.Свойство("ЗначениеКопирования")
		И (Не Параметры.Свойство("Ключ") Или Не РаботаСПочтовымиСообщениямиВызовСервера.УчетнаяЗаписьНастроена(Параметры.Ключ)) Тогда
		ВыбраннаяФорма = "ПомощникНастройкиУчетнойЗаписи";
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Только для внутреннего использования.
Процедура ЗаполнитьРазрешения(СписокРазрешений) Экспорт
	
	РазрешенияУчетныхЗаписей = РазрешенияУчетныхЗаписей();
	Для Каждого УчетнаяЗапись Из РазрешенияУчетныхЗаписей Цикл
		ОписаниеРазрешения = СписокРазрешений.Добавить();
		ОписаниеРазрешения.Ключ = УчетнаяЗапись.Ключ;
		ОписаниеРазрешения.Разрешения = УчетнаяЗапись.Значения;
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
Функция РазрешенияУчетныхЗаписей(УчетнаяЗапись = Неопределено) Экспорт
	
	Результат = Новый Соответствие;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	УчетныеЗаписиЭлектроннойПочты.ПротоколВходящейПочты КАК Протокол,
	|	УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты КАК Сервер,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты КАК Порт,
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ПОМЕСТИТЬ СервераЭлектроннойПочты
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПротоколВходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляПолучения = ИСТИНА
	|	И УчетныеЗаписиЭлектроннойПочты.СерверВходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПортСервераВходящейПочты > 0
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""SMTP"",
	|	УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты,
	|	УчетныеЗаписиЭлектроннойПочты.ПортСервераИсходящейПочты,
	|	УчетныеЗаписиЭлектроннойПочты.Ссылка
	|ИЗ
	|	Справочник.УчетныеЗаписиЭлектроннойПочты КАК УчетныеЗаписиЭлектроннойПочты
	|ГДЕ
	|	УчетныеЗаписиЭлектроннойПочты.ПометкаУдаления = ЛОЖЬ
	|	И УчетныеЗаписиЭлектроннойПочты.ИспользоватьДляОтправки = ИСТИНА
	|	И УчетныеЗаписиЭлектроннойПочты.СерверИсходящейПочты <> """"
	|	И УчетныеЗаписиЭлектроннойПочты.ПортСервераИсходящейПочты > 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	СервераЭлектроннойПочты.Ссылка КАК Ссылка,
	|	СервераЭлектроннойПочты.Протокол КАК Протокол,
	|	СервераЭлектроннойПочты.Сервер КАК Сервер,
	|	СервераЭлектроннойПочты.Порт КАК Порт
	|ИЗ
	|	СервераЭлектроннойПочты КАК СервераЭлектроннойПочты
	|ГДЕ
	|	(&Ссылка = НЕОПРЕДЕЛЕНО
	|			ИЛИ СервераЭлектроннойПочты.Ссылка = &Ссылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	СервераЭлектроннойПочты.Протокол,
	|	СервераЭлектроннойПочты.Сервер,
	|	СервераЭлектроннойПочты.Порт,
	|	СервераЭлектроннойПочты.Ссылка
	|ИТОГИ ПО
	|	Ссылка";
	
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", УчетнаяЗапись);
	
	УчетныеЗаписи = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока УчетныеЗаписи.Следующий() Цикл
		Разрешения = Новый Массив;
		НастройкиУчетнойЗаписи = УчетныеЗаписи.Выбрать();
		Пока НастройкиУчетнойЗаписи.Следующий() Цикл
			Разрешения.Добавить(
				РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
					НастройкиУчетнойЗаписи.Протокол,
					НастройкиУчетнойЗаписи.Сервер,
					НастройкиУчетнойЗаписи.Порт,
					НСтр("ru = 'Электронная почта.'")
				)
			);
		КонецЦикла;
		Результат.Вставить(УчетныеЗаписи.Ссылка, Разрешения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Только для внутреннего использования.
Функция РазрешенияУчетнойЗаписи(УчетнаяЗапись) Экспорт
	
	Для Каждого Результат Из РазрешенияУчетныхЗаписей(УчетнаяЗапись) Цикл
		Возврат Результат.Значение;
	КонецЦикла;
	
	Возврат Новый Массив;
	
КонецФункции

// Только для внутреннего использования.
Функция ЗапросНаВнешниеРазрешенияДляУчетнойЗаписи(Знач УчетнаяЗапись) Экспорт
	
	Возврат РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
		РазрешенияУчетнойЗаписи(УчетнаяЗапись), УчетнаяЗапись);
	
КонецФункции

Функция УчетнаяЗаписьНастроена(УчетнаяЗапись) Экспорт
	Параметры = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(УчетнаяЗапись, "АдресЭлектроннойПочты,СерверВходящейПочты,СерверИсходящейПочты");
	Возврат Не ПустаяСтрока(Параметры.АдресЭлектроннойПочты)
		И (Не ПустаяСтрока(Параметры.СерверВходящейПочты) Или Не ПустаяСтрока(Параметры.СерверИсходящейПочты));
КонецФункции

#КонецОбласти

#КонецЕсли