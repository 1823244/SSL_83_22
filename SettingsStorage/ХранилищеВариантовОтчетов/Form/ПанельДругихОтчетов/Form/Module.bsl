﻿////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ФОРМЫ

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ВариантСсылка, ОтчетСсылка, ПодсистемаСсылка, ОтчетНаименование");
	Элементы.ГруппаДругиеВариантыОтчета.Заголовок = ОтчетНаименование + " (" + НСтр("ru = 'варианты отчета'") + "):";
	
	Если ТекущийВариантИнтерфейсаКлиентскогоПриложения() = ВариантИнтерфейсаКлиентскогоПриложения.Версия8_2 Тогда
		ЦветГруппыВариантовОтчетов = ЦветаСтиля.ГруппаВариантовОтчетовЦвет82;
		ШрифтОбычнойГруппы = Новый Шрифт("MS Shell Dlg", 8, Истина, Ложь, Ложь, Ложь, 100);
	Иначе // Такси.
		ЦветГруппыВариантовОтчетов = ЦветаСтиля.ГруппаВариантовОтчетовЦвет;
		ШрифтОбычнойГруппы = Новый Шрифт("Arial", 12, Ложь, Ложь, Ложь, Ложь, 90);
	КонецЕсли;
	Элементы.ГруппаДругиеВариантыОтчета.ЦветТекстаЗаголовка = ЦветГруппыВариантовОтчетов;
	Элементы.ГруппаДругиеВариантыОтчета.ШрифтЗаголовка = ШрифтОбычнойГруппы;
	
	ПрочитатьНастройкиЭтойФормы();
	
	КлючСохраненияПоложенияОкна = Строка(ВариантСсылка.УникальныйИдентификатор()) + "\" + Строка(ПодсистемаСсылка.УникальныйИдентификатор());
	
	ЗаполнитьПанельОтчетов();
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// СОБЫТИЯ ЭЛЕМЕНТОВ

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ЗакрыватьЭтоОкноПослеПереходаКОтчетуПриИзменении(Элемент)
	СохранитьНастройкиЭтойФормы();
КонецПроцедуры

&НаКлиенте
Процедура ВариантНажатие(Элемент)
	Найденные = ВариантыПанели.НайтиСтроки(Новый Структура("НадписьИмя", Элемент.Имя));
	Если Найденные.Количество() <> 1 Тогда
		Возврат;
	КонецЕсли;
	Вариант = Найденные[0];
	
	ПараметрыОткрытия = Новый Структура;
	ПараметрыОткрытия.Вставить("КлючВарианта", Вариант.КлючВарианта);
	ПараметрыОткрытия.Вставить("Подсистема",   ПодсистемаСсылка);
	
	// Открытие
	Если Вариант.Дополнительный Тогда
		
		ПараметрыОткрытия.Вставить("Вариант",      Вариант.Ссылка);
		ПараметрыОткрытия.Вставить("Отчет",        Вариант.Отчет);
		ВариантыОтчетовКлиент.ОткрытьВариантДополнительногоОтчета(ПараметрыОткрытия);
		
	ИначеЕсли Не ЗначениеЗаполнено(Вариант.ИмяОтчета) Тогда
		
		ТекстПредупреждения = СтрЗаменить(НСтр("ru = 'Не заполнено имя отчета для варианта ""%1"".'"), "%1", Вариант.Наименование);
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	Иначе
		
		Уникальность = "Отчет." + Вариант.ИмяОтчета;
		Если ЗначениеЗаполнено(Вариант.КлючВарианта) Тогда
			Уникальность = Уникальность + "/КлючВарианта." + Вариант.КлючВарианта;
		КонецЕсли;
		
		ПараметрыОткрытия.Вставить("КлючПараметровПечати", Уникальность);
		ПараметрыОткрытия.Вставить("КлючСохраненияПоложенияОкна", Уникальность);
		
		ОткрытьФорму("Отчет." + Вариант.ИмяОтчета + ".Форма", ПараметрыОткрытия, Неопределено, Истина);
		
	КонецЕсли;
	
	Если ЗакрыватьПослеВыбора Тогда
		Закрыть();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера, Сервер

&НаСервере
Процедура СохранитьНастройкиЭтойФормы()
	НастройкиФормы = НастройкиПоУмолчанию();
	ЗаполнитьЗначенияСвойств(НастройкиФормы, ЭтотОбъект);
	ОбщегоНазначения.ХранилищеНастроекДанныхФормСохранить(
		ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
		"ПанельДругихОтчетов", 
		НастройкиФормы);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Процедура ПрочитатьНастройкиЭтойФормы()
	НастройкиПоУмолчанию = НастройкиПоУмолчанию();
	Элементы.ЗакрыватьПослеВыбора.Видимость = НастройкиПоУмолчанию.ПоказыватьФлажок;
	НастройкиФормы = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ВариантыОтчетовКлиентСервер.ПолноеИмяПодсистемы(),
		"ПанельДругихОтчетов",
		НастройкиПоУмолчанию);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, НастройкиФормы);
КонецПроцедуры

&НаСервере
Функция НастройкиПоУмолчанию()
	Возврат ВариантыОтчетов.ГлобальныеНастройки().ДругиеОтчеты;
КонецФункции

&НаСервере
Процедура ЗаполнитьПанельОтчетов()
	ЕстьДругиеОтчеты = Ложь;
	
	ТаблицаВывода = РеквизитФормыВЗначение("ВариантыПанели");
	ТаблицаВывода.Колонки.Добавить("ЭлементНадоДобавить", Новый ОписаниеТипов("Булево"));
	ТаблицаВывода.Колонки.Добавить("ЭлементНадоОставить", Новый ОписаниеТипов("Булево"));
	ТаблицаВывода.Колонки.Добавить("Группа");
	
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВариантыОтчетов.Ссылка,
	|	ВариантыОтчетов.Отчет,
	|	ВариантыОтчетов.КлючВарианта,
	|	ВариантыОтчетов.Наименование КАК Наименование,
	|	ВЫБОР
	|		КОГДА ПОДСТРОКА(ВариантыОтчетов.Описание, 1, 1) = """"
	|			ТОГДА ВЫРАЗИТЬ(ВариантыОтчетов.ПредопределенныйВариант.Описание КАК СТРОКА(1000))
	|		ИНАЧЕ ВЫРАЗИТЬ(ВариантыОтчетов.Описание КАК СТРОКА(1000))
	|	КОНЕЦ КАК Описание,
	|	ВариантыОтчетов.Автор,
	|	ВариантыОтчетов.ТипОтчета,
	|	ВариантыОтчетов.Отчет.Имя КАК ИмяОтчета
	|ИЗ
	|	Справочник.ВариантыОтчетов КАК ВариантыОтчетов
	|ГДЕ
	|	ВариантыОтчетов.Отчет = &Отчет
	|	И ВариантыОтчетов.ПометкаУдаления = ЛОЖЬ
	|	И (ВариантыОтчетов.ТолькоДляАвтора = ЛОЖЬ
	|			ИЛИ ВариантыОтчетов.Автор = &ТекущийПользователь)
	|	И НЕ ВариантыОтчетов.ПредопределенныйВариант В (&ОтключенныеВариантыПрограммы)
	|	И ВариантыОтчетов.КлючВарианта <> """"
	|
	|УПОРЯДОЧИТЬ ПО
	|	Наименование";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Отчет", ОтчетСсылка);
	Запрос.УстановитьПараметр("ТекущийПользователь", Пользователи.ТекущийПользователь());
	Запрос.УстановитьПараметр("ОтключенныеВариантыПрограммы", ВариантыОтчетовПовтИсп.ОтключенныеВариантыПрограммы());
	Запрос.Текст = ТекстЗапроса;
	
	ОбщиеНастройки = ВариантыОтчетов.ОбщиеНастройкиПанели();
	ПоказыватьПодсказки = ОбщиеНастройки.ПоказыватьПодсказки = 1;
	
	ТаблицаВариантов = Запрос.Выполнить().Выгрузить();
	Для Каждого СтрокаТаблицы Из ТаблицаВариантов Цикл
		// Только другие варианты.
		Если СтрокаТаблицы.Ссылка = ВариантСсылка Тогда
			Продолжить;
		КонецЕсли;
		ЕстьДругиеОтчеты = Истина;
		ВывестиГиперссылкуВПанель(ТаблицаВывода, СтрокаТаблицы, Элементы.ГруппаДругиеВариантыОтчета, ПоказыватьПодсказки);
	КонецЦикла;
	Элементы.ГруппаДругиеВариантыОтчета.Видимость = (ТаблицаВариантов.Количество() > 0);
	
	ВидимостьГруппыПохожиеОтчеты = Ложь;
	Если ЗначениеЗаполнено(ПодсистемаСсылка) Тогда
		Подсистемы = Подсистемы();
		
		ПараметрыПоиска = Новый Структура;
		ПараметрыПоиска.Вставить("Подсистемы", Подсистемы);
		ПараметрыПоиска.Вставить("ТолькоВидимыеВПанелиОтчетов", Истина);
		ПараметрыПоиска.Вставить("ПолучатьИтоговуюТаблицу", Истина);
		ПараметрыПоиска.Вставить("ПометкаУдаления", Ложь);
		
		РезультатПоиска = ВариантыОтчетов.НайтиСсылки(ПараметрыПоиска);
		
		ТаблицаВариантов = РезультатПоиска.ТаблицаЗначений;
		ТаблицаВариантов.Колонки.НаименованиеВарианта.Имя = "Наименование";
		ТаблицаВариантов.Сортировать("Наименование");
		
		// Удаление строк, соответствующих текущему (открытому сейчас) варианту.
		Найденные = ТаблицаВариантов.НайтиСтроки(Новый Структура("Ссылка", ВариантСсылка));
		Для Каждого СтрокаТаблицы Из Найденные Цикл
			ТаблицаВариантов.Удалить(СтрокаТаблицы);
		КонецЦикла;
		
		// Обход подсистем и вывод найденных вариантов.
		Для Каждого ПодсистемаСсылка Из Подсистемы Цикл
			Найденные = ТаблицаВариантов.НайтиСтроки(Новый Структура("Подсистема", ПодсистемаСсылка));
			Если Найденные.Количество() = 0 Тогда
				Продолжить;
			КонецЕсли;
			
			Группа = ОпределитьГруппуВывода(Найденные[0].НаименованиеПодсистемы);
			Для Каждого СтрокаТаблицы Из Найденные Цикл
				ЕстьДругиеОтчеты = Истина;
				ВывестиГиперссылкуВПанель(ТаблицаВывода, СтрокаТаблицы, Группа, ПоказыватьПодсказки);
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	// ВариантыПанелиНомерЭлемента
	НайденныеДляУдаления = ТаблицаВывода.НайтиСтроки(Новый Структура("ЭлементНадоОставить", Ложь));
	Для Каждого СтрокаТаблицы Из НайденныеДляУдаления Цикл
		ЭлементВарианта = Элементы.Найти(СтрокаТаблицы.НадписьИмя);
		Если ЭлементВарианта <> Неопределено Тогда
			Элементы.Удалить(ЭлементВарианта);
		КонецЕсли;
		ТаблицаВывода.Удалить(СтрокаТаблицы);
	КонецЦикла;
	
	ТаблицаВывода.Колонки.Удалить("ЭлементНадоОставить");
	ТаблицаВывода.Колонки.Удалить("Группа");
	ЗначениеВРеквизитФормы(ТаблицаВывода, "ВариантыПанели");
КонецПроцедуры

&НаСервере
Процедура ВывестиГиперссылкуВПанель(ТаблицаВывода, Вариант, Группа, ПоказыватьПодсказки)
	
	Найденные = ТаблицаВывода.НайтиСтроки(Новый Структура("Ссылка, Группа", Вариант.Ссылка, Группа.Имя));
	Если Найденные.Количество() > 0 Тогда
		СтрокаВывода = Найденные[0];
		СтрокаВывода.ЭлементНадоОставить = Истина;
		Возврат;
	КонецЕсли;
	
	СтрокаВывода = ТаблицаВывода.Добавить();
	ЗаполнитьЗначенияСвойств(СтрокаВывода, Вариант);
	ВариантыПанелиНомерЭлемента = ВариантыПанелиНомерЭлемента + 1;
	СтрокаВывода.НадписьИмя = "Вариант" + Формат(ВариантыПанелиНомерЭлемента, "ЧГ=");
	СтрокаВывода.Дополнительный = (Вариант.ТипОтчета = Перечисления.ТипыОтчетов.Дополнительный);
	СтрокаВывода.ИмяГруппы = Группа.Имя;
	СтрокаВывода.ЭлементНадоОставить = Истина;
	СтрокаВывода.Группа = Группа;
	
	// Добавление надписи-гиперссылки варианта отчета.
	Надпись = Элементы.Вставить(СтрокаВывода.НадписьИмя, Тип("ДекорацияФормы"), СтрокаВывода.Группа);
	Надпись.Вид = ВидДекорацииФормы.Надпись;
	Надпись.Гиперссылка = Истина;
	Надпись.РастягиватьПоГоризонтали = Истина;
	Надпись.РастягиватьПоВертикали = Ложь;
	Надпись.Высота = 1;
	Надпись.ЦветТекста = ЦветаСтиля.ВидимыйВариантОтчетаЦвет;
	Надпись.Заголовок = СокрЛП(Строка(Вариант.Ссылка));
	Если ЗначениеЗаполнено(Вариант.Описание) Тогда
		Надпись.Подсказка = СокрЛП(Вариант.Описание);
	КонецЕсли;
	Если ЗначениеЗаполнено(Вариант.Автор) Тогда
		Надпись.Подсказка = СокрЛ(Надпись.Подсказка + Символы.ПС) + НСтр("ru = 'Автор:'") + " " + СокрЛП(Строка(Вариант.Автор));
	КонецЕсли;
	Если ПоказыватьПодсказки Тогда
		Надпись.ОтображениеПодсказки = ОтображениеПодсказки.ОтображатьСнизу;
		Надпись.РасширеннаяПодсказка.РастягиватьПоГоризонтали = Истина;
		Надпись.РасширеннаяПодсказка.ЦветТекста = ЦветаСтиля.ПоясняющийТекст;
	КонецЕсли;
	Надпись.УстановитьДействие("Нажатие", "ВариантНажатие");
	
КонецПроцедуры

&НаСервере
Функция Подсистемы()
	Результат = Новый Массив;
	Результат.Добавить(ПодсистемаСсылка);
	
	ДеревоПодсистем = ВариантыОтчетовПовтИсп.ПодсистемыТекущегоПользователя();
	Найденные = ДеревоПодсистем.Строки.НайтиСтроки(Новый Структура("Ссылка", ПодсистемаСсылка), Истина);
	Пока Найденные.Количество() > 0 Цикл
		КоллекцияСтрок = Найденные[0].Строки;
		Найденные.Удалить(0);
		Для Каждого СтрокаДерева Из КоллекцияСтрок Цикл
			Результат.Добавить(СтрокаДерева.Ссылка);
			Найденные.Добавить(СтрокаДерева);
		КонецЦикла;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции

&НаСервере
Функция ОпределитьГруппуВывода(ПодсистемаПредставление)
	ЭлементСписка = ГруппыПодсистем.НайтиПоЗначению(ПодсистемаПредставление);
	Если ЭлементСписка <> Неопределено Тогда
		Возврат Элементы.Найти(ЭлементСписка.Представление);
	КонецЕсли;
	
	НомерГруппы = ГруппыПодсистем.Количество() + 1;
	ДекорацияИмя = "ОтступПодсистемы_" + НомерГруппы;
	ГруппаИмя    = "ГруппаПодсистемы_" + НомерГруппы;
	
	Если ЕстьДругиеОтчеты Тогда
		Декорация = Элементы.Добавить(ДекорацияИмя, Тип("ДекорацияФормы"), Элементы.СтраницаДругиеОтчеты);
		Декорация.Вид = ВидДекорацииФормы.Надпись;
		Декорация.Заголовок = " ";
	КонецЕсли;
	
	Группа = Элементы.Добавить(ГруппаИмя, Тип("ГруппаФормы"), Элементы.СтраницаДругиеОтчеты);
	Группа.Вид = ВидГруппыФормы.ОбычнаяГруппа;
	Группа.Заголовок = ПодсистемаПредставление;
	Группа.ОтображатьЗаголовок = Истина;
	Группа.ЦветТекстаЗаголовка = ЦветГруппыВариантовОтчетов;
	Группа.ШрифтЗаголовка = ШрифтОбычнойГруппы;
	
	ГруппыПодсистем.Добавить(ПодсистемаПредставление, ГруппаИмя);
	Возврат Группа;
КонецФункции

#КонецОбласти
