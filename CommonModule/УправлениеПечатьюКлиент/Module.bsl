﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Печать".
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Формирует и выводит на экран печатные формы.
// 
// Параметры:
//  ИмяМенеджераПечати - Строка - менеджер печати для печатаемых объектов;
//  ИменаМакетов       - Строка - идентификаторы печатных форм;
//  МассивОбъектов     - Ссылка, Массив - объекты печати;
//  ВладелецФормы      - УправляемаяФорма - форма, из которой выполняется печать;
//  ПараметрыПечати    - Структура - произвольные параметры для передачи в менеджер печати.
//
Процедура ВыполнитьКомандуПечати(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ВладелецФормы, ПараметрыПечати = Неопределено) Экспорт
	
	// Проверим количество объектов.
	Если НЕ ПроверитьКоличествоПереданныхОбъектов(МассивОбъектов) Тогда
		Возврат;
	КонецЕсли;
	
	// Получим ключ уникальности открываемой формы.
	КлючУникальности = Строка(Новый УникальныйИдентификатор);
	
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати");
	ПараметрыОткрытия.ИмяМенеджераПечати = ИмяМенеджераПечати;
	ПараметрыОткрытия.ИменаМакетов		 = ИменаМакетов;
	ПараметрыОткрытия.ПараметрКоманды	 = МассивОбъектов;
	ПараметрыОткрытия.ПараметрыПечати	 = ПараметрыПечати;
	
	// Откроем форму печати документов.
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, ВладелецФормы, КлючУникальности);
	
КонецПроцедуры

// Формирует и выводит на принтер печатные формы.
//
// Параметры:
//  ИмяМенеджераПечати - Строка - менеджер печати для печатаемых объектов;
//  ИменаМакетов       - Строка - идентификаторы печатных форм;
//  МассивОбъектов     - Ссылка, Массив - объекты печати;
//  ВладелецФормы      - УправляемаяФорма - форма, из которой выполняется печать;
//  ПараметрыПечати    - Структура - произвольные параметры для передачи в менеджер печати.
//
Процедура ВыполнитьКомандуПечатиНаПринтер(ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ПараметрыПечати = Неопределено) Экспорт

	// Проверим количество объектов.
	Если НЕ ПроверитьКоличествоПереданныхОбъектов(МассивОбъектов) Тогда
		Возврат;
	КонецЕсли;
	
	// Сформируем табличные документы.
#Если ТолстыйКлиентОбычноеПриложение Тогда
	ПечатныеФормы = УправлениеПечатьюВызовСервера.СформироватьПечатныеФормыДляБыстройПечатиОбычноеПриложение(
			ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ПараметрыПечати);
	Если НЕ ПечатныеФормы.Отказ Тогда
		ОбъектыПечати = Новый СписокЗначений;
		ТабличныеДокументы = ПолучитьИзВременногоХранилища(ПечатныеФормы.Адрес);
		Для Каждого ОбъектПечати Из ПечатныеФормы.ОбъектыПечати Цикл
			ОбъектыПечати.Добавить(ОбъектПечати.Значение, ОбъектПечати.Ключ);
		КонецЦикла;
		ПечатныеФормы.ОбъектыПечати = ОбъектыПечати;
	КонецЕсли;
#Иначе
	ПечатныеФормы = УправлениеПечатьюВызовСервера.СформироватьПечатныеФормыДляБыстройПечати(
			ИмяМенеджераПечати, ИменаМакетов, МассивОбъектов, ПараметрыПечати);
#КонецЕсли
	
	Если ПечатныеФормы.Отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Нет прав для вывода печатной формы на принтер, обратитесь к администратору.'"));
		Возврат;
	КонецЕсли;
	
	// Распечатаем
	РаспечататьТабличныеДокументы(ПечатныеФормы.ТабличныеДокументы, ПечатныеФормы.ОбъектыПечати);
	
КонецПроцедуры

// Вывести табличные документы на принтер.
//
// Параметры:
//  ТабличныеДокументы           - СписокЗначений - печатные формы.
//  ОбъектыПечати                - СписокЗначений - соответствие объектов именам областей табличного документа.
//  ПечататьКомплектами          - Булево, Неопределено - (не используется, вычисляется автоматически).
//  КоличествоКопийКомплектов    - Число - количество экземпляров каждого из комплектов документов.
Процедура РаспечататьТабличныеДокументы(ТабличныеДокументы, ОбъектыПечати, Знач ПечататьКомплектами = Неопределено, Знач КоличествоКопийКомплектов = 1) Экспорт
	
	ПечататьКомплектами = ТабличныеДокументы.Количество() > 1;
	
	ПакетОтображаемыхДокументов = УправлениеПечатьюВызовСервера.ПакетДокументов(ТабличныеДокументы,
		ОбъектыПечати, ПечататьКомплектами, КоличествоКопийКомплектов);
		
	ПакетОтображаемыхДокументов.Напечатать(РежимИспользованияДиалогаПечати.НеИспользовать);
КонецПроцедуры

// Выполняет интерактивное проведение документов перед печатью.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры:
//  ОписаниеПроцедурыЗавершения - ОписаниеОповещения - процедура, в которую необходимо передать управление после
//                                                     выполнения.
//                                Параметры вызываемой процедуры:
//                                  СписокДокументов - Массив - проведенные документы;
//                                  ДополнительныеПараметры - значение, которое было указано при создании объекта
//                                                            оповещения.
//  СписокДокументов            - Массив            - ссылки на документы, которые требуется провести.
//  Форма                       - УправляемаяФорма  - форма, из которой было вызвана команда. Параметр требуется, когда
//                                                    процедура
//                                                    вызвана из формы объекта, для того, чтобы перечитать форму.
Процедура ПроверитьПроведенностьДокументов(ОписаниеПроцедурыЗавершения, СписокДокументов, Форма = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеПроцедурыЗавершения", ОписаниеПроцедурыЗавершения);
	ДополнительныеПараметры.Вставить("СписокДокументов", СписокДокументов);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	
	НепроведенныеДокументы = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(СписокДокументов);
	ЕстьНепроведенныеДокументы = НепроведенныеДокументы.Количество() > 0;
	Если ЕстьНепроведенныеДокументы Тогда
		ДополнительныеПараметры.Вставить("НепроведенныеДокументы", НепроведенныеДокументы);
		УправлениеПечатьюСлужебныйКлиент.ПроверитьПроведенностьДокументовДиалогПроведения(ДополнительныеПараметры);
	Иначе
		ВыполнитьОбработкуОповещения(ОписаниеПроцедурыЗавершения, СписокДокументов);
	КонецЕсли;
	
КонецПроцедуры

// Обработчик динамически подключаемой команды печати.
//
// Команда  - КомандаФормы - подключаемая команда формы, выполняющая обработчик Подключаемый_ВыполнитьКомандуПечати.
//            (альтернативный вызов*) Структура    - строка таблицы КомандыПечати, преобразованная в структуру.
// Источник - ТаблицаФормы, ДанныеФормыСтруктура - источник объектов печати (Форма.Объект, Форма.Элементы.Список).
//            (альтернативный вызов*) Массив - список объектов печати.
//
// *Альтернативный вызов - указанные типы используются в случае, если вызов выполняется не из штатного
//                         обработчика Подключаемый_ВыполнитьКомандуПечати.
//
Процедура ВыполнитьПодключаемуюКомандуПечати(Знач Команда, Знач Форма, Знач Источник) Экспорт
	
	ОписаниеКоманды = Команда;
	Если ТипЗнч(Команда) = Тип("КомандаФормы") Тогда
		ОписаниеКоманды = ОписаниеКомандыПечати(Команда.Имя, Форма.Команды.Найти("АдресКомандПечатиВоВременномХранилище").Действие);
	КонецЕсли;
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ОписаниеКоманды", ОписаниеКоманды);
	ДополнительныеПараметры.Вставить("Форма", Форма);
	ДополнительныеПараметры.Вставить("Источник", Источник);
	
	Если Не ОписаниеКоманды.НеВыполнятьЗаписьВФорме И ТипЗнч(Источник) = Тип("ДанныеФормыСтруктура")
		И (Источник.Ссылка.Пустая() Или Форма.Модифицированность) Тогда
		
		Если Источник.Ссылка.Пустая() Тогда
			ТекстВопроса = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Данные еще не записаны.
					|Выполнение действия ""%1"" возможно только после записи данных.
					|Данные будут записаны.'"),
				ОписаниеКоманды.Представление);
				
			ОписаниеОповещения = Новый ОписаниеОповещения("ВыполнитьПодключаемуюКомандуПечатиПодтверждениеЗаписи", УправлениеПечатьюСлужебныйКлиент, ДополнительныеПараметры);
			ПоказатьВопрос(ОписаниеОповещения, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
			Возврат;
		КонецЕсли;
		УправлениеПечатьюСлужебныйКлиент.ВыполнитьПодключаемуюКомандуПечатиПодтверждениеЗаписи(КодВозвратаДиалога.ОК, ДополнительныеПараметры);
		Возврат;
	КонецЕсли;
	
	УправлениеПечатьюСлужебныйКлиент.ВыполнитьПодключаемуюКомандуПечатиПодтверждениеЗаписи(Неопределено, ДополнительныеПараметры);
	
КонецПроцедуры

// Открывает форму ПечатьДокументов для коллекции табличных документов.
//
// Параметры:
//  КоллекцияПечатныхФорм - Массив - коллекция описаний печатных форм, см. НоваяКоллекцияПечатныхФорм;
//  ОбъектыПечати - СписокЗначений  - значение - ссылка на объект;
//                                    представление - имя области в которой был выведен объект (выходной параметр);
//  ВладелецФормы - УправляемаяФорма - форма, из которой выполняется печать.
//
Процедура ПечатьДокументов(КоллекцияПечатныхФорм, Знач ОбъектыПечати = Неопределено, ВладелецФормы = Неопределено) Экспорт
	Если ОбъектыПечати = Неопределено Тогда
		ОбъектыПечати = Новый СписокЗначений;
	КонецЕсли;
	
	КлючУникальности = Строка(Новый УникальныйИдентификатор);
	
	ПараметрыОткрытия = Новый Структура("ИмяМенеджераПечати,ИменаМакетов,ПараметрКоманды,ПараметрыПечати");
	ПараметрыОткрытия.ПараметрКоманды = Новый Массив;
	ПараметрыОткрытия.ПараметрыПечати = Новый Структура;
	ПараметрыОткрытия.Вставить("КоллекцияПечатныхФорм", КоллекцияПечатныхФорм);
	ПараметрыОткрытия.Вставить("ОбъектыПечати", ОбъектыПечати);
	
	ОткрытьФорму("ОбщаяФорма.ПечатьДокументов", ПараметрыОткрытия, ВладелецФормы, КлючУникальности);
КонецПроцедуры

// Возвращает подготовленный список печатных форм.
//
// Параметры:
//  Идентификаторы - Строка - идентификаторы печатных форм.
//
// Возвращаемое значение:
//  Массив - коллекция описаний печатных форм.
Функция НоваяКоллекцияПечатныхФорм(Идентификаторы) Экспорт
	Возврат УправлениеПечатьюВызовСервера.НоваяКоллекцияПечатныхФорм(Идентификаторы);
КонецФункции

// Возвращает описание найденной в коллекции печатной формы.
// Если описание не найдено, возвращает Неопределено.
//
// Параметры:
//  КоллекцияПечатныхФорм - Массив - см. УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм();
//  Идентификатор         - Строка - идентификатор печатной формы.
//
// ВозвращаемоеЗначение:
//  Структура - найденное описание печатной формы.
Функция ОписаниеПечатнойФормы(КоллекцияПечатныхФорм, Идентификатор) Экспорт
	Для Каждого ОписаниеПечатнойФормы Из КоллекцияПечатныхФорм Цикл
		Если ОписаниеПечатнойФормы.ИмяВРЕГ = ВРег(Идентификатор) Тогда
			Возврат ОписаниеПечатнойФормы;
		КонецЕсли;
	КонецЦикла;
	Возврат Неопределено;
КонецФункции

#Область РаботаСМакетамиОфисныхДокументов

////////////////////////////////////////////////////////////////////////////////
// Работа с макетами офисных документов.

//	Секция содержит интерфейсные функции (API), используемые при создании
//	печатных форм основанных на офисных документах. На данный момент поддерживается
//	два офисных пакета MS Office (шаблоны MS Word) и Open Office (шаблоны OO Writer).
//
////////////////////////////////////////////////////////////////////////////////
//	Типы используемых данных (определяется конкретными реализациями).
//	СсылкаПечатнаяФорма	- ссылка на печатную форму.
//	СсылкаМакет			- ссылка на макет.
//	Область				- ссылка на область в печатной форме или макете (структура)
//						доопределяется в интерфейсном модуле служебной информацией
//						об области.
//	ОписаниеОбласти			- описание области макета (см. ниже).
//	ДанныеЗаполнения		- либо структура, либо массив структур (для случая
//							списков и таблиц.
////////////////////////////////////////////////////////////////////////////////
//	ОписаниеОбласти - структура, описывающая подготовленные пользователем области макета
//	ключ ИмяОбласти - имя области
//	ключ ТипТипОбласти - 	ВерхнийКолонтитул.
//							НижнийКолонтитул
//							Общая
//							СтрокаТаблицы
//							Список
//

////////////////////////////////////////////////////////////////////////////////
// Функции инициализации и закрытия ссылок.

// Создает соединение с выходной печатной формой.
// Необходимо вызвать перед любыми действиями над формой.
// Функция не работает в любых других браузерах кроме IE.
// Перед выполнением функции в веб-клиенте необходимо подключить расширение работы с файлами.
//
// Параметры:
// ТипДокумента            - Строка - тип печатной формы "DOC" или "ODT";
// НастройкиСтраницыМакета - Соответствие - параметры из структуры, возвращаемой функцией ИнициализироватьМакет;
// Макет                   - Структура - результат функции ИнициализироватьМакет.
//
// Возвращаемое значение:
//  Структура.
// 
// Примечание: параметр НастройкиСтраницыМакета устарел, его следует пропускать и использовать параметр Макет.
//
Функция ИнициализироватьПечатнуюФорму(Знач ТипДокумента, Знач НастройкиСтраницыМакета = Неопределено, Макет = Неопределено) Экспорт
	
	Если ВРег(ТипДокумента) = "DOC" Тогда
		Параметр = ?(Макет = Неопределено, НастройкиСтраницыМакета, Макет); // для обратной совместимости
		ПечатнаяФорма = УправлениеПечатьюMSWordКлиент.ИнициализироватьПечатнуюФормуMSWord(Параметр);
		ПечатнаяФорма.Вставить("Тип", "DOC");
		ПечатнаяФорма.Вставить("ПоследняяВыведеннаяОбласть", Неопределено);
		Возврат ПечатнаяФорма;
	ИначеЕсли ВРег(ТипДокумента) = "ODT" Тогда
		ПечатнаяФорма = УправлениеПечатьюOOWriterКлиент.ИнициализироватьПечатнуюФормуOOWriter(Макет);
		ПечатнаяФорма.Вставить("Тип", "ODT");
		ПечатнаяФорма.Вставить("ПоследняяВыведеннаяОбласть", Неопределено);
		Возврат ПечатнаяФорма;
	КонецЕсли;
	
КонецФункции

// Создает COM-соединение с макетом. В дальнейшем это соединение используется при получении из него областей (тегов и
// таблиц).
// Функция не работает в любых других браузерах кроме IE.
// Перед выполнением функции в веб-клиенте необходимо подключить расширение работы с файлами.
//
// Параметры:
//  ДвоичныеДанныеМакета - ДвоичныеДанные - двоичные данные макета;
//  ТипМакета            - Строка - тип макета печатной формы "DOC" или "ODT";
//  ИмяМакета            - Строка - имя, которое будет использовано при создании временного файла макета.
// Возвращаемое значение:
//  Структура.
//
Функция ИнициализироватьМакетОфисногоДокумента(Знач ДвоичныеДанныеМакета, Знач ТипМакета, Знач ИмяМакета = "") Экспорт
	
	Макет = Неопределено;
	ИмяВременногоФайла = "";
	
	#Если ВебКлиент Тогда
		Если ПустаяСтрока(ИмяМакета) Тогда
			ИмяВременногоФайла = Строка(Новый УникальныйИдентификатор) + "." + НРег(ТипМакета);
		Иначе
			ИмяВременногоФайла = ИмяМакета + "." + НРег(ТипМакета);
		КонецЕсли;
		
		ОписанияФайлов = Новый Массив;
		ОписанияФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(ИмяВременногоФайла, ПоместитьВоВременноеХранилище(ДвоичныеДанныеМакета)));
		
		Если НЕ ПолучитьФайлы(ОписанияФайлов, , КаталогВременныхФайлов(), Ложь) Тогда
			Возврат Неопределено;
		КонецЕсли;
		
		ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(КаталогВременныхФайлов()) + ИмяВременногоФайла;
	#КонецЕсли
	
	Если ВРег(ТипМакета) = "DOC" Тогда
		Макет = УправлениеПечатьюMSWordКлиент.ПолучитьМакетMSWord(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Макет.Вставить("Тип", "DOC");
	ИначеЕсли ВРег(ТипМакета) = "ODT" Тогда
		Макет = УправлениеПечатьюOOWriterКлиент.ПолучитьМакетOOWriter(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Макет.Вставить("Тип", "ODT");
		Макет.Вставить("НастройкиСтраницыМакета", Неопределено);
	КонецЕсли;
	
	Возврат Макет;
	
КонецФункции

// Освобождает ссылки в созданном интерфейсе связи с офисным приложением.
// Необходимо вызывать каждый раз после завершения формирования макета и выводе
// печатной формы пользователю.
// Параметры:
// Handler - СсылкаПечатнаяФорма, СсылкаМакет
// ЗакрытьПриложение - булево - признак, требуется ли закрыть приложение.
//					Соединение с макетом требуется закрывать с закрытием приложения.
//					ПечатнуюФорму не требуется закрывать.
//
Процедура ОчиститьСсылки(Handler, Знач ЗакрытьПриложение = Истина) Экспорт
	
	Если Handler <> Неопределено Тогда
		Если Handler.Тип = "DOC" Тогда
			УправлениеПечатьюMSWordКлиент.ЗакрытьСоединение(Handler, ЗакрытьПриложение);
		Иначе
			УправлениеПечатьюOOWriterКлиент.ЗакрытьСоединение(Handler, ЗакрытьПриложение);
		КонецЕсли;
		Handler = Неопределено;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функция отображения печатной формы пользователю.

// Показывает сформированный документ пользователю.
// Фактически устанавливает ему признак видимости.
// Параметры:
//  Handler - СсылкаПечатнаяФорма
//
Процедура ПоказатьДокумент(Знач Handler) Экспорт
	
	Если Handler.Тип = "DOC" Тогда
		УправлениеПечатьюMSWordКлиент.ПоказатьДокументMSWord(Handler);
	ИначеЕсли Handler.Тип = "ODT" Тогда
		УправлениеПечатьюOOWriterКлиент.ПоказатьДокументOOWriter(Handler);
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Функции получения областей из макета, вывода в печатную форму областей макета
// и заполнение параметров в них.

// Получает область из макета печатной формы.
//
// Параметры:
//   СсылкаНаМакет   - Структура - ссылка на макет печатной формы.
//   ОписаниеОбласти - Структура - описание области.
//
// Возвращаемое значение
//   Структура - область из макета.
//
Функция ОбластьМакета(Знач СсылкаНаМакет, Знач ОписаниеОбласти) Экспорт
	
	Область = Неопределено;
	Если СсылкаНаМакет.Тип = "DOC" Тогда
		
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьВерхнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьНижнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти, 1, 0);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			Область = УправлениеПечатьюMSWordКлиент.ПолучитьОбластьМакетаMSWord(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти, 1, 0);
		Иначе
			ВызватьИсключение
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Тип области не указан или указан не корректно: %1.'"), ОписаниеОбласти.ТипОбласти);
		КонецЕсли;
		
		Если Область <> Неопределено Тогда
			Область.Вставить("ОписаниеОбласти", ОписаниеОбласти);
		КонецЕсли;
	ИначеЕсли СсылкаНаМакет.Тип = "ODT" Тогда
		
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьВерхнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьНижнегоКолонтитула(СсылкаНаМакет);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			Область = УправлениеПечатьюOOWriterКлиент.ПолучитьОбластьМакета(СсылкаНаМакет, ОписаниеОбласти.ИмяОбласти);
		Иначе
			ВызватьИсключение
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Тип области не указан или указан не корректно: %1.'"), ОписаниеОбласти.ИмяОбласти);
		КонецЕсли;
		
		Если Область <> Неопределено Тогда
			Область.Вставить("ОписаниеОбласти", ОписаниеОбласти);
		КонецЕсли;
	КонецЕсли;
	
	Возврат Область;
	
КонецФункции

// Присоединяет область в печатную форму из макета.
// Применяется при одиночном выводе области.
//
// Параметры:
// ПечатнаяФорма - СсылкаПечатнаяФорма - ссылка на печатную форму.
// ОбластьМакета - Область - область из макета.
// ПереходНаСледующуюСтроку - булево, требуется ли вставлять разрыв после вывода области.
//
Процедура ПрисоединитьОбласть(Знач ПечатнаяФорма,
							  Знач ОбластьМакета,
							  Знач ПереходНаСледующуюСтроку = Истина) Экспорт
							  
	Если ОбластьМакета = Неопределено Тогда
		Возврат;						  
	КонецЕсли; 
								  
	Попытка
		ОписаниеОбласти = ОбластьМакета.ОписаниеОбласти;
		
		Если ПечатнаяФорма.Тип = "DOC" Тогда
			
			ВыведеннаяОбласть = Неопределено;
			
			Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
				УправлениеПечатьюMSWordКлиент.ДобавитьВерхнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
				УправлениеПечатьюMSWordКлиент.ДобавитьНижнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая" Тогда
				ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
				ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
				Если ПечатнаяФорма.ПоследняяВыведеннаяОбласть <> Неопределено
				   И ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "СтрокаТаблицы"
				   И НЕ ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ПереходНаСледующуюСтроку Тогда
					ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку, Истина);
				Иначе
					ВыведеннаяОбласть = УправлениеПечатьюMSWordКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
				КонецЕсли;
			Иначе
				ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно.'"));
			КонецЕсли;
			
			ОписаниеОбласти.Вставить("Область", ВыведеннаяОбласть);
			ОписаниеОбласти.Вставить("ПереходНаСледующуюСтроку", ПереходНаСледующуюСтроку);
			
			// Содержит тип области, и границы области (если требуется).
			ПечатнаяФорма.ПоследняяВыведеннаяОбласть = ОписаниеОбласти;
			
		ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
			Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
				УправлениеПечатьюOOWriterКлиент.ДобавитьВерхнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
				УправлениеПечатьюOOWriterКлиент.ДобавитьНижнийКолонтитул(ПечатнаяФорма, ОбластьМакета);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
					ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
				УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
				УправлениеПечатьюOOWriterКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
			ИначеЕсли	ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
				УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
				УправлениеПечатьюOOWriterКлиент.ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку, Истина);
			Иначе
				ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
			КонецЕсли;
			// Содержит тип области, и границы области (если требуется).
			ПечатнаяФорма.ПоследняяВыведеннаяОбласть = ОписаниеОбласти;
		КонецЕсли;
	Исключение
		СообщениеОбОшибке = СокрЛП(КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		СообщениеОбОшибке = ?(Прав(СообщениеОбОшибке, 1) = ".", СообщениеОбОшибке, СообщениеОбОшибке + ".");
		СообщениеОбОшибке = СообщениеОбОшибке + " " +
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
					НСтр("ru = 'Ошибка при попытке вывести область ""%1"" из макета.'"),
					ОбластьМакета.ОписаниеОбласти.ИмяОбласти);
		ВызватьИсключение СообщениеОбОшибке;
	КонецПопытки;
	
КонецПроцедуры

// Заполняет параметры области печатной формы.
//
// Параметры:
// ПечатнаяФорма	- СсылкаПечатнаяФорма, Область - область печатной формы, либо сама печатная форма.
// Данные			- ДанныеЗаполнения
//
Процедура ЗаполнитьПараметры(Знач ПечатнаяФорма, Знач Данные) Экспорт
	
	ОписаниеОбласти = ПечатнаяФорма.ПоследняяВыведеннаяОбласть;
	
	Если ПечатнаяФорма.Тип = "DOC" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "ВерхнийКолонтитул" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметрыВерхнегоКолонтитула(ПечатнаяФорма, Данные);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "НижнийКолонтитул" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметрыНижнегоКолонтитула(ПечатнаяФорма, Данные);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюMSWordКлиент.ЗаполнитьПараметры(ПечатнаяФорма.ПоследняяВыведеннаяОбласть.Область, Данные);
		Иначе
			ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
		КонецЕсли;
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		Если		ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "ВерхнийКолонтитул" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаВерхнийКолонтитул(ПечатнаяФорма);
		ИначеЕсли	ПечатнаяФорма.ПоследняяВыведеннаяОбласть.ТипОбласти = "НижнийКолонтитул" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаНижнийКолонтитул(ПечатнаяФорма);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Общая"
				ИЛИ ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы"
				ИЛИ ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюOOWriterКлиент.УстановитьОсновнойКурсорНаТелоДокумента(ПечатнаяФорма);
		КонецЕсли;
		УправлениеПечатьюOOWriterКлиент.ЗаполнитьПараметры(ПечатнаяФорма, Данные);
	КонецЕсли;
	
КонецПроцедуры

// Добавляет область в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры:
// ПечатнаяФорма	- СсылкаПечатнаяФорма
// ОбластьМакета	- Область
// Данные			- ДанныеОбъекта
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области.
//
Процедура ПрисоединитьОбластьИЗаполнитьПараметры(Знач ПечатнаяФорма,
										Знач ОбластьМакета,
										Знач Данные,
										Знач ПереходНаСледующуюСтроку = Истина) Экспорт
																			
	Если ОбластьМакета <> Неопределено Тогда
		ПрисоединитьОбласть(ПечатнаяФорма, ОбластьМакета, ПереходНаСледующуюСтроку);
		ЗаполнитьПараметры(ПечатнаяФорма, Данные)
	КонецЕсли;
	
КонецПроцедуры

// Добавляет область в печатную форму из макета, при этом заменяя
// параметры в области значениями из данных объекта.
// Применяется при одиночном выводе области.
//
// Параметры:
// ПечатнаяФорма	- СсылкаПечатнаяФорма
// ОбластьМакета	- Область - область макета.
// Данные			- ДанныеОбъекта (массив структур).
// ПереходНаСледСтроку - булево, требуется ли вставлять разрыв после вывода области.
//
Процедура ПрисоединитьИЗаполнитьКоллекцию(Знач ПечатнаяФорма,
										Знач ОбластьМакета,
										Знач Данные,
										Знач ПереходНаСледСтроку = Истина) Экспорт
	Если ОбластьМакета = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОписаниеОбласти = ОбластьМакета.ОписаниеОбласти;
	
	Если ПечатнаяФорма.Тип = "DOC" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			УправлениеПечатьюMSWordКлиент.ПрисоединитьИЗаполнитьОбластьТаблицы(ПечатнаяФорма, ОбластьМакета, Данные, ПереходНаСледСтроку);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюMSWordКлиент.ПрисоединитьИЗаполнитьНабор(ПечатнаяФорма, ОбластьМакета, Данные, ПереходНаСледСтроку);
		Иначе
			ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
		КонецЕсли;
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		Если		ОписаниеОбласти.ТипОбласти = "СтрокаТаблицы" Тогда
			УправлениеПечатьюOOWriterКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, ОбластьМакета, Данные, Истина, ПереходНаСледСтроку);
		ИначеЕсли	ОписаниеОбласти.ТипОбласти = "Список" Тогда
			УправлениеПечатьюOOWriterКлиент.ПрисоединитьИЗаполнитьКоллекцию(ПечатнаяФорма, ОбластьМакета, Данные, Ложь, ПереходНаСледСтроку);
		Иначе
			ВызватьИсключение(НСтр("ru = 'Тип области не указан или указан не корректно'"));
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Вставляет разрыв между строками в виде символа перевода строки.
// Параметры:
// ПечатнаяФорма - СсылкаПечатнаяФорма
//
Процедура ВставитьРазрывНаНовуюСтроку(Знач ПечатнаяФорма) Экспорт
	
	Если	  ПечатнаяФорма.Тип = "DOC" Тогда
		УправлениеПечатьюMSWordКлиент.ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	ИначеЕсли ПечатнаяФорма.Тип = "ODT" Тогда
		УправлениеПечатьюOOWriterКлиент.ВставитьРазрывНаНовуюСтроку(ПечатнаяФорма);
	КонецЕсли;
	
КонецПроцедуры

// Устарела. Следует использовать ОбластьМакета.
//
Функция ПолучитьОбласть(Знач СсылкаМакет, Знач ОписаниеОбласти) Экспорт
	
	Возврат ОбластьМакета(СсылкаМакет, ОписаниеОбласти);
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Перед выполнением команды печати проверить, был ли передан хотя бы один объект, так как
// для команд с множественным режимом использования может быть передан пустой массив.
Функция ПроверитьКоличествоПереданныхОбъектов(ПараметрКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") И ПараметрКоманды.Количество() = 0 Тогда
		Возврат Ложь;
	Иначе
		Возврат Истина;
	КонецЕсли;
	
КонецФункции

// Возвращает описание команды по имени элемента формы.
// 
// См. УправлениеПечатью.ОписаниеКомандыПечати
//
Функция ОписаниеКомандыПечати(ИмяКоманды, АдресКомандПечатиВоВременномХранилище)
	
	Возврат УправлениеПечатьюКлиентПовтИсп.ОписаниеКомандыПечати(ИмяКоманды, АдресКомандПечатиВоВременномХранилище);
	
КонецФункции

// Открывает форму диалога загрузки файла макета для редактирования во внешней программе.
Процедура РедактироватьМакетВоВнешнейПрограмме(ОписаниеОповещения, ПараметрыМакета, Форма) Экспорт
	ОткрытьФорму("РегистрСведений.ПользовательскиеМакетыПечати.Форма.РедактированиеМакета", ПараметрыМакета, Форма, , , , ОписаниеОповещения);
КонецПроцедуры

#Область ИспользованиеМодальности

// ИспользованиеМодальности

#Если ВебКлиент Тогда
// Устарела. Используется устаревшей функцией ИнициализироватьМакет.
//
// Функция получает файл(ы) c сервера в локальный каталог на диск и возвращает
// имя каталога, в который они были сохранены
// Параметры:
// ПутьККаталогу - строка - путь к каталогу, в который должны быть сохранены файлы
// ПолучаемыеФайлы - соответствие - 
//                         ключ  - имя файла
//                         значение - двоичные данные файла
//
Функция ПолучитьФайлыВКаталогФайловПечати(ПутьККаталогу, ПолучаемыеФайлы) Экспорт
	
	ТребуетсяУстановитьКаталогПечати = Не ЗначениеЗаполнено(ПутьККаталогу);
	Если Не ТребуетсяУстановитьКаталогПечати Тогда
		Файл = Новый Файл(ПутьККаталогу);
		Если НЕ Файл.Существует() Тогда
			ТребуетсяУстановитьКаталогПечати = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Если ТребуетсяУстановитьКаталогПечати Тогда
		ПутьККаталогу = КаталогВременныхФайлов();
	КонецЕсли;
	
	ФайлыВоВременномХранилище = ПолучитьАдресаФайловВоВременномХранилище(ПолучаемыеФайлы);
	
	ОписанияФайлов = Новый Массив;
	
	Для Каждого ФайлВоВременномХранилище Из ФайлыВоВременномХранилище Цикл
		ОписанияФайлов.Добавить(Новый ОписаниеПередаваемогоФайла(ФайлВоВременномХранилище.Ключ,ФайлВоВременномХранилище.Значение));
	КонецЦикла;
	
	Если НЕ ПолучитьФайлы(ОписанияФайлов, , ПутьККаталогу, Ложь) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если Прав(ПутьККаталогу, 1) <> "\" Тогда
		ПутьККаталогу = ПутьККаталогу + "\";
	КонецЕсли;
	
	Возврат ПутьККаталогу;
	
КонецФункции

// Устарела. Используется устаревшей функцией ПолучитьФайлыВКаталогФайловПечати.
// Помещает набор двоичных данных во временное хранилище
// Параметры:
// 	НаборЗначений - соответствие, ключ - ключ, связанный с двоичными данными
// 								  значение - ДвоичныеДанные
// Возвращаемое значение:
// соответствие: ключ - ключ, связанный с адресом во временном хранилище
//               значение - адрес во временном хранилище
//
Функция ПолучитьАдресаФайловВоВременномХранилище(НаборЗначений)
	
	Результат = Новый Соответствие;
	
	Для Каждого КлючЗначение Из НаборЗначений Цикл
		Результат.Вставить(КлючЗначение.Ключ, ПоместитьВоВременноеХранилище(КлючЗначение.Значение));
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции
#КонецЕсли

// Устарела. Следует использовать ПроверитьПроведенностьДокументов.
//
// Выполняет интерактивное проведение документов перед печатью.
// Если есть непроведенные документы, предлагает выполнить проведение. Спрашивает
// пользователя о продолжении, если какие-то из документов не провелись и имеются проведенные.
//
// Параметры
//  ДокументыМассив - Массив           - ссылки на документы, которые требуется провести перед печатью.
//                                       После выполнения функции из массива исключаются непроведенные документы.
//  ФормаИсточник   - УправляемаяФорма - форма, из которой было вызвана команда.
//
// Возвращаемое значение:
//  Булево - есть документы для печати в параметре ДокументыМассив.
//
Функция ПроверитьДокументыПроведены(ДокументыМассив, ФормаИсточник = Неопределено) Экспорт
	
	ОчиститьСообщения();
	ДокументыТребующиеПроведение = ОбщегоНазначенияВызовСервера.ПроверитьПроведенностьДокументов(ДокументыМассив);
	КоличествоНепроведенныхДокументов = ДокументыТребующиеПроведение.Количество();
	
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		
		Если КоличествоНепроведенныхДокументов = 1 Тогда
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документ, его необходимо предварительно провести. Выполнить проведение документа и продолжить?'");
		Иначе
			ТекстВопроса = НСтр("ru = 'Для того чтобы распечатать документы, их необходимо предварительно провести. Выполнить проведение документов и продолжить?'");
		КонецЕсли;
		
		КодОтвета = Вопрос(ТекстВопроса, РежимДиалогаВопрос.ДаНет);
		Если КодОтвета <> КодВозвратаДиалога.Да Тогда
			Возврат Ложь;
		КонецЕсли;
		
		ДанныеОНепроведенныхДокументах = ОбщегоНазначенияВызовСервера.ПровестиДокументы(ДокументыТребующиеПроведение);
		
		// сообщаем о документах, которые не провелись
		ШаблонСообщения = НСтр("ru = 'Документ %1 не проведен: %2 Печать невозможна.'");
		НепроведенныеДокументы = Новый Массив;
		Для Каждого ИнформацияОДокументе Из ДанныеОНепроведенныхДокументах Цикл
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, Строка(ИнформацияОДокументе.Ссылка), 
					ИнформацияОДокументе.ОписаниеОшибки), ИнформацияОДокументе.Ссылка);
			НепроведенныеДокументы.Добавить(ИнформацияОДокументе.Ссылка);		
		КонецЦикла;
		
		КоличествоНепроведенныхДокументов = НепроведенныеДокументы.Количество();
		
		// оповещаем открытые формы о том, что были проведены документы
		ПроведенныеДокументы = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДокументыТребующиеПроведение, НепроведенныеДокументы);
		ТипыПроведенныхДокументов = Новый Соответствие;
		Для Каждого ПроведенныйДокумент Из ПроведенныеДокументы Цикл
			ТипыПроведенныхДокументов.Вставить(ТипЗнч(ПроведенныйДокумент));
		КонецЦикла;
		Для Каждого Тип Из ТипыПроведенныхДокументов Цикл
			ОповеститьОбИзменении(Тип.Ключ);
		КонецЦикла;
		
		// Если команда была вызвана из формы, то зачитываем в форму актуальную (проведенную) копию из базы.
		Если ТипЗнч(ФормаИсточник) = Тип("УправляемаяФорма") Тогда
			Попытка
				ФормаИсточник.Прочитать();	
			Исключение
				// Если метода Прочитать нет, значит печать выполнена не из формы объекта.
			КонецПопытки;
		КонецЕсли;
		
		// обновляем исходный массив документов
		ДокументыМассив = ОбщегоНазначенияКлиентСервер.СократитьМассив(ДокументыМассив, НепроведенныеДокументы);

	КонецЕсли;
	
	ЕстьДокументыКоторыеМожноПечатать = ДокументыМассив.Количество() > 0;
	
	Отказ = Ложь;
	Если КоличествоНепроведенныхДокументов > 0 Тогда
		// спрашиваем пользователя о необходимости продолжения печати при наличии непроведенных документов
		
		ТекстДиалога = НСтр("ru = 'Не удалось провести один или несколько документов.'");
		КнопкиДиалога = Новый СписокЗначений;
		
		Если ЕстьДокументыКоторыеМожноПечатать Тогда
			ТекстДиалога = ТекстДиалога + " " + НСтр("ru = 'Продолжить?'");
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Пропустить, НСтр("ru = 'Продолжить'"));
			КнопкиДиалога.Добавить(КодВозвратаДиалога.Отмена);
		Иначе
			КнопкиДиалога.Добавить(КодВозвратаДиалога.ОК);
		КонецЕсли;
		
		Ответ = Вопрос(ТекстДиалога, КнопкиДиалога);
		Если Ответ <> КодВозвратаДиалога.Пропустить Тогда
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
	Возврат Не Отказ;
	
КонецФункции

// Устарела. Следует использовать процедуру ИнициализироватьМакетОфисногоДокумента.
//
// Создает соединение с макетом. В дальнейшем это соединение используется
// при получении из него областей (тегов и таблиц).
//
// Параметры:
//  ДвоичныеДанныеМакета - ДвоичныеДанные - двоичные данные макета
//  ТипМакета            - Строка - тип макета печатной формы "DOC" или "ODT";
// Возвращаемое значение:
//  Структура.
//
Функция ИнициализироватьМакет(Знач ДвоичныеДанныеМакета, Знач ТипМакета, Знач ПутьККаталогу = "", Знач ИмяМакета = "") Экспорт
	
#Если ВебКлиент Тогда
	ТекстСообщения = НСтр("ru = 'Для продолжения печати необходимо установить расширение работы с файлами.'");
	Если Не ОбщегоНазначенияКлиент.РасширениеРаботыСФайламиПодключено(ТекстСообщения) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Если ПустаяСтрока(ИмяМакета) Тогда
		ИмяВременногоФайла = Строка(Новый УникальныйИдентификатор) + "." + НРег(ТипМакета);
	Иначе
		ИмяВременногоФайла = ИмяМакета + "." + НРег(ТипМакета);
	КонецЕсли;
	
	ПолучаемыеФайлы = Новый Соответствие;
	ПолучаемыеФайлы.Вставить(ИмяВременногоФайла, ДвоичныеДанныеМакета);
	
	Результат = ПолучитьФайлыВКаталогФайловПечати(ПутьККаталогу, ПолучаемыеФайлы);
	
	Если Результат = Неопределено Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИмяВременногоФайла = Результат + ИмяВременногоФайла;
#Иначе
	ИмяВременногоФайла = "";
#КонецЕсли

	Если ВРег(ТипМакета) = "DOC" Тогда
		Макет = УправлениеПечатьюMSWordКлиент.ПолучитьМакетMSWord(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Макет.Вставить("Тип", "DOC");
		Возврат Макет;
	ИначеЕсли ВРег(ТипМакета) = "ODT" Тогда
		Макет = УправлениеПечатьюOOWriterКлиент.ПолучитьМакетOOWriter(ДвоичныеДанныеМакета, ИмяВременногоФайла);
		Макет.Вставить("Тип", "ODT");
		Макет.Вставить("НастройкиСтраницыМакета", Неопределено);
		Возврат Макет;
	КонецЕсли;
	
КонецФункции

// Конец ИспользованиеМодальности

#КонецОбласти

#КонецОбласти
