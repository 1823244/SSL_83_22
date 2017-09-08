﻿&НаКлиенте
Перем ПеременныеКлиента;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	Если Не УправлениеИтогамиИАгрегатамиСлужебный.НадоСдвинутьГраницуИтогов() Тогда
		Отказ = Истина; // Период уже был установлен в сеансе другого пользователя.
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПеременныеКлиента = Новый Структура;
	ПеременныеКлиента.Вставить("ВремяНачала", ОбщегоНазначенияКлиент.ДатаСеанса());
	ПодключитьОбработчикОжидания("УстановитьПериодРассчитанныхИтогов", 0.1, Истина);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьПериодРассчитанныхИтогов()
	ПараметрыЗадания = ФоновоеЗаданиеЗапустить(УникальныйИдентификатор);
	ПеременныеКлиента.Вставить("ПараметрыЗадания", ПараметрыЗадания);
	Если ПараметрыЗадания.ЗаданиеВыполнено Тогда
		СообщитьРезультатЗакрытьФорму();
	Иначе
		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", ПараметрыЗадания.ТекущийИнтервал, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СообщитьРезультатЗакрытьФорму()
	СкоростьВыполненияВСекундах = ОбщегоНазначенияКлиент.ДатаСеанса() - ПеременныеКлиента.ВремяНачала;
	Если СкоростьВыполненияВСекундах >= 5 Тогда
		Закрыть();
		СтандартныеПодсистемыКлиент.ПоказатьРезультатВыполнения(ЭтотОбъект, ПеременныеКлиента.ПараметрыЗадания.Результат);
	Иначе
		ПодключитьОбработчикОжидания("СообщитьРезультатЗакрытьФорму", 5 - СкоростьВыполненияВСекундах, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ФоновоеЗаданиеПроверитьНаКлиенте()
	ПараметрыЗадания = ПеременныеКлиента.ПараметрыЗадания;
	ФоновоеЗаданиеОбновитьНаСервере(ПараметрыЗадания);
	Если ПараметрыЗадания.ЗаданиеВыполнено Тогда
		СообщитьРезультатЗакрытьФорму();
	Иначе
		ПодключитьОбработчикОжидания("ФоновоеЗаданиеПроверитьНаКлиенте", ПараметрыЗадания.ТекущийИнтервал, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ФоновоеЗаданиеЗапустить(Знач УникальныйИдентификатор)
	ПараметрыЗадания = Новый Структура("ЗаданиеВыполнено, ИдентификаторЗадания, АдресХранилища");
	
	Запуск = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"Обработки.СдвигГраницыИтогов.ВыполнитьКоманду",
		Новый Структура,
		НСтр("ru = 'Итоги и агрегаты: Ускорение проведения документов и формирования отчетов'"));
	ЗаполнитьЗначенияСвойств(ПараметрыЗадания, Запуск);
	
	Если ПараметрыЗадания.ЗаданиеВыполнено Тогда
		ПараметрыЗадания.Вставить("Результат", ПолучитьИзВременногоХранилища(ПараметрыЗадания.АдресХранилища));
	Иначе
		ПараметрыЗадания.Вставить("МинимальныйИнтервал", 1);
		ПараметрыЗадания.Вставить("МаксимальныйИнтервал", 5);
		ПараметрыЗадания.Вставить("ТекущийИнтервал", 1);
		ПараметрыЗадания.Вставить("КоэффициентУвеличенияИнтервала", 1);
	КонецЕсли;
	
	Возврат ПараметрыЗадания;
КонецФункции

&НаСервереБезКонтекста
Процедура ФоновоеЗаданиеОбновитьНаСервере(ПараметрыЗадания)
	ПараметрыЗадания.ЗаданиеВыполнено = ДлительныеОперации.ЗаданиеВыполнено(ПараметрыЗадания.ИдентификаторЗадания);
	Если ПараметрыЗадания.ЗаданиеВыполнено Тогда
		ПараметрыЗадания.Вставить("Результат", ПолучитьИзВременногоХранилища(ПараметрыЗадания.АдресХранилища));
	Иначе
		ПараметрыЗадания.ТекущийИнтервал = ПараметрыЗадания.ТекущийИнтервал * ПараметрыЗадания.КоэффициентУвеличенияИнтервала;
		Если ПараметрыЗадания.ТекущийИнтервал > ПараметрыЗадания.МаксимальныйИнтервал Тогда
			ПараметрыЗадания.ТекущийИнтервал = ПараметрыЗадания.МаксимальныйИнтервал;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти