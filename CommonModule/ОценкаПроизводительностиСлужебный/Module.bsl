﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Оценка производительности".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// См. описание этой же процедуры в модуле СтандартныеПодсистемыСервер.
Процедура ПриДобавленииОбработчиковСлужебныхСобытий(КлиентскиеОбработчики, СерверныеОбработчики) Экспорт
	
	// КЛИЕНТСКИЕ ОБРАБОТЧИКИ.
	
	КлиентскиеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПередЗавершениемРаботыСистемы"].Добавить(
		"ОценкаПроизводительностиКлиент");
	
	// СЕРВЕРНЫЕ ОБРАБОТЧИКИ.
	
	СерверныеОбработчики["СтандартныеПодсистемы.БазоваяФункциональность\ПриДобавленииОбработчиковУстановкиПараметровСеанса"].Добавить(
		"ОценкаПроизводительностиСлужебный");
		
	СерверныеОбработчики[
		"СтандартныеПодсистемы.БазоваяФункциональность\ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам"].Добавить(
			"ОценкаПроизводительностиСлужебный");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем БСП.

// Возвращает соответствие имен параметров сеанса и обработчиков для их инициализации.
//
Процедура ПриДобавленииОбработчиковУстановкиПараметровСеанса(Обработчики) Экспорт
	
	Обработчики.Вставить("ТекущийЗамерВремени", "ОценкаПроизводительностиВызовСервера.УстановкаПараметровСеанса");
	
КонецПроцедуры

// Заполняет перечень запросов внешних разрешений, которые обязательно должны быть предоставлены
// при создании информационной базы или обновлении программы.
//
// Параметры:
//  ЗапросыРазрешений - Массив - список значений, возвращенных функцией.
//                      РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов().
//
Процедура ПриЗаполненииРазрешенийНаДоступКВнешнимРесурсам(ЗапросыРазрешений) Экспорт
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() И ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат;
	КонецЕсли;
	
	КаталогиЭкспорта = КаталогиЭкспортаОценкиПроизводительности();
	Если КаталогиЭкспорта = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтруктураURI = ОбщегоНазначенияКлиентСервер.СтруктураURI(КаталогиЭкспорта.FTPКаталогЭкспорта);
	КаталогиЭкспорта.Вставить("FTPКаталогЭкспорта", СтруктураURI.ИмяСервера);
	Если ЗначениеЗаполнено(СтруктураURI.Порт) Тогда
		КаталогиЭкспорта.Вставить("FTPКаталогЭкспортаПорт", СтруктураURI.Порт);
	КонецЕсли;
	
	ЗапросыРазрешений.Добавить(
		РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
			РазрешенияНаРесурсыСервера(КаталогиЭкспорта), 
				ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ВыполнятьЗамерыПроизводительности")));
	
КонецПроцедуры

// Только для внутреннего использования.
Функция ЗапросНаИспользованиеВнешнихРесурсов(Каталоги) Экспорт
	
	Возврат РаботаВБезопасномРежиме.ЗапросНаИспользованиеВнешнихРесурсов(
				РазрешенияНаРесурсыСервера(Каталоги), 
					ОбщегоНазначения.ИдентификаторОбъектаМетаданных("Константа.ВыполнятьЗамерыПроизводительности"));
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Экспортные служебные процедуры и функции.

// Находит и возвращает регламентное задание экспорта замеров времени.
//
// Возвращаемое значение:
//  РегламентноеЗадание - РегламентноеЗадание.ЭкспортОценкиПроизводительности, найденное задание.
//
Функция РегламентноеЗаданиеЭкспортаОценкиПроизводительности() Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	Задания = РегламентныеЗадания.ПолучитьРегламентныеЗадания(
		Новый Структура("Метаданные", "ЭкспортОценкиПроизводительности"));
	Если Задания.Количество() = 0 Тогда
		Задание = РегламентныеЗадания.СоздатьРегламентноеЗадание(
			Метаданные.РегламентныеЗадания.ЭкспортОценкиПроизводительности);
		Задание.Записать();
		Возврат Задание;
	Иначе
		Возврат Задания[0];
	КонецЕсли;
		
КонецФункции

// Возвращает каталоги экспорта файлов с результатами замеров.
//
// Параметры:
//	Нет
//
// Возвращаемое значение:
//    Структура
//        "ВыполнятьЭкспортНаFTP"              - Булево - Признак выполнения экспорта на FTP
//        "FTPКаталогЭкспорта"                - Строка - FTP-каталог экспорта
//        "ВыполнятьЭкспортВЛокальныйКаталог" - Булево - Признак выполнения экспорта в локальный каталог
//        "ЛокальныйКаталогЭкспорта"          - Строка - Локальный каталог экспорта.
//
Функция КаталогиЭкспортаОценкиПроизводительности() Экспорт
	
	Задание = РегламентноеЗаданиеЭкспортаОценкиПроизводительности();
	Каталоги = Новый Структура;
	Если Задание.Параметры.Количество() > 0 Тогда
		Каталоги = Задание.Параметры[0];
	КонецЕсли;
	
	Если ТипЗнч(Каталоги) <> Тип("Структура") ИЛИ Каталоги.Количество() = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ВозвращаемоеЗначение = Новый Структура;
	ВозвращаемоеЗначение.Вставить("ВыполнятьЭкспортНаFTP");
	ВозвращаемоеЗначение.Вставить("FTPКаталогЭкспорта");
	ВозвращаемоеЗначение.Вставить("ВыполнятьЭкспортВЛокальныйКаталог");
	ВозвращаемоеЗначение.Вставить("ЛокальныйКаталогЭкспорта");
	
	КлючЗаданияВЭлементы = Новый Структура;
	FTPЭлементы = Новый Массив;
	FTPЭлементы.Добавить("ВыполнятьЭкспортНаFTP");
	FTPЭлементы.Добавить("FTPКаталогЭкспорта");
	
	ЛокальныйЭлементы = Новый Массив;
	ЛокальныйЭлементы.Добавить("ВыполнятьЭкспортВЛокальныйКаталог");
	ЛокальныйЭлементы.Добавить("ЛокальныйКаталогЭкспорта");
	
	КлючЗаданияВЭлементы.Вставить(ОценкаПроизводительностиКлиентСервер.FTPКаталогЭкспортаКлючЗадания(), FTPЭлементы);
	КлючЗаданияВЭлементы.Вставить(ОценкаПроизводительностиКлиентСервер.ЛокальныйКаталогЭкспортаКлючЗадания(), ЛокальныйЭлементы);
	ВыполнятьЭкспорт = Ложь;
	Для Каждого ИмяКлючаЭлементы Из КлючЗаданияВЭлементы Цикл
		ИмяКлюча = ИмяКлючаЭлементы.Ключ;
		ЭлементыНаРедактирование = ИмяКлючаЭлементы.Значение;
		НомерЭлемента = 0;
		Для Каждого ЭлементИмя Из ЭлементыНаРедактирование Цикл
			Значение = Каталоги[ИмяКлюча][НомерЭлемента];
			ВозвращаемоеЗначение[ЭлементИмя] = Значение;
			Если НомерЭлемента = 0 Тогда 
				ВыполнятьЭкспорт = ВыполнятьЭкспорт ИЛИ Значение;
			КонецЕсли;
			НомерЭлемента = НомерЭлемента + 1;
		КонецЦикла;
	КонецЦикла;
	
	Возврат ВозвращаемоеЗначение;
	
КонецФункции

// Возвращает ссылку на элемент "Общая производительность",
// Если существует предопределенный элемент "ОбщаяПроизводительностьСистемы", то возвращается этот элемент.
// В противном случае возвращается пустая ссылка.
//
// Параметры:
//	Нет
// Возвращаемое значение:
//	СправочникСсылка.КлючевыеОперации
//
Функция ПолучитьЭлементОбщаяПроизводительностьСистемы() Экспорт
	
	ПредопределенныеКО = Метаданные.Справочники.КлючевыеОперации.ПолучитьИменаПредопределенных();
	ЕстьПредопределенныйЭлемент = ?(ПредопределенныеКО.Найти("ОбщаяПроизводительностьСистемы") <> Неопределено, Истина, Ложь);
	
	ТекстЗапроса = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлючевыеОперации.Ссылка,
	|	2 КАК Приоритет
	|ИЗ
	|	Справочник.КлючевыеОперации КАК КлючевыеОперации
	|ГДЕ
	|	КлючевыеОперации.Имя = ""ОбщаяПроизводительностьСистемы""
	|	И НЕ КлючевыеОперации.ПометкаУдаления
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ЗНАЧЕНИЕ(Справочник.КлючевыеОперации.ПустаяСсылка),
	|	3
	|
	|УПОРЯДОЧИТЬ ПО
	|	Приоритет";
	
	Если ЕстьПредопределенныйЭлемент Тогда
		ТекстЗапроса = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	КлючевыеОперации.Ссылка,
		|	1 КАК Приоритет
		|ИЗ
		|	Справочник.КлючевыеОперации КАК КлючевыеОперации
		|ГДЕ
		|	КлючевыеОперации.ИмяПредопределенныхДанных = ""ОбщаяПроизводительностьСистемы""
		|	И НЕ КлючевыеОперации.ПометкаУдаления
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|" + ТекстЗапроса;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("КлючевыеОперации", ПредопределенныеКО);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	Выборка.Следующий();
	
	Возврат Выборка.Ссылка;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Локальные служебные процедуры и функции.

// Формирует массив разрешений для экспорта данных замеров.
// 
// Параметры - КаталогиЭкспорта - Структура
//
// Возвращаемое значение:
//	Массив
Функция РазрешенияНаРесурсыСервера(Каталоги)
	
	Разрешения = Новый Массив;
	
	Если Каталоги <> Неопределено Тогда
		Если Каталоги.Свойство("ВыполнятьЭкспортВЛокальныйКаталог") И Каталоги.ВыполнятьЭкспортВЛокальныйКаталог = Истина Тогда
			Если Каталоги.Свойство("ЛокальныйКаталогЭкспорта") И ЗначениеЗаполнено(Каталоги.ЛокальныйКаталогЭкспорта) Тогда
				Элемент = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеКаталогаФайловойСистемы(
					Каталоги.ЛокальныйКаталогЭкспорта,
					Истина,
					Истина,
					НСтр("ru = 'Сетевой каталог для экспорта результатов замеров производительности.'"));
				Разрешения.Добавить(Элемент);
			КонецЕсли;
		КонецЕсли;
		
		Если Каталоги.Свойство("ВыполнятьЭкспортНаFTP") И Каталоги.ВыполнятьЭкспортНаFTP = Истина Тогда
			Если Каталоги.Свойство("FTPКаталогЭкспорта") И ЗначениеЗаполнено(Каталоги.FTPКаталогЭкспорта) Тогда
				Элемент = РаботаВБезопасномРежиме.РазрешениеНаИспользованиеИнтернетРесурса(
					"FTP",
					Каталоги.FTPКаталогЭкспорта,
					?(Каталоги.Свойство("FTPКаталогЭкспортаПорт"), Каталоги.FTPКаталогЭкспортаПорт, Неопределено),
					НСтр("ru = 'FTP-ресурс для экспорта результатов замеров производительности.'"));
				Разрешения.Добавить(Элемент);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Разрешения;
КонецФункции

#КонецОбласти
