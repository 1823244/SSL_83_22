﻿&НаКлиенте
Перем ПриведенныйПочтовыйАдрес;

#Область ОбработчикиСобытийФормы

// Заполняет поля формы по переданным в форму параметрам.
//
// В форму могут передаваться следующие параметры:
// УчетнаяЗапись* - СправочникСсылка.УчетныеЗаписиЭлектроннойПочты, список - 
//               ссылка на учетную запись, которая будет использоваться
//               при отправке сообщения, либо список из учетных записей (для выбора).
// Вложения      - соответствие - вложения в письмо, где
//                 ключ     - имя файла
//                 значение - двоичные данные файла.
// Тема          - строка - тема письма.
// Тело          - строка - тело письма.
// Кому          - соответствие/строка - адресаты письма
//                 если тип соответствие, то
//                 ключ     - строка - Имя адресата
//                 значение - строка - электронный адрес в формате addr@server.
//
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ТемаПисьма = Параметры.Тема;
	ТелоПисьма = Параметры.Тело;
	АдресОтвета = Параметры.АдресОтвета;
	
	Если ТипЗнч(Параметры.Вложения) = Тип("СписокЗначений") Или ТипЗнч(Параметры.Вложения) = Тип("Массив") Тогда
		Для Каждого Вложение Из Параметры.Вложения Цикл
			ОписаниеВложения = Вложения.Добавить();
			Если ТипЗнч(Параметры.Вложения) = Тип("СписокЗначений") Тогда
				ОписаниеВложения.Представление = Вложение.Представление;
				Если ТипЗнч(Вложение.Значение) = Тип("ДвоичныеДанные") Тогда
					ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Вложение.Значение, УникальныйИдентификатор);
				Иначе
					Если ЭтоАдресВременногоХранилища(Вложение.Значение) Тогда
						ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПолучитьИзВременногоХранилища(Вложение.Значение), УникальныйИдентификатор);
					Иначе
						ОписаниеВложения.ПутьКФайлу = Вложение.Значение;
					КонецЕсли;
				КонецЕсли;
			Иначе // ТипЗнч(Параметры.Вложения) = "массив структур"
				ЗаполнитьЗначенияСвойств(ОписаниеВложения, Вложение);
				Если Не ПустаяСтрока(ОписаниеВложения.АдресВоВременномХранилище) Тогда
					ОписаниеВложения.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(
						ПолучитьИзВременногоХранилища(ОписаниеВложения.АдресВоВременномХранилище), УникальныйИдентификатор);
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	// Обработка сложных параметров формы (составного типа).
	// УчетнаяЗапись, Кому
	
	Если НЕ ЗначениеЗаполнено(Параметры.УчетнаяЗапись) Тогда
		// Учетная запись не передана - выбираем первую доступную.
		ДоступныеУчетныеЗаписи = РаботаСПочтовымиСообщениями.ДоступныеУчетныеЗаписи(Истина);
		Если ДоступныеУчетныеЗаписи.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не обнаружены доступные учетные записи электронной почты, обратитесь к администратору системы.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
			Возврат;
		КонецЕсли;
		
		УчетнаяЗапись = ДоступныеУчетныеЗаписи[0].Ссылка;
		
	ИначеЕсли ТипЗнч(Параметры.УчетнаяЗапись) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		УчетнаяЗапись = Параметры.УчетнаяЗапись;
		УчетнаяЗаписьУказана = Истина;
	ИначеЕсли ТипЗнч(Параметры.УчетнаяЗапись) = Тип("СписокЗначений") Тогда
		НаборУчетныхЗаписей = Параметры.УчетнаяЗапись;
		
		Если НаборУчетныхЗаписей.Количество() = 0 Тогда
			ТекстСообщения = НСтр("ru = 'Не указаны учетные записи для отправки сообщения, обратитесь к администратору системы.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,, Отказ);
			Возврат;
		КонецЕсли;
		
		Для Каждого ЭлементУчетнаяЗапись Из НаборУчетныхЗаписей Цикл
			Элементы.УчетнаяЗапись.СписокВыбора.Добавить(
										ЭлементУчетнаяЗапись.Значение,
										ЭлементУчетнаяЗапись.Представление);
			Если ЭлементУчетнаяЗапись.Значение.ИспользоватьДляПолучения Тогда
				АдресаОтветаПоУчетнымЗаписям.Добавить(ЭлементУчетнаяЗапись.Значение,
														ПолучитьПочтовыйАдресПоУчетнойЗаписи(ЭлементУчетнаяЗапись.Значение));
			КонецЕсли;
		КонецЦикла;
		
		Элементы.УчетнаяЗапись.СписокВыбора.СортироватьПоПредставлению();
		УчетнаяЗапись = НаборУчетныхЗаписей[0].Значение;
		
		// Для переданного списка учетных записей выбираем их из списка выбора.
		Элементы.УчетнаяЗапись.КнопкаВыпадающегоСписка = Истина;
		
		УчетнаяЗаписьУказана = Истина;
		
		Если Элементы.УчетнаяЗапись.СписокВыбора.Количество() <= 1 Тогда
			Элементы.УчетнаяЗапись.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.Кому) = Тип("СписокЗначений") Тогда
		ПочтовыйАдресПолучателя = "";
		Для Каждого ЭлементПочтовыйАдрес Из Параметры.Кому Цикл
			Если ЗначениеЗаполнено(ЭлементПочтовыйАдрес.Представление) Тогда 
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя
										+ ЭлементПочтовыйАдрес.Представление
										+ " <"
										+ ЭлементПочтовыйАдрес.Значение
										+ ">; "
			Иначе
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя 
										+ ЭлементПочтовыйАдрес.Значение
										+ "; ";
			КонецЕсли;
		КонецЦикла;
	ИначеЕсли ТипЗнч(Параметры.Кому) = Тип("Строка") Тогда
		ПочтовыйАдресПолучателя = Параметры.Кому;
	ИначеЕсли ТипЗнч(Параметры.Кому) = Тип("Массив") Тогда
		Для Каждого СтруктураПолучателя Из Параметры.Кому Цикл
			МассивАдресов = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтруктураПолучателя.Адрес, ";");
			Для Каждого Адрес Из МассивАдресов Цикл
				Если ПустаяСтрока(Адрес) Тогда 
					Продолжить;
				КонецЕсли;
				ПочтовыйАдресПолучателя = ПочтовыйАдресПолучателя + СтруктураПолучателя.Представление + " <" + СокрЛП(Адрес) + ">; ";
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	// Получаем список адресов, которые пользователь использовал ранее.
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма", 
		"СписокАдресовОтвета");
	
	Если СписокАдресовОтвета <> Неопределено И СписокАдресовОтвета.Количество() > 0 Тогда
		Для Каждого ЭлементаАдресОтвета Из СписокАдресовОтвета Цикл
			Элементы.АдресОтвета.СписокВыбора.Добавить(ЭлементаАдресОтвета.Значение, ЭлементаАдресОтвета.Представление);
		КонецЦикла;
		
		Элементы.АдресОтвета.КнопкаВыпадающегоСписка = Истина;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	Иначе
		Если УчетнаяЗапись.ИспользоватьДляПолучения Тогда
			// Устанавливаем почтовый адрес по умолчанию.
			Если ЗначениеЗаполнено(УчетнаяЗапись.ИмяПользователя) Тогда 
				АдресОтвета = УчетнаяЗапись.ИмяПользователя + " <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">";
			Иначе
				АдресОтвета = УчетнаяЗапись.АдресЭлектроннойПочты;
			КонецЕсли;
		КонецЕсли;
		
		АвтоматическаяПодстановкаАдресаОтвета = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	ЗагрузитьВложенияИзФайлов();
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура УчетнаяЗаписьНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если УчетнаяЗаписьУказана Тогда
		// Если учетная запись была передана в качестве параметра
		// не позволяем выбрать другую.
		СтандартнаяОбработка = Ложь;
	КонецЕсли;
	
КонецПроцедуры

// Подставляет адрес ответа, если флаг автоматической подстановки ответа установлен.
//
&НаКлиенте
Процедура УчетнаяЗаписьОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если АвтоматическаяПодстановкаАдресаОтвета Тогда
		Если АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение) <> Неопределено Тогда
			АдресОтвета = АдресаОтветаПоУчетнымЗаписям.НайтиПоЗначению(ВыбранноеЗначение).Представление;
		Иначе
			АдресОтвета = ПолучитьПочтовыйАдресПоУчетнойЗаписи(ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыВложения

// Удаляет вложение из списка, а так же вызывает функцию
// обновления таблицы представления вложений.
//
&НаКлиенте
Процедура ВложенияПередУдалением(Элемент, Отказ)
	
	НаименованиеВложения = Элемент.ТекущиеДанные[Элемент.ТекущийЭлемент.Имя];
	
	Для Каждого Вложение Из Вложения Цикл
		Если Вложение.Представление = НаименованиеВложения Тогда
			Вложения.Удалить(Вложение);
		КонецЕсли;
	КонецЦикла;
	
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ОткрытьВложение();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПроверкаПеретаскивания(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	СтандартнаяОбработка = Ложь;
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскивание(Элемент, ПараметрыПеретаскивания, СтандартнаяОбработка, Строка, Поле)
	
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ПараметрыПеретаскивания.Значение) = Тип("Файл") Тогда
		ОписаниеОповещения = Новый ОписаниеОповещения("ВложенияПеретаскиваниеЗавершение", ЭтотОбъект, Новый Структура("Имя", ПараметрыПеретаскивания.Значение.Имя));
		НачатьПомещениеФайла(ОписаниеОповещения, , ПараметрыПеретаскивания.Значение.ПолноеИмя, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, СтандартнаяОбработка)
	
	Если АвтоматическаяПодстановкаАдресаОтвета Тогда
		Если Не ЗначениеЗаполнено(АдресОтвета)
		 ИЛИ Не ЗначениеЗаполнено(Текст) Тогда
			АвтоматическаяПодстановкаАдресаОтвета = Ложь;
		Иначе
			АдресСоответствие1 = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресОтвета);
			Попытка
				АдресСоответствие2 = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Текст);
			Исключение
				СообщениеОбОшибке = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СообщениеОбОшибке, , "АдресОтвета");
				СтандартнаяОбработка = Ложь;
				Возврат;
			КонецПопытки;
				
			Если НЕ EMAILАдресаОдинаковы(АдресСоответствие1, АдресСоответствие2) Тогда
				АвтоматическаяПодстановкаАдресаОтвета = Ложь;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
	АдресОтвета = ПолучитьПриведенныйПочтовыйАдресВФормате(Текст);
	
КонецПроцедуры

// Снимает флаг авто подстановки адреса ответа.
//
&НаКлиенте
Процедура АдресОтветаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	АвтоматическаяПодстановкаАдресаОтвета = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура АдресОтветаОчистка(Элемент, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	АктуализироватьАдресОтветаВХранимомСписке(АдресОтвета, Ложь);
	
	Для Каждого ЭлементаАдресОтвета Из Элементы.АдресОтвета.СписокВыбора Цикл
		Если ЭлементаАдресОтвета.Значение = АдресОтвета
		   И ЭлементаАдресОтвета.Представление = АдресОтвета Тогда
			Элементы.АдресОтвета.СписокВыбора.Удалить(ЭлементаАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	АдресОтвета = "";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОткрытьФайл(Команда)
	ОткрытьВложение();
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьПисьмо()
	
	ОчиститьСообщения();
	
	Попытка
		ПриведенныйПочтовыйАдрес = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(ПочтовыйАдресПолучателя);
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
				ПочтовыйАдресПолучателя);
		Возврат;
	КонецПопытки;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		Попытка
			ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(АдресОтвета);
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					КраткоеПредставлениеОшибки(ИнформацияОбОшибке()), ,
					"АдресОтвета");
			Возврат;
		КонецПопытки;
	КонецЕсли;
	
	ПродолжитьОтправкуПисьмаСПаролем();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриложитьФайлВыполнить()
	
	ДобавитьФайлВоВложения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// СЕКЦИЯ ОБРАБОТЧИКОВ СОБЫТИЙ ФОРМЫ И ЭЛЕМЕНТОВ ФОРМЫ
//

&НаСервереБезКонтекста
Функция ОтправитьПочтовоеСообщение(Знач УчетнаяЗапись, Знач ПараметрыПисьма)
	
	Возврат РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьПочтовыйАдресПоУчетнойЗаписи(Знач УчетнаяЗапись)
	
	Возврат СокрЛП(УчетнаяЗапись.ИмяПользователя)
			+ ? (ПустаяСтрока(СокрЛП(УчетнаяЗапись.ИмяПользователя)),
					УчетнаяЗапись.АдресЭлектроннойПочты,
					" <" + УчетнаяЗапись.АдресЭлектроннойПочты + ">");
	
КонецФункции

&НаКлиенте
Процедура ОткрытьВложение()
	
	ВыбранноеВложение = ВыбранноеВложение();
	Если ВыбранноеВложение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	#Если ВебКлиент Тогда
		ПолучитьФайл(ВыбранноеВложение.АдресВоВременномХранилище, ВыбранноеВложение.Представление, Истина);
	#Иначе
		ИмяВременнойПапки = ПолучитьИмяВременногоФайла();
		СоздатьКаталог(ИмяВременнойПапки);
		
		ИмяВременногоФайла = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ИмяВременнойПапки) + ВыбранноеВложение.Представление;
		
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ВыбранноеВложение.АдресВоВременномХранилище);
		ДвоичныеДанные.Записать(ИмяВременногоФайла);
		
		Файл = Новый Файл(ИмяВременногоФайла);
		Файл.УстановитьТолькоЧтение(Истина);
		Если Файл.Расширение = ".mxl" Тогда
			ТабличныйДокумент = ПолучитьТабличныйДокументПоДвоичнымДанным(ВыбранноеВложение.АдресВоВременномХранилище);
			ПараметрыОткрытия = Новый Структура;
			ПараметрыОткрытия.Вставить("ИмяДокумента", ВыбранноеВложение.Представление);
			ПараметрыОткрытия.Вставить("ТабличныйДокумент", ТабличныйДокумент);
			ПараметрыОткрытия.Вставить("ПутьКФайлу", ИмяВременногоФайла);
			ОткрытьФорму("ОбщаяФорма.РедактированиеТабличногоДокумента", ПараметрыОткрытия, ЭтотОбъект);
		Иначе
			ЗапуститьПриложение(ИмяВременногоФайла);
		КонецЕсли;
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранноеВложение()
	
	Результат = Неопределено;
	Если Элементы.Вложения.ТекущиеДанные <> Неопределено Тогда
		НаименованиеВложения = Элементы.Вложения.ТекущиеДанные[Элементы.Вложения.ТекущийЭлемент.Имя];
		Для Каждого Вложение Из Вложения Цикл
			Если Вложение.Представление = НаименованиеВложения Тогда
				Результат = Вложение;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТабличныйДокументПоДвоичнымДанным(Знач ДвоичныеДанные)
	
	Если ТипЗнч(ДвоичныеДанные) = Тип("Строка") Тогда
		// Передан адрес двоичных данных во временном хранилище.
		ДвоичныеДанные = ПолучитьИзВременногоХранилища(ДвоичныеДанные);
	КонецЕсли;
	
	ИмяФайла = ПолучитьИмяВременногоФайла("mxl");
	ДвоичныеДанные.Записать(ИмяФайла);
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.Прочитать(ИмяФайла);
	
	Попытка
		УдалитьФайлы(ИмяФайла);
	Исключение
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Получение табличного документа'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()), УровеньЖурналаРегистрации.Ошибка, , , 
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	
	Возврат ТабличныйДокумент;
	
КонецФункции

&НаКлиенте
Процедура ДобавитьФайлВоВложения()
	ПараметрыДиалога = Новый Структура;
	ПараметрыДиалога.Вставить("Режим", РежимДиалогаВыбораФайла.Открытие);
	ПараметрыДиалога.Вставить("МножественныйВыбор", Истина);
	ОписаниеОповещения = Новый ОписаниеОповещения("ДобавитьФайлВоВложенияПриПомещенииФайлов", ЭтотОбъект);
	СтандартныеПодсистемыКлиент.ПоказатьПомещениеФайла(ОписаниеОповещения, УникальныйИдентификатор, "", ПараметрыДиалога);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлВоВложенияПриПомещенииФайлов(ПомещенныеФайлы, ДополнительныеПараметры) Экспорт
	Если ПомещенныеФайлы = Неопределено Или ПомещенныеФайлы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	ДобавитьФайлыВСписок(ПомещенныеФайлы);
	ОбновитьПредставлениеВложений();
КонецПроцедуры

&НаСервере
Процедура ДобавитьФайлыВСписок(ПомещенныеФайлы)
	
	Для Каждого ОписаниеФайла Из ПомещенныеФайлы Цикл
		Файл = Новый Файл(ОписаниеФайла.Имя);
		Вложение = Вложения.Добавить();
		Вложение.Представление = Файл.Имя;
		Вложение.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ПолучитьИзВременногоХранилища(ОписаниеФайла.Хранение), УникальныйИдентификатор);
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьПредставлениеВложений()
	
	ПредставлениеВложений.Очистить();
	
	Индекс = 0;
	
	Для Каждого Вложение Из Вложения Цикл
		Если Индекс = 0 Тогда
			СтрокаПредставления = ПредставлениеВложений.Добавить();
		КонецЕсли;
		
		СтрокаПредставления["Вложение" + Строка(Индекс + 1)] = Вложение.Представление;
		
		Индекс = Индекс + 1;
		Если Индекс = 2 Тогда 
			Индекс = 0;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

// Проверяет возможность отправления письма и если
// это возможно - формирует параметры отправки.
//
&НаКлиенте
Функция СформироватьПараметрыПисьма()
	
	ПараметрыПисьма = Новый Структура;
	
	Если ЗначениеЗаполнено(ПриведенныйПочтовыйАдрес) Тогда
		ПараметрыПисьма.Вставить("Кому", ПриведенныйПочтовыйАдрес);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(АдресОтвета) Тогда
		ПараметрыПисьма.Вставить("АдресОтвета", АдресОтвета);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТемаПисьма) Тогда
		ПараметрыПисьма.Вставить("Тема", ТемаПисьма);
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТелоПисьма) Тогда
		ПараметрыПисьма.Вставить("Тело", ТелоПисьма);
	КонецЕсли;
	
	ПараметрыПисьма.Вставить("Вложения", Вложения());
	
	Возврат ПараметрыПисьма;
	
КонецФункции

&НаКлиенте
Функция Вложения()
	
	Результат = Новый Массив;
	Для Каждого Вложение Из Вложения Цикл
		ОписаниеВложения = Новый Структура;
		ОписаниеВложения.Вставить("Представление", Вложение.Представление);
		ОписаниеВложения.Вставить("АдресВоВременномХранилище", Вложение.АдресВоВременномХранилище);
		ОписаниеВложения.Вставить("Кодировка", Вложение.Кодировка);
		Результат.Добавить(ОписаниеВложения);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

// Добавляет адрес ответа в список сохраняемых значений.
//
&НаСервереБезКонтекста
Функция СохранитьАдресОтвета(Знач АдресОтвета)
	
	АктуализироватьАдресОтветаВХранимомСписке(АдресОтвета);
	
КонецФункции

// Добавляет адрес ответа в список сохраняемых значений.
//
&НаСервереБезКонтекста
Функция АктуализироватьАдресОтветаВХранимомСписке(Знач АдресОтвета,
                                                   Знач ДобавлятьАдресВСписок = Истина)
	
	// Получаем список адресов, которые пользователь использовал ранее.
	СписокАдресовОтвета = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета");
	
	Если СписокАдресовОтвета = Неопределено Тогда
		СписокАдресовОтвета = Новый СписокЗначений();
	КонецЕсли;
	
	Для Каждого ЭлементАдресОтвета Из СписокАдресовОтвета Цикл
		Если ЭлементАдресОтвета.Значение = АдресОтвета
		   И ЭлементАдресОтвета.Представление = АдресОтвета Тогда
			СписокАдресовОтвета.Удалить(ЭлементАдресОтвета);
		КонецЕсли;
	КонецЦикла;
	
	Если ДобавлятьАдресВСписок
	   И ЗначениеЗаполнено(АдресОтвета) Тогда
		СписокАдресовОтвета.Вставить(0, АдресОтвета, АдресОтвета);
	КонецЕсли;
	
	ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
		"РедактированиеНовогоПисьма",
		"СписокАдресовОтвета",
		СписокАдресовОтвета);
	
КонецФункции

// Сравнивает два e-mail адреса.
// Параметры:
// АдресСоответствие1 - строка - первый e-mail адрес.
// АдресСоответствие2 - строка - второй e-mail адрес.
// Возвращаемое значение
// Истина, или Ложь в зависимости от того одинаковы ли e-mail адреса.
//
&НаКлиенте
Функция EMAILАдресаОдинаковы(АдресСоответствие1, АдресСоответствие2)
	
	Если АдресСоответствие1.Количество() <> 1
	 Или АдресСоответствие2.Количество() <> 1 Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Если АдресСоответствие1[0].Представление = АдресСоответствие2[0].Представление
	   И АдресСоответствие1[0].Адрес         = АдресСоответствие2[0].Адрес Тогда
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ПолучитьПриведенныйПочтовыйАдресВФормате(Текст)
	
	ПочтовыйАдрес = "";
	
	МассивАдресов = ОбщегоНазначенияКлиентСервер.РазобратьСтрокуСПочтовымиАдресами(Текст);
	
	Для Каждого ЭлементАдрес Из МассивАдресов Цикл
		Если ЗначениеЗаполнено(ЭлементАдрес.Представление) Тогда 
			ПочтовыйАдрес = ПочтовыйАдрес + ЭлементАдрес.Представление
							+ ? (ПустаяСтрока(СокрЛП(ЭлементАдрес.Адрес)), "", " <" + ЭлементАдрес.Адрес + ">");
		Иначе
			ПочтовыйАдрес = ПочтовыйАдрес + ЭлементАдрес.Адрес + "; ";
		КонецЕсли;
	КонецЦикла;
		
	Возврат ПочтовыйАдрес;
	
КонецФункции

&НаКлиенте
Процедура ПродолжитьОтправкуПисьмаСПаролем()
	
	ПараметрыПисьма = СформироватьПараметрыПисьма();
	
	Если ПараметрыПисьма = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Ошибка формирования параметров почтового сообщения'"));
		Возврат;
	КонецЕсли;
	
	ОтправитьПочтовоеСообщение(УчетнаяЗапись, ПараметрыПисьма);
	СохранитьАдресОтвета(АдресОтвета);
	Состояние(НСтр("ru = 'Сообщение успешно отправлено'"));
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВложенияПеретаскиваниеЗавершение(Результат, АдресВременногоХранилища, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	
	Файлы = Новый Массив;
	ПередаваемыйФайл = Новый ОписаниеПередаваемогоФайла(ДополнительныеПараметры.Имя, АдресВременногоХранилища);
	Файлы.Добавить(ПередаваемыйФайл);
	ДобавитьФайлыВСписок(Файлы);
	ОбновитьПредставлениеВложений();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьВложенияИзФайлов()
	
	Для Каждого Вложение Из Вложения Цикл
		Если Не ПустаяСтрока(Вложение.ПутьКФайлу) Тогда
			ДвоичныеДанные = Новый ДвоичныеДанные(Вложение.ПутьКФайлу);
			Вложение.АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанные, УникальныйИдентификатор);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти
