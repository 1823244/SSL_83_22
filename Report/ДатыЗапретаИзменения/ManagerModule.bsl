﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Настройки размещения в панели отчетов.
//
// Параметры:
//   Настройки - Коллекция - Используется для описания настроек отчетов и вариантов
//       см. описание к ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//   НастройкиОтчета - СтрокаДереваЗначений - Настройки размещения всех вариантов отчета.
//       См. "Реквизиты для изменения" функции ВариантыОтчетов.ДеревоНастроекВариантовОтчетовКонфигурации().
//
// Описание:
//   См. ВариантыОтчетовПереопределяемый.НастроитьВариантыОтчетов().
//
// Вспомогательные методы:
//   НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//   ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, НастройкиОтчета, Истина/Ложь); // Отчет
//   поддерживает только этот режим.
//
Процедура НастроитьВариантыОтчета(Настройки, НастройкиОтчета) Экспорт
	МодульВариантыОтчетов = ОбщегоНазначения.ОбщийМодуль("ВариантыОтчетов");
	НастройкиОтчета.Включен = Ложь;
	
	Свойства = ДатыЗапретаИзмененияСлужебныйПовтИсп.СвойстваРазделов();
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоРазделамОбъектамДляПользователей";
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета изменения для пользователей,
			           |сгруппированные по разделам с объектами.'");
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоРазделамДляПользователей";
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета изменения для пользователей,
			           |сгруппированные по разделам.'");
	Иначе
		ИмяВарианта = "ДатыЗапретаИзмененияПоОбъектамДляПользователей";
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета изменения для пользователей,
			           |сгруппированные по объектам.'");
	КонецЕсли;
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ИмяВарианта);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ОписаниеВарианта;
	
	Если Свойства.ПоказыватьРазделы И НЕ Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоПользователям";
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета изменения для разделов с объектами,
			           |сгруппированные по пользователям.'");
		
	ИначеЕсли Свойства.ВсеРазделыБезОбъектов Тогда
		ИмяВарианта = "ДатыЗапретаИзмененияПоПользователямБезОбъектов";
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета изменения для разделов,
			           |сгруппированные по пользователям.'");
	Иначе
		ИмяВарианта = "ДатыЗапретаИзмененияПоПользователямБезРазделов";
		ОписаниеВарианта =
			НСтр("ru = 'Выводит даты запрета изменения для объектов,
			           |сгруппированные по пользователям.'");
	КонецЕсли;
	НастройкиВарианта = МодульВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, ИмяВарианта);
	НастройкиВарианта.Включен  = Истина;
	НастройкиВарианта.Описание = ОписаниеВарианта;
КонецПроцедуры

#КонецОбласти

#КонецЕсли
