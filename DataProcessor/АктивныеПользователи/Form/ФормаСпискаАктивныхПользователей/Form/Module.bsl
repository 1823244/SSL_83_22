﻿&НаКлиенте
Перем ПараметрыАдминистрирования, ЗапрашиватьПараметрыАдминистрированияИБ;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Не Параметры.Свойство("ОшибкаУстановкиМонопольногоРежима") И Не ОбщегоНазначения.ПриСозданииНаСервере(ЭтотОбъект, Отказ, СтандартнаяОбработка) Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("ОповещатьОЗакрытии", ОповещатьОЗакрытии);
	
	НомерСеансаИнформационнойБазы = НомерСеансаИнформационнойБазы();
	УсловноеОформление.Элементы[0].Отбор.Элементы[0].ПравоеЗначение = НомерСеансаИнформационнойБазы;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая()
		Или Не ((Не ОбщегоНазначенияПовтИсп.СеансЗапущенБезРазделителей() И Пользователи.ЭтоПолноправныйПользователь())
		Или Пользователи.ЭтоПолноправныйПользователь(, Истина)) Тогда
		
		Элементы.ЗавершитьСеанс.Видимость = Ложь;
		Элементы.ЗавершитьСеансКонтекст.Видимость = Ложь;
		
	КонецЕсли;
	
	Если ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Элементы.СписокПользователейРазделениеДанных.Видимость = Ложь;
	КонецЕсли;
	
	ИмяКолонкиСортировки = "НачалоРаботы";
	НаправлениеСортировки = "Возр";
	
	ЗаполнитьСписокВыбораФильтраСоединений();
	Если Параметры.Свойство("ОтборИмяПриложения") Тогда
		Если Элементы.ОтборИмяПриложения.СписокВыбора.НайтиПоЗначению(Параметры.ОтборИмяПриложения) <> Неопределено Тогда
			ОтборИмяПриложения = Параметры.ОтборИмяПриложения;
		КонецЕсли;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЗапрашиватьПараметрыАдминистрированияИБ = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Если ОповещатьОЗакрытии Тогда
		ОповещатьОЗакрытии = Ложь;
		ОповеститьОВыборе(Неопределено);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборИмяПриложенияПриИзменении(Элемент)
	ЗаполнитьСписок();
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ТАБЛИЦЫ СписокПользователей

&НаКлиенте
Процедура СписокПользователейВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОткрытьПользователяИзСписка();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗавершитьСеанс(Команда)
	
	КоличествоВыделенныхСтрок = Элементы.СписокПользователей.ВыделенныеСтроки.Количество();
	
	Если КоличествоВыделенныхСтрок = 0 Тогда
		
		ПоказатьПредупреждение(,НСтр("ru = 'Не выбраны пользователи для завершения сеансов.'"));
		Возврат;
		
	КонецЕсли;
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Если ПараметрыРаботыКлиента.РазделениеВключено И ПараметрыРаботыКлиента.ДоступноИспользованиеРазделенныхДанных Тогда
		
		ЗавершаемыйСеанс = Элементы.СписокПользователей.ТекущиеДанные.Сеанс;
		
		Если ЗавершаемыйСеанс = НомерСеансаИнформационнойБазы Тогда
			ПоказатьПредупреждение(,НСтр("ru = 'Невозможно завершить текущий сеанс. Для выхода из программы можно закрыть главное окно программы.'"));
			Возврат;
		КонецЕсли;
		
		СтандартнаяОбработка = Истина;
		ОповещениеПослеЗавершенияСеанса = Новый ОписаниеОповещения(
		"ПослеЗавершенияСеанса", ЭтотОбъект, Новый Структура("НомерСеанса", ЗавершаемыйСеанс));
		
		ОбработчикиСобытия = ОбщегоНазначенияКлиент.ОбработчикиСлужебногоСобытия(
			"СтандартныеПодсистемы.ЗавершениеРаботыПользователей\ПриЗавершенииСеанса");
		
		Для Каждого Обработчик Из ОбработчикиСобытия Цикл
			Обработчик.Модуль.ПриЗавершенииСеанса(ЭтотОбъект, ЗавершаемыйСеанс, СтандартнаяОбработка, ОповещениеПослеЗавершенияСеанса);
		КонецЦикла;
		
	Иначе
		
		КоличествоВыделенныхСтрок = Элементы.СписокПользователей.ВыделенныеСтроки.Количество();
		
		Если КоличествоВыделенныхСтрок = 1 Тогда
			
			Если Элементы.СписокПользователей.ТекущиеДанные.Сеанс = НомерСеансаИнформационнойБазы Тогда
				ПоказатьПредупреждение(,НСтр("ru = 'Невозможно завершить текущий сеанс. Для выхода из программы можно закрыть главное окно программы.'"));
				Возврат;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗапрашиватьПараметрыАдминистрированияИБ Тогда
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ЗавершитьСеансПродолжение", ЭтотОбъект);
			ЗаголовокФормы = Нстр("ru = 'Завершение сеанса'");
			ПоясняющаяНадпись = Нстр("ru = 'Для завершения сеанса необходимо ввести параметры
				|администрирования кластера серверов'");
			СоединенияИБКлиент.ПоказатьПараметрыАдминистрирования(ОписаниеОповещения, Ложь, Истина, ПараметрыАдминистрирования, ЗаголовокФормы, ПоясняющаяНадпись);
			
		Иначе
			
			ЗавершитьСеансПродолжение(ПараметрыАдминистрирования);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьВыполнить()
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьЖурналРегистрации()
	
	ВыделенныеСтроки = Элементы.СписокПользователей.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ПоказатьПредупреждение(,НСтр("ru = 'Выберите пользователей для просмотра журнала регистрации.'"));
		Возврат;
	КонецЕсли;
	
	ОтборПоПользователям = Новый СписокЗначений;
	Для Каждого ИдентификаторСтроки Из ВыделенныеСтроки Цикл
		СтрокаПользователя = СписокПользователей.НайтиПоИдентификатору(ИдентификаторСтроки);
		ИмяПользователя = СтрокаПользователя.ИмяПользователя;
		Если ОтборПоПользователям.НайтиПоЗначению(ИмяПользователя) = Неопределено Тогда
			ОтборПоПользователям.Добавить(СтрокаПользователя.ИмяПользователя, СтрокаПользователя.ИмяПользователя);
		КонецЕсли;
	КонецЦикла;
	
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма", Новый Структура("Пользователь", ОтборПоПользователям));
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоВозрастанию()
	
	СортировкаПоКолонке("Возр");
	
КонецПроцедуры

&НаКлиенте
Процедура СортироватьПоУбыванию()
	
	СортировкаПоКолонке("Убыв");
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьПользователя(Команда)
	ОткрытьПользователяИзСписка();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	//

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.СписокПользователей.Имя);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СписокПользователей.Сеанс");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = 0;

	Элемент.Оформление.УстановитьЗначениеПараметра("Шрифт", Новый Шрифт(WindowsШрифты.ШрифтДиалоговИМеню, , , Истина, Ложь, Ложь, Ложь, ));

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьСписок()
	
	// Для восстановления позиции запомним текущий сеанс.
	ТекущийСеанс = Неопределено;
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	
	Если ТекущиеДанные <> Неопределено Тогда
		ТекущийСеанс = ТекущиеДанные.Сеанс;
	КонецЕсли;
	
	ЗаполнитьСписокПользователей();
	
	// Восстанавливаем текущую строку по сохраненному сеансу.
	Если ТекущийСеанс <> Неопределено Тогда
		СтруктураПоиска = Новый Структура;
		СтруктураПоиска.Вставить("Сеанс", ТекущийСеанс);
		НайденныеСеансы = СписокПользователей.НайтиСтроки(СтруктураПоиска);
		Если НайденныеСеансы.Количество() = 1 Тогда
			Элементы.СписокПользователей.ТекущаяСтрока = НайденныеСеансы[0].ПолучитьИдентификатор();
			Элементы.СписокПользователей.ВыделенныеСтроки.Очистить();
			Элементы.СписокПользователей.ВыделенныеСтроки.Добавить(Элементы.СписокПользователей.ТекущаяСтрока);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СортировкаПоКолонке(Направление)
	
	Колонка = Элементы.СписокПользователей.ТекущийЭлемент;
	Если Колонка = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяКолонкиСортировки = Колонка.Имя;
	НаправлениеСортировки = Направление;
	
	ЗаполнитьСписок();
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокВыбораФильтраСоединений()
	ИменаПриложений = Новый Массив;
	ИменаПриложений.Добавить("1CV8");
	ИменаПриложений.Добавить("1CV8C");
	ИменаПриложений.Добавить("WebClient");
	ИменаПриложений.Добавить("Designer");
	ИменаПриложений.Добавить("COMConnection");
	ИменаПриложений.Добавить("WSConnection");
	ИменаПриложений.Добавить("BackgroundJob");
	ИменаПриложений.Добавить("SystemBackgroundJob");
	ИменаПриложений.Добавить("SrvrConsole");
	ИменаПриложений.Добавить("COMConsole");
	ИменаПриложений.Добавить("JobScheduler");
	ИменаПриложений.Добавить("Debugger");
	ИменаПриложений.Добавить("OpenIDProvider");
	ИменаПриложений.Добавить("RAS");
	
	СписокВыбора = Элементы.ОтборИмяПриложения.СписокВыбора;
	Для Каждого ИмяПриложения Из ИменаПриложений Цикл
		СписокВыбора.Добавить(ИмяПриложения, ПредставлениеПриложения(ИмяПриложения));
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьСписокПользователей()
	
	СписокПользователей.Очистить();
	
	Если НЕ ОбщегоНазначенияПовтИсп.РазделениеВключено()
	 ИЛИ ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Пользователи.НайтиНеоднозначныхПользователейИБ(,);
	КонецЕсли;
	
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	КоличествоАктивныхПользователей = СеансыИнформационнойБазы.Количество();
	
	ФильтроватьИменаПриложений = ЗначениеЗаполнено(ОтборИмяПриложения);
	Если ФильтроватьИменаПриложений Тогда
		ИменаПриложений = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ОтборИмяПриложения, ",");
	КонецЕсли;
	
	Для Каждого СеансИБ Из СеансыИнформационнойБазы Цикл
		Если ФильтроватьИменаПриложений
			И ИменаПриложений.Найти(СеансИБ.ИмяПриложения) = Неопределено Тогда
			КоличествоАктивныхПользователей = КоличествоАктивныхПользователей - 1;
			Продолжить;
		КонецЕсли;
		
		СтрПользователя = СписокПользователей.Добавить();
		
		СтрПользователя.Приложение   = ПредставлениеПриложения(СеансИБ.ИмяПриложения);
		СтрПользователя.НачалоРаботы = СеансИБ.НачалоСеанса;
		СтрПользователя.Компьютер    = СеансИБ.ИмяКомпьютера;
		СтрПользователя.Сеанс        = СеансИБ.НомерСеанса;
		СтрПользователя.Соединение   = СеансИБ.НомерСоединения;
		
		Если ТипЗнч(СеансИБ.Пользователь) = Тип("ПользовательИнформационнойБазы")
		   И ЗначениеЗаполнено(СеансИБ.Пользователь.Имя) Тогда
			
			СтрПользователя.Пользователь        = СеансИБ.Пользователь.Имя;
			СтрПользователя.ИмяПользователя     = СеансИБ.Пользователь.Имя;
			СтрПользователя.ПользовательСсылка  = НайтиСсылкуПоИдентификаторуПользователя(
				СеансИБ.Пользователь.УникальныйИдентификатор);
			
			Если ОбщегоНазначенияПовтИсп.РазделениеВключено() 
				И Пользователи.ЭтоПолноправныйПользователь(, Истина) Тогда
				
				СтрПользователя.РазделениеДанных = ЗначенияРазделителейДанныхВСтроку(
					СеансИБ.Пользователь.РазделениеДанных);
			КонецЕсли;
			
		Иначе
			СвойстваНеУказанного = ПользователиСлужебный.СвойстваНеуказанногоПользователя();
			СтрПользователя.Пользователь       = СвойстваНеУказанного.ПолноеИмя;
			СтрПользователя.ИмяПользователя    = "";
			СтрПользователя.ПользовательСсылка = СвойстваНеУказанного.Ссылка;
		КонецЕсли;

		Если СеансИБ.НомерСеанса = НомерСеансаИнформационнойБазы Тогда
			СтрПользователя.НомерРисункаПользователя = 0;
		Иначе
			СтрПользователя.НомерРисункаПользователя = 1;
		КонецЕсли;
		
	КонецЦикла;
	
	СписокПользователей.Сортировать(ИмяКолонкиСортировки + " " + НаправлениеСортировки);
	
КонецПроцедуры

&НаСервере
Функция ЗначенияРазделителейДанныхВСтроку(РазделениеДанных)
	
	Результат = "";
	Значение = "";
	Если РазделениеДанных.Свойство("ОбластьДанных", Значение) Тогда
		Результат = Строка(Значение);
	КонецЕсли;
	
	ЕстьДругиеРазделители = Ложь;
	Для каждого Разделитель Из РазделениеДанных Цикл
		Если Разделитель.Ключ = "ОбластьДанных" Тогда
			Продолжить;
		КонецЕсли;
		Если Не ЕстьДругиеРазделители Тогда
			Если Не ПустаяСтрока(Результат) Тогда
				Результат = Результат + " ";
			КонецЕсли;
			Результат = Результат + "(";
		КонецЕсли;
		Результат = Результат + Строка(Разделитель.Значение);
		ЕстьДругиеРазделители = Истина;
	КонецЦикла;
	Если ЕстьДругиеРазделители Тогда
		Результат = Результат + ")";
	КонецЕсли;
	Возврат Результат;
		
КонецФункции

&НаСервере
Функция НайтиСсылкуПоИдентификаторуПользователя(Идентификатор)
	
	// Нет доступа к разделенному справочнику из неразделенного сеанса.
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() 
		И Не ОбщегоНазначенияПовтИсп.ДоступноИспользованиеРазделенныхДанных() Тогда
		Возврат Неопределено;
	КонецЕсли;	
	
	Запрос = Новый Запрос;
	
	ШаблонТекстаЗапроса = "ВЫБРАТЬ
					|	Ссылка КАК Ссылка
					|ИЗ
					|	%1
					|ГДЕ
					|	ИдентификаторПользователяИБ = &Идентификатор";
					
	ТекстЗапросаПоПользователям = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонТекстаЗапроса,
					"Справочник.Пользователи");
	
	ТекстЗапросаПоВнешнимПользователям = 
			СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					ШаблонТекстаЗапроса,
					"Справочник.ВнешниеПользователи");
					
	Запрос.Текст = ТекстЗапросаПоПользователям;
	Запрос.Параметры.Вставить("Идентификатор", Идентификатор);
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Запрос.Текст = ТекстЗапросаПоВнешнимПользователям;
	Результат = Запрос.Выполнить();
	
	Если НЕ Результат.Пустой() Тогда
		Выборка = Результат.Выбрать();
		Выборка.Следующий();
		Возврат Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Справочники.Пользователи.ПустаяСсылка();
	
КонецФункции

&НаКлиенте
Процедура ОткрытьПользователяИзСписка()
	
	ТекущиеДанные = Элементы.СписокПользователей.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	Пользователь = ТекущиеДанные.ПользовательСсылка;
	Если ЗначениеЗаполнено(Пользователь) Тогда
		ПараметрыОткрытия = Новый Структура("Ключ", Пользователь);
		Если ТипЗнч(Пользователь) = Тип("СправочникСсылка.Пользователи") Тогда
			ОткрытьФорму("Справочник.Пользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		ИначеЕсли ТипЗнч(Пользователь) = Тип("СправочникСсылка.ВнешниеПользователи") Тогда
			ОткрытьФорму("Справочник.ВнешниеПользователи.Форма.ФормаЭлемента", ПараметрыОткрытия);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьСеансПродолжение(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыАдминистрирования = Результат;
	
	Сообщение = "";
	НомерСеансаДляЗавершения = Элементы.СписокПользователей.ТекущиеДанные.Сеанс;
	
	МассивСеансов = Новый Массив;
	Для Каждого ИдентификаторСтроки Из Элементы.СписокПользователей.ВыделенныеСтроки Цикл
		
		НомерСеанса = СписокПользователей.НайтиПоИдентификатору(ИдентификаторСтроки).Сеанс;
		
		Если НомерСеанса = НомерСеансаИнформационнойБазы Тогда
			Продолжить;
		КонецЕсли;
		
		МассивСеансов.Добавить(НомерСеанса);
		
	КонецЦикла;
	
	СтруктураСеанса = Новый Структура;
	СтруктураСеанса.Вставить("Свойство", "Номер");
	СтруктураСеанса.Вставить("ВидСравнения", ВидСравнения.ВСписке);
	СтруктураСеанса.Вставить("Значение", МассивСеансов);
	Фильтр = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(СтруктураСеанса);
	
	КлиентПодключенЧерезВебСервер = ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер();
	
	Попытка
		Если КлиентПодключенЧерезВебСервер Тогда
			УдалитьСеансыИнформационнойБазыНаСервере(ПараметрыАдминистрирования, Фильтр)
		Иначе
			АдминистрированиеКластераКлиентСервер.УдалитьСеансыИнформационнойБазы(ПараметрыАдминистрирования,, Фильтр);
		КонецЕсли;
	Исключение
		ЗапрашиватьПараметрыАдминистрированияИБ = Истина;
		ВызватьИсключение;
	КонецПопытки;
	
	ЗапрашиватьПараметрыАдминистрированияИБ = Ложь;
	
	ПослеЗавершенияСеанса(КодВозвратаДиалога.ОК, Новый Структура("НомераСеансов", МассивСеансов));
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗавершенияСеанса(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = КодВозвратаДиалога.ОК Тогда
		
		Если ДополнительныеПараметры.Свойство("НомераСеансов")
			И ДополнительныеПараметры.НомераСеансов.Количество() > 1 Тогда
			
			ТекстОповещения = НСтр("ru = 'Сеансы %1 завершены.'");
			НомераСеансов = СтроковыеФункцииКлиентСервер.СтрокаИзМассиваПодстрок(ДополнительныеПараметры.НомераСеансов);
			ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстОповещения,
				НомераСеансов);
			ПоказатьОповещениеПользователя(НСтр("ru = 'Завершение сеансов'"),, ТекстОповещения);
			
		Иначе
			
			НомерСеанса = ?(ДополнительныеПараметры.Свойство("НомераСеансов"),
				ДополнительныеПараметры.НомераСеансов[0], ДополнительныеПараметры.Свойство("НомерСеанса"));
			ТекстОповещения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Сеанс %1 завершен.'"), НомерСеанса);
			ПоказатьОповещениеПользователя(НСтр("ru = 'Завершение сеанса'"),, ТекстОповещения);
			
		КонецЕсли;
		
		ЗаполнитьСписок();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСеансыИнформационнойБазыНаСервере(ПараметрыАдминистрирования, Фильтр)
	
	АдминистрированиеКластераКлиентСервер.УдалитьСеансыИнформационнойБазы(ПараметрыАдминистрирования,, Фильтр);
	
КонецПроцедуры

#КонецОбласти
