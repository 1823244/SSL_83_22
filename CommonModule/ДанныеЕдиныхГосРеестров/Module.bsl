﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Работа с контрагентами".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращаются реквизиты юридического лица по данным ЕГРЮЛ (наименование, адрес, коды и т.д.).
//
// Параметры:
//  ИНН  - Строка - ИНН юридического лица, реквизиты которого надо получить.
//
// Возвращаемое значение:
//   Структура   - реквизиты юридического лица. 
//                 Содержание структуры - см. функцию НовыеРеквизитыЮридическогоЛица.
//
Функция РеквизитыЮридическогоЛицаПоИНН(Знач ИНН) Экспорт
	
	РеквизитыЮридическогоЛица = НовыеРеквизитыЮридическогоЛица();
	РеквизитыЮридическогоЛица.ИНН = ИНН;
	
	ОписаниеОшибки = "";
	Прокси = ПроксиСервиса(ОписаниеОшибки);
	Если Прокси <> Неопределено Тогда
		ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(
			Прокси.ФабрикаXDTO.Тип(ПространствоИмен(), "getCorporationRequisitesByINN"));
		ВходныеПараметры.INN = ИНН;
		ВходныеПараметры.configurationName = Метаданные.Имя;
		Попытка
			Ответ = Прокси.getCorporationRequisitesByINN(ВходныеПараметры);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='ИНН %1:'"), ИНН)
				+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
	КонецЕсли;

	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОбработатьОшибкуСервиса(ОписаниеОшибки, РеквизитыЮридическогоЛица);
		Возврат РеквизитыЮридическогоЛица;
	КонецЕсли;
	
	ОбъектXDTO = Ответ.РеквизитыЮрЛица;
	
	ЗаполнитьНаименованияЮридическогоЛица(ОбъектXDTO, РеквизитыЮридическогоЛица);
	
	РеквизитыЮридическогоЛица.РегистрационныйНомер = ОбъектXDTO.ОГРН;
	РеквизитыЮридическогоЛица.КПП = ОбъектXDTO.КПП;
	
	РеквизитыЮридическогоЛица.ДатаРегистрации = ОбъектXDTO.СвНаимЮЛ.ДатаОбрЮЛ;
	
	ЗаполнитьКодОКВЭД(ОбъектXDTO, РеквизитыЮридическогоЛица);
	
	ЗаполнитьРегистрациюВНалоговомОргане(ОбъектXDTO, РеквизитыЮридическогоЛица);
	
	ЗаполнитьРеквизитыПенсионногоФонда(ОбъектXDTO, РеквизитыЮридическогоЛица);
	
	ЗаполнитьРеквизитыФондаСоциальногоСтрахования(ОбъектXDTO, РеквизитыЮридическогоЛица);
	
	ЗаполнитьЮридическийАдрес(ОбъектXDTO, РеквизитыЮридическогоЛица);
	
	ЗаполнитьРуководителяИНомерТелефона(ОбъектXDTO, РеквизитыЮридическогоЛица);
	
	Возврат РеквизитыЮридическогоЛица;
	
КонецФункции

// Возвращаются реквизиты индивидуального предпринимателя по данным ЕГРИП (ФИО, свидетельство о регистрации, коды и
// т.д.).
//
// Параметры:
//  ИНН  - Строка - ИНН индивидуального предпринимателя, реквизиты которого надо получить.
//
// Возвращаемое значение:
//   Структура   - реквизиты индивидуального предпринимателя. 
//                 Содержание структуры - см. функцию НовыеРеквизитыПредпринимателя.
//
Функция РеквизитыПредпринимателяПоИНН(Знач ИНН) Экспорт
	
	РеквизитыПредпринимателя = НовыеРеквизитыПредпринимателя();
	РеквизитыПредпринимателя.ИНН = ИНН;
	
	ОписаниеОшибки = "";
	Прокси = ПроксиСервиса(ОписаниеОшибки);
	Если Прокси <> Неопределено Тогда
		ВходныеПараметры = Прокси.ФабрикаXDTO.Создать(
			Прокси.ФабрикаXDTO.Тип(ПространствоИмен(), "getEntrepreneurRequisitesByINN"));
		ВходныеПараметры.INN = ИНН;
		ВходныеПараметры.configurationName = Метаданные.Имя;
		Попытка
			Ответ = Прокси.getEntrepreneurRequisitesByINN(ВходныеПараметры);
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru='ИНН %1:'"), ИНН)
				+ Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ОписаниеОшибки) Тогда
		ОбработатьОшибкуСервиса(ОписаниеОшибки, РеквизитыПредпринимателя);
		Возврат РеквизитыПредпринимателя;
	КонецЕсли;
	
	ОбъектXDTO = Ответ.РеквизитыИП;
	
	РеквизитыПредпринимателя.Фамилия  = ТРег(ОбъектXDTO.СвФЛ.ФИОРус.Фамилия);
	РеквизитыПредпринимателя.Имя      = ТРег(ОбъектXDTO.СвФЛ.ФИОРус.Имя);
	РеквизитыПредпринимателя.Отчество = ТРег(ОбъектXDTO.СвФЛ.ФИОРус.Отчество);
	РеквизитыПредпринимателя.Пол      = Ответ.РеквизитыИП.СвФЛ.Пол;
	
	ЗаполнитьКодОКВЭД(ОбъектXDTO, РеквизитыПредпринимателя);
	
	ЗаполнитьРегистрациюВНалоговомОргане(ОбъектXDTO, РеквизитыПредпринимателя);
	
	ЗаполнитьРеквизитыПенсионногоФонда(ОбъектXDTO, РеквизитыПредпринимателя);
	
	ЗаполнитьСвидетельствоОРегистрации(ОбъектXDTO, РеквизитыПредпринимателя);
	
	РеквизитыПредпринимателя.Наименование = РеквизитыПредпринимателя.Фамилия 
		+ " " + РеквизитыПредпринимателя.Имя
		+ " " + РеквизитыПредпринимателя.Отчество;
	РеквизитыПредпринимателя.НаименованиеПолное = Ответ.РеквизитыИП.НаимВидИП
		+ " " + РеквизитыПредпринимателя.Фамилия 
		+ " " + РеквизитыПредпринимателя.Имя
		+ " " + РеквизитыПредпринимателя.Отчество;
	РеквизитыПредпринимателя.НаименованиеСокращенное = ?(ОбъектXDTO.КодВидИП = "1", "ИП ", "") 
		+ РеквизитыПредпринимателя.Наименование;
	РеквизитыПредпринимателя.РегистрационныйНомер = ОбъектXDTO.ОГРНИП;
	
	Если ОбъектXDTO.СвГражд <> Неопределено Тогда
		РеквизитыПредпринимателя.КодСтраныГражданства = ОбъектXDTO.СвГражд.ОКСМ;
	КонецЕсли;
	
	Если ОбъектXDTO.СвРегИП <> Неопределено Тогда
		РеквизитыПредпринимателя.ДатаРегистрации = ОбъектXDTO.СвРегИП.ДатаРег;
	КонецЕсли;
	
	Возврат РеквизитыПредпринимателя;
	
КонецФункции

#КонецОбласти

#Область ОписанияРеквизитов

Функция НовыеРеквизитыЮридическогоЛица()

	РеквизитыЮридическогоЛица = Новый Структура;
	
	// Заполняется на основе данных ЕГРЮЛ.
	
	РеквизитыЮридическогоЛица.Вставить("ИНН");                         // Строка, 10
	РеквизитыЮридическогоЛица.Вставить("КПП");                         // Строка, 9
	РеквизитыЮридическогоЛица.Вставить("Наименование");                // Строка, 0
	РеквизитыЮридическогоЛица.Вставить("НаименованиеПолное");          // Строка, 0
	РеквизитыЮридическогоЛица.Вставить("НаименованиеСокращенное");     // Строка, 0
	РеквизитыЮридическогоЛица.Вставить("РегистрационныйНомер");        // Строка, 13 - ОГРН
	// Следующие свойства могут содержать Неопределено в случае отсутствия в сервисе данных.
	РеквизитыЮридическогоЛица.Вставить("ПравоваяФорма");               // Строка, 0
	РеквизитыЮридическогоЛица.Вставить("ЮридическийАдрес");            // Структура из НоваяКонтактнаяИнформация().
	РеквизитыЮридическогоЛица.Вставить("Телефон");                     // Структура из НоваяКонтактнаяИнформация().
	РеквизитыЮридическогоЛица.Вставить("Руководитель");                // Структура из НовоеКонтактноеЛицо().
	РеквизитыЮридическогоЛица.Вставить("РегистрацияВНалоговомОргане"); // Структура из НоваяРегистрацияВНалоговомОргане().
	РеквизитыЮридическогоЛица.Вставить("ДатаРегистрации");             // Дата
	РеквизитыЮридическогоЛица.Вставить("РегистрацияВПенсионномФонде"); // Структура из НоваяРегистрацияВПенсионномФонде().
	РеквизитыЮридическогоЛица.Вставить("РегистрацияВФСС");             // Структура из НоваяРегистрацияВФСС().
	РеквизитыЮридическогоЛица.Вставить("КодОКВЭД");                    // Строка, 8
	
	// Служебный реквизит
	РеквизитыЮридическогоЛица.Вставить("ОписаниеОшибки");              // Строка, 0
	
	Возврат РеквизитыЮридическогоЛица;

КонецФункции 

Функция НовыеРеквизитыПредпринимателя()

	РеквизитыПредпринимателя = Новый Структура;
	
	// Заполняется на основе данных ЕГРИП.
	
	РеквизитыПредпринимателя.Вставить("ИНН");                         // Строка, 12
	РеквизитыПредпринимателя.Вставить("Наименование");                // Строка, 0
	РеквизитыПредпринимателя.Вставить("НаименованиеПолное");          // Строка, 0
	РеквизитыПредпринимателя.Вставить("НаименованиеСокращенное");     // Строка, 0
	РеквизитыПредпринимателя.Вставить("Фамилия");                     // Строка, 0
	РеквизитыПредпринимателя.Вставить("Имя");                         // Строка, 0
	РеквизитыПредпринимателя.Вставить("Отчество");                    // Строка, 0
	РеквизитыПредпринимателя.Вставить("РегистрационныйНомер");        // Строка, 13 - ОГРН
	// Следующие свойства могут содержать Неопределено в случае отсутствия в сервисе данных.
	РеквизитыПредпринимателя.Вставить("Пол");                         // Строка: "1" - Мужской, "2" - Женский.
	РеквизитыПредпринимателя.Вставить("КодСтраныГражданства");        // Строка, 3
	РеквизитыПредпринимателя.Вставить("РегистрацияВНалоговомОргане"); // Структура из НоваяРегистрацияВНалоговомОргане().
	РеквизитыПредпринимателя.Вставить("РегистрацияВПенсионномФонде"); // Структура из НоваяРегистрацияВПенсионномФонде().
	РеквизитыПредпринимателя.Вставить("РегистрацияВФСС");             // Структура из НоваяРегистрацияВФСС().
	РеквизитыПредпринимателя.Вставить("ДатаРегистрации");             // Дата
	РеквизитыПредпринимателя.Вставить("КодОКВЭД");                    // Строка, 8
	РеквизитыПредпринимателя.Вставить("СвидетельствоОРегистрации");   // Структура из НовоеСвидетельствоОРегистрации().
	
	// Служебный реквизит
	РеквизитыПредпринимателя.Вставить("ОписаниеОшибки");       // Строка, 0
	
	Возврат РеквизитыПредпринимателя;

КонецФункции 

Функция НоваяКонтактнаяИнформация()

	Результат = Новый Структура;
	Результат.Вставить("КонтактнаяИнформация"); // Строка, 0 - XML 
	Результат.Вставить("Представление");        // Строка, 0
	Результат.Вставить("Комментарий");          // Строка, 0
	Возврат Результат;

КонецФункции

Функция НовоеКонтактноеЛицо()

	Результат = Новый Структура;
	Результат.Вставить("Должность"); // Строка, 0
	Результат.Вставить("Фамилия");   // Строка, 0
	Результат.Вставить("Имя");       // Строка, 0
	Результат.Вставить("Отчество");  // Строка, 0
	Результат.Вставить("ИНН");       // Строка, 12
	Возврат Результат;

КонецФункции

Функция НоваяРегистрацияВНалоговомОргане()
	
	Результат = Новый Структура;
	Результат.Вставить("Код");          // Строка, 4
	Результат.Вставить("Наименование"); // Строка, 0
	Результат.Вставить("ОКТМО");        // Строка, 11
	Результат.Вставить("ОКАТО");        // Строка, 11
	Возврат Результат;
	
КонецФункции

Функция НоваяРегистрацияВПенсионномФонде()
	
	Результат = Новый Структура;
	Результат.Вставить("РегистрационныйНомерПФР"); // Строка, 14
	Результат.Вставить("КодОрганаПФР");            // Строка, 7
	Результат.Вставить("НаименованиеОрганаПФР");   // Строка, 0
	Возврат Результат;
	
КонецФункции

Функция НоваяРегистрацияВФСС()
	
	Результат = Новый Структура;
	Результат.Вставить("РегистрационныйНомерФСС"); // Строка, 15
	Результат.Вставить("КодПодчиненности");        // Строка, 5
	Результат.Вставить("КодОрганаФСС");            // Строка, 4
	Результат.Вставить("НаименованиеОрганаФСС");   // Строка, 0
	Возврат Результат;
	
КонецФункции

Функция НовоеСвидетельствоОРегистрации()
	
	Результат = Новый Структура;
	Результат.Вставить("Серия");  // Строка, 0
	Результат.Вставить("Номер");  // Строка, 0
	Результат.Вставить("Дата");   // Дата
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьНаименованияЮридическогоЛица(ОбъектXDTO, Реквизиты)

	ПравовыеФормы = Новый Массив;
	ПравовыеФормы.Добавить("Общество с ограниченной ответственностью");
	ПравовыеФормы.Добавить("Закрытое акционерное общество");
	ПравовыеФормы.Добавить("Открытое акционерное общество");
	ПравовыеФормы.Добавить("Публичное акционерное общество");
	ПравовыеФормы.Добавить("Акционерное общество");
	Если ОбъектXDTO.СвНаимЮЛ.ОПФ <> Неопределено Тогда
		ПравоваяФормаОбъекта = Строка(ОбъектXDTO.СвНаимЮЛ.ОПФ.ПолнНаимОПФ);
		Реквизиты.ПравоваяФорма = ПравоваяФормаОбъекта;
		Если ПравовыеФормы.Найти(ПравоваяФормаОбъекта) = Неопределено Тогда
			ПравовыеФормы.Добавить(ПравоваяФормаОбъекта);
		КонецЕсли;
	КонецЕсли;
	
	Реквизиты.НаименованиеПолное = ОбъектXDTO.СвНаимЮЛ.НаимЮЛПолн;
	Для каждого ПравоваяФорма Из ПравовыеФормы Цикл
		Если ВРег(ПравоваяФорма) = ВРег(Лев(Реквизиты.НаименованиеПолное, СтрДлина(ПравоваяФорма))) Тогда
			Реквизиты.НаименованиеПолное = ПравоваяФорма + Сред(Реквизиты.НаименованиеПолное, СтрДлина(ПравоваяФорма) + 1);
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Реквизиты.НаименованиеСокращенное = ОбъектXDTO.СвНаимЮЛ.НаимЮЛСокр;
	Если НЕ ЗначениеЗаполнено(Реквизиты.НаименованиеСокращенное) 
		ИЛИ Реквизиты.НаименованиеСокращенное = "-" Тогда
		Реквизиты.НаименованиеСокращенное = Реквизиты.НаименованиеПолное;
	КонецЕсли;
	
	Реквизиты.Наименование = Реквизиты.НаименованиеСокращенное;
	Поз = Найти(Реквизиты.Наименование, """");
	Если Поз > 0 И Поз <= 10 Тогда
		Реквизиты.Наименование = СокрП(Сред(Реквизиты.Наименование, Поз)) + " " + СокрП(Лев(Реквизиты.Наименование, Поз-1));
		Реквизиты.Наименование = СтрЗаменить(Реквизиты.Наименование, """", "");
	КонецЕсли;

КонецПроцедуры

Процедура ЗаполнитьОбъектXDTOКонтактнойИнформации(Фабрика, Объект, ИсходныйОбъект)
	
	Для каждого СвойствоИсходногоОбъекта Из ИсходныйОбъект.Свойства() Цикл
		
		СвойствоОбъекта = Объект.Свойства().Получить(СвойствоИсходногоОбъекта.Имя);
		Если СвойствоОбъекта <> Неопределено Тогда
			
			ЗначениеСвойства = ИсходныйОбъект[СвойствоИсходногоОбъекта.Имя];
			Если ЗначениеСвойства = Неопределено Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТипЗнч(ЗначениеСвойства) = Тип("ОбъектXDTO") Тогда
				
				Объект[СвойствоОбъекта.Имя] = Фабрика.Создать(СвойствоОбъекта.Тип);
				ЗаполнитьОбъектXDTOКонтактнойИнформации(Фабрика, Объект[СвойствоОбъекта.Имя], ИсходныйОбъект[СвойствоИсходногоОбъекта.Имя]);
				
			ИначеЕсли ТипЗнч(ЗначениеСвойства) = Тип("СписокXDTO") Тогда
				
				Для Каждого ИсходныйЭлемент Из ЗначениеСвойства Цикл
					
					Элемент = Фабрика.Создать(СвойствоОбъекта.Тип);
					ЗаполнитьОбъектXDTOКонтактнойИнформации(Фабрика, Элемент, ИсходныйЭлемент);
					Объект[СвойствоОбъекта.Имя].Добавить(Элемент);
					
				КонецЦикла;
				
			ИначеЕсли ТипЗнч(ЗначениеСвойства) = Тип("Строка") Тогда
				
				МассивСлов      = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивСлов(ЗначениеСвойства, " ");
				МаксИндексСлова = ?(МассивСлов.Количество() = 1, 0, МассивСлов.Количество() - 2);
				Для ИндексСлова = 0 По МаксИндексСлова Цикл
					МассивСлов[ИндексСлова] = ТРег(МассивСлов[ИндексСлова]);
				КонецЦикла;
				Объект[СвойствоОбъекта.Имя] = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(МассивСлов, " ");
				
			Иначе
				
				Объект[СвойствоОбъекта.Имя] = ЗначениеСвойства;
				
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ЗаполнитьРегистрациюВНалоговомОргане(ОбъектXDTO, Реквизиты)
	
	Если ОбъектXDTO.СвУчетНО <> Неопределено
		И ОбъектXDTO.СвУчетНО.СвНО <> Неопределено Тогда
		
		Реквизиты.РегистрацияВНалоговомОргане = НоваяРегистрацияВНалоговомОргане();
		
		Реквизиты.РегистрацияВНалоговомОргане.Код          = ОбъектXDTO.СвУчетНО.СвНО.КодНО;
		Реквизиты.РегистрацияВНалоговомОргане.Наименование = ОбъектXDTO.СвУчетНО.СвНО.НаимНО;
		
		Если ОбъектXDTO.Свойства().Получить("СвАдрес") <> Неопределено // Адрес есть только у юридических лиц
			И ОбъектXDTO.СвАдрес <> Неопределено 
			И ОбъектXDTO.СвАдрес.Адрес <> Неопределено Тогда
			
			Адрес = ОбъектXDTO.СвАдрес.Адрес;
			Реквизиты.РегистрацияВНалоговомОргане.ОКТМО = Адрес.Состав.ОКТМО;
			Реквизиты.РегистрацияВНалоговомОргане.ОКАТО = Адрес.Состав.ОКАТО;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьКодОКВЭД(ОбъектXDTO, Реквизиты)
	
	Если ОбъектXDTO.СвОКВЭД <> Неопределено Тогда
		
		СписокОКВЭД = ОбъектXDTO.СвОКВЭД;
		КодОКВЭД  = "";
		ДатаОКВЭД = '00010101';
		Для Каждого ЭлементОКВЭД Из СписокОКВЭД Цикл
			Если ЭлементОКВЭД.ДатаНачДейств > ДатаОКВЭД
				И ЭлементОКВЭД.ПрОснДоп = "1" Тогда
				ДатаОКВЭД = ЭлементОКВЭД.ДатаНачДейств;
				КодОКВЭД  = ЭлементОКВЭД.КодОКВЭД;
			КонецЕсли;
		КонецЦикла;
		Реквизиты.КодОКВЭД = КодОКВЭД;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыПенсионногоФонда(ОбъектXDTO, Реквизиты)
	
	Если ОбъектXDTO.СвРегПФ <> Неопределено Тогда
		
		РегистрацияВПФР = НоваяРегистрацияВПенсионномФонде();
		
		РегистрационныйНомерПФР = ОбъектXDTO.СвРегПФ.РегНомПФ;
		РегистрационныйНомерПФР = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1-%2-%3'"), 
					Лев(РегистрационныйНомерПФР, 3), Сред(РегистрационныйНомерПФР,4, 3), Прав(РегистрационныйНомерПФР, 6));
		РегистрацияВПФР.РегистрационныйНомерПФР = РегистрационныйНомерПФР;
		Если ОбъектXDTO.СвРегПФ.СвОргПФ <> Неопределено Тогда
			КодОрганаПФР = ОбъектXDTO.СвРегПФ.СвОргПФ.КодПФ;
			КодОрганаПФР = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='%1-%2'"), 
				Лев(КодОрганаПФР, 3), Прав(КодОрганаПФР, 3));
			РегистрацияВПФР.КодОрганаПФР          = КодОрганаПФР;
			РегистрацияВПФР.НаименованиеОрганаПФР = ОбъектXDTO.СвРегПФ.СвОргПФ.НаимПФ;
		КонецЕсли;
		
		Реквизиты.РегистрацияВПенсионномФонде = РегистрацияВПФР;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРеквизитыФондаСоциальногоСтрахования(ОбъектXDTO, Реквизиты)
	
	Если ОбъектXDTO.СвРегФСС <> Неопределено Тогда
		
		РегистрацияВФСС = НоваяРегистрацияВФСС();
		
		Если СтрДлина(ОбъектXDTO.СвРегФСС.РегНомФСС) <= 10 Тогда
			РегистрацияВФСС.РегистрационныйНомерФСС = СокрЛП(ОбъектXDTO.СвРегФСС.РегНомФСС);
			РегистрацияВФСС.КодПодчиненности        = "";
		Иначе
			РегистрацияВФСС.РегистрационныйНомерФСС = СокрЛП(Лев(ОбъектXDTO.СвРегФСС.РегНомФСС, 10));
			РегистрацияВФСС.КодПодчиненности        = СокрЛП(Сред(ОбъектXDTO.СвРегФСС.РегНомФСС, 11));
			Если СтрДлина(РегистрацияВФСС.КодПодчиненности) <> 5 Тогда
				РегистрацияВФСС.КодПодчиненности = "";
			КонецЕсли;
		КонецЕсли;
		
		Если ОбъектXDTO.СвРегФСС.СвОргФСС <> Неопределено Тогда
			РегистрацияВФСС.КодОрганаФСС            = ОбъектXDTO.СвРегФСС.СвОргФСС.КодФСС;
			РегистрацияВФСС.НаименованиеОрганаФСС   = ОбъектXDTO.СвРегФСС.СвОргФСС.НаимФСС;
		КонецЕсли;
		
		Реквизиты.РегистрацияВФСС = РегистрацияВФСС;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьСвидетельствоОРегистрации(ОбъектXDTO, Реквизиты)
	
	Если ОбъектXDTO.СвЗапДейств <> Неопределено Тогда
		
		Свидетельство = НовоеСвидетельствоОРегистрации();
		Свидетельство.Дата = '00010101';
		Для Каждого Запись Из ОбъектXDTO.СвЗапДейств Цикл
			Для Каждого ЗаписьСвидетельства Из Запись.СвСвид Цикл
				Если ЗначениеЗаполнено(ЗаписьСвидетельства.ДатаЗап) Тогда
					ДатаЗап = ЗаписьСвидетельства.ДатаЗап;
				ИначеЕсли ЗначениеЗаполнено(Запись.ДатаЗап) Тогда
					ДатаЗап = Запись.ДатаЗап;
				Иначе
					ДатаЗап = '00010101';
				КонецЕсли;
				Если ДатаЗап > Свидетельство.Дата Тогда
					Свидетельство.Дата  = ДатаЗап;
					Свидетельство.Серия = ЗаписьСвидетельства.Серия;
					Свидетельство.Номер = Прав("000000000" + ЗаписьСвидетельства.Номер, 9);
				КонецЕсли;
			КонецЦикла;
		КонецЦикла;
		
		Если Свидетельство.Дата > '00010101' Тогда
			Реквизиты.СвидетельствоОРегистрации = Свидетельство;
		КонецЕсли
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьЮридическийАдрес(ОбъектXDTO, Реквизиты)
	
	ПространствоИменКИ = УправлениеКонтактнойИнформациейКлиентСерверПовтИсп.ПространствоИмен();
	
	Если ОбъектXDTO.СвАдрес <> Неопределено 
		И ОбъектXDTO.СвАдрес.Адрес <> Неопределено Тогда
		
		АдресРФ_КИ         = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИменКИ, "АдресРФ"));
		ЗаполнитьОбъектXDTOКонтактнойИнформации(ФабрикаXDTO, АдресРФ_КИ, ОбъектXDTO.СвАдрес.Адрес.Состав);
		
		КИ = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИменКИ, "КонтактнаяИнформация"));
		КИ.Состав        = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИменКИ, "Адрес"));
		КИ.Состав.Страна = ОбъектXDTO.СвАдрес.Адрес.Страна;
		КИ.Состав.Состав = АдресРФ_КИ;
		КИ.Представление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(КИ,
			Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес));
		
		СтруктураКИ = НоваяКонтактнаяИнформация();
		СтруктураКИ.КонтактнаяИнформация = СериализацияОбъектаXDTO(КИ);
		СтруктураКИ.Представление  = КИ.Представление;
		
		Реквизиты.ЮридическийАдрес = СтруктураКИ;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗаполнитьРуководителяИНомерТелефона(ОбъектXDTO, Реквизиты)
	
	ПространствоИменКИ = УправлениеКонтактнойИнформациейКлиентСерверПовтИсп.ПространствоИмен();
	
	Если ОбъектXDTO.СвУправлДеят <> Неопределено
		И ОбъектXDTO.СвУправлДеят.СведДолжнФЛ <> Неопределено Тогда
		
		Для каждого СведенияОДолжности Из ОбъектXDTO.СвУправлДеят.СведДолжнФЛ Цикл
			Если Найти(СведенияОДолжности.НаимВидДолжн, "Руководитель") > 0 
				И СведенияОДолжности.ФИО <> Неопределено Тогда
				
				// Руководитель
				СтруктураКИ = НовоеКонтактноеЛицо();
				СтруктураКИ.Фамилия    = ТРег(СведенияОДолжности.ФИО.Фамилия);
				СтруктураКИ.Имя        = ТРег(СведенияОДолжности.ФИО.Имя);
				СтруктураКИ.Отчество   = ТРег(СведенияОДолжности.ФИО.Отчество);
				СтруктураКИ.Должность  = ПредложениеСЗаглавнойБуквы(СведенияОДолжности.НаимДолжн);
				СтруктураКИ.ИНН        = СведенияОДолжности.ИННФЛ;
				
				Реквизиты.Руководитель = СтруктураКИ;
				
				// Номер телефона
				Если ЗначениеЗаполнено(СведенияОДолжности.НомТел) Тогда
					КИ = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИменКИ, "КонтактнаяИнформация"));
					КИ.Состав = ФабрикаXDTO.Создать(ФабрикаXDTO.Тип(ПространствоИменКИ, "НомерТелефона"));
					Если Лев(СведенияОДолжности.НомТел, 1) = "(" Тогда
						КонецКодаГорода     = Найти(СведенияОДолжности.НомТел, ")");
						КИ.Состав.КодГорода = Сред(СведенияОДолжности.НомТел, 2, КонецКодаГорода - 2);
						КИ.Состав.Номер     = Сред(СведенияОДолжности.НомТел, КонецКодаГорода + 1);
					Иначе
						КИ.Состав.Номер     = СведенияОДолжности.НомТел;
					КонецЕсли;
					КИ.Представление = УправлениеКонтактнойИнформацией.ПредставлениеКонтактнойИнформации(КИ,
						Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Телефон));
					СтруктураКИ = НоваяКонтактнаяИнформация();
					СтруктураКИ.КонтактнаяИнформация = СериализацияОбъектаXDTO(КИ);
					СтруктураКИ.Представление = КИ.Представление;
					
					Реквизиты.Телефон = СтруктураКИ;
					
				КонецЕсли;
				Прервать;
				
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

Функция ПредложениеСЗаглавнойБуквы(Строка)
	
	Если ЗначениеЗаполнено(Строка) Тогда
		Возврат ВРег(Лев(Строка, 1)) + НРег(Сред(Строка, 2))
	Иначе
		Возврат Строка;
	КонецЕсли;
	
КонецФункции

Функция ПроксиСервиса(ОписаниеОшибки)
	
	Прокси = Неопределено;
	ПараметрыАутентификации = ПараметрыАутентификацииВСервисе();
	
	Если ПараметрыАутентификации = Неопределено Тогда
		
		// Служебный текст. Должен быть обработан на клиенте.
		ОписаниеОшибки = "НеУказаныПараметрыАутентификации"; 
		
	Иначе
		
		Попытка
			Прокси = ОбщегоНазначения.WSПрокси(
				АдресСервиса(),                            // АдресWSDL
				ПространствоИмен(),                        // URIПространстваИмен
				"RequisitesWebServiceEndpointImplService", // ИмяСервиса
				"RequisitesWebServiceEndpointImplPort",    // ИмяТочкиПодключения
				ПараметрыАутентификации.login,             // ИмяПользователя
				ПараметрыАутентификации.password,          // Пароль
				30);                                       // Таймаут
		Исключение
			ИнформацияОбОшибке = ИнформацияОбОшибке();
			ОписаниеОшибки = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке);
		КонецПопытки; 
		
	КонецЕсли;
	
	Возврат Прокси;
	
КонецФункции

Функция ПараметрыАутентификацииВСервисе()
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		Возврат Новый Структура("login,password", 
			"fresh", "fresh");
				
	Иначе
		ДанныеАутентификации = СтандартныеПодсистемыСервер.ПараметрыАутентификацииНаСайте();
		Если ДанныеАутентификации <> Неопределено Тогда
			Возврат Новый Структура("login,password", 
				ДанныеАутентификации.Логин, 
				ДанныеАутентификации.Пароль);
		Иначе
			Возврат Неопределено;
		КонецЕсли;
		
	КонецЕсли;
	
КонецФункции

Функция АдресСервиса()

	Возврат "https://api.orgregister.1c.ru/orgregister/v1?wsdl";

КонецФункции

Функция ПространствоИмен()

	Возврат "http://ws.orgregister.company1c.com/";

КонецФункции

Процедура ОбработатьОшибкуСервиса(ОписаниеОшибки, СтруктураРеквизитов)
	
	КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(); // Для записи события в журнал регистрации.
	
	Если ОписаниеОшибки = "НеУказаныПараметрыАутентификации" Тогда
		ТекстОшибки    = "НеУказаныПараметрыАутентификации"; // Служебный текст. Должен быть обработан на клиенте.
		ОписаниеОшибки = НСтр("ru='Не указаны логин и пароль для доступа к Интернет-поддержке'");
		ТекстСобытия   = НСтр("ru='Ошибка доступа'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, """status"":401") > 0 Тогда
		ТекстОшибки  = НСтр("ru='Неверно указаны логин и пароль для доступа к Интернет-поддержке'");
		ТекстСобытия = НСтр("ru='Ошибка доступа'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-1:") > 0 Тогда
		ТекстОшибки  = НСтр("ru='Не указан ИНН юридического лица'");
		ТекстСобытия = НСтр("ru='Ошибка получения данных'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-2:") > 0 Тогда
		ТекстОшибки  = НСтр("ru='ИНН юридического лица должен состоять из 10 цифр'");
		ТекстСобытия = НСтр("ru='Ошибка получения данных'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-3:") > 0 Тогда
		ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось найти данные для заполнения реквизитов по ИНН %1'"),
			СтруктураРеквизитов.ИНН);
		ТекстСобытия = НСтр("ru='Ошибка получения данных'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-4:") > 0 Тогда
		ТекстОшибки  = НСтр("ru='Не указан ИНН предпринимателя'");
		ТекстСобытия = НСтр("ru='Ошибка получения данных'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-5:") > 0 Тогда
		ТекстОшибки  = НСтр("ru='ИНН предпринимателя должен состоять из 12 цифр'");
		ТекстСобытия = НСтр("ru='Ошибка получения данных'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-6:") > 0 Тогда
		ТекстОшибки  = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru='Не удалось найти данные для заполнения реквизитов по ИНН %1'"),
			СтруктураРеквизитов.ИНН);
		ТекстСобытия = НСтр("ru='Ошибка получения данных'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-7:") > 0 Тогда
		ТекстОшибки  = НСтр("ru='Превышен лимит количества вызовов сервиса за один день'");
		ТекстСобытия = НСтр("ru='Ошибка доступа'", КодОсновногоЯзыка);
		
	ИначеЕсли Найти(ОписаниеОшибки, "SERVER-8:") > 0 Тогда
		ТекстОшибки  = НСтр("ru='Отсутствует действующий договор ИТС'");
		ТекстСобытия = НСтр("ru='Ошибка доступа'", КодОсновногоЯзыка);
		
	Иначе
		ТекстОшибки  = НСтр("ru='Ошибка при работе с сервисом (подробнее см. Журнал регистрации)'");
		ТекстСобытия = НСтр("ru='Ошибка при работе с сервисом'", КодОсновногоЯзыка);
	КонецЕсли;
	
	СтруктураРеквизитов.ОписаниеОшибки = ТекстОшибки;
	
	ИмяСобытия = НСтр("ru = 'Сервис данных единых гос_реестров.'", КодОсновногоЯзыка) + " " + ТекстСобытия;
	ЗаписьЖурналаРегистрации(ИмяСобытия, УровеньЖурналаРегистрации.Ошибка, , , ОписаниеОшибки);
	
КонецПроцедуры

Функция СериализацияОбъектаXDTO(ОбъектXDTO) Экспорт
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку(Новый ПараметрыЗаписиXML(, , Ложь, Ложь, ""));
	Если ОбъектXDTO <> Неопределено Тогда
		ФабрикаXDTO.ЗаписатьXML(Запись, ОбъектXDTO);
	КонецЕсли;
	
	Возврат СтрЗаменить(Запись.Закрыть(), Символы.ПС, "&#10;");
	
КонецФункции

#КонецОбласти
