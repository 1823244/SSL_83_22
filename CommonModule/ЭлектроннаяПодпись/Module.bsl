﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Электронная подпись".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Возвращает текущую настройку использования электронных подписей.
Функция ИспользоватьЭлектронныеПодписи() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ИспользоватьЭлектронныеПодписи;
	
КонецФункции

// Возвращает текущую настройку использования шифрования.
Функция ИспользоватьШифрование() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ИспользоватьШифрование;
	
КонецФункции

// Возвращает текущую настройку проверки электронных подписей на сервере.
Функция ПроверятьЭлектронныеПодписиНаСервере() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().ПроверятьЭлектронныеПодписиНаСервере;
	
КонецФункции

// Возвращает текущую настройку создания электронных подписей на сервере.
// Настройка также предполагает шифрование и расшифровку на сервере.
//
Функция СоздаватьЭлектронныеПодписиНаСервере() Экспорт
	
	Возврат ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки().СоздаватьЭлектронныеПодписиНаСервере;
	
КонецФункции


// Возвращает менеджер криптографии (на сервере) для указанной программы.
//
// Параметры:
//  Операция       - Строка - если не пустая, то должна содержать одну из строк, которые определяют
//                   операцию для вставки в описание ошибки: Подписание, ПроверкаПодписи, Шифрование,
//                   Расшифровка, ПроверкаСертификата, ПолучениеСертификатов.
//
//  ПоказатьОшибку - Булево - если Истина, тогда будет вызвано исключение, содержащее описание ошибки.
//
//  ОписаниеОшибки - Строка - возвращаемое описание ошибки, когда функция возвратила значение Неопределено.
//
//  Программа      - Неопределено - возвращает менеджер криптографии первой
//                   программы из справочника для которой удалось его создать.
//                 - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - программа
//                   для которой нужно создать и вернуть менеджер криптографии.
//
// Возвращаемое значение:
//   МенеджерКриптографии - менеджер криптографии.
//   Неопределено - произошла ошибка, описание которой в параметре ОписаниеОшибки.
//
Функция МенеджерКриптографии(Операция, ПоказатьОшибку = Истина, ОписаниеОшибки = "", Программа = Неопределено) Экспорт
	
	Ошибка = "";
	Результат = ЭлектроннаяПодписьСлужебный.МенеджерКриптографии(Операция, ПоказатьОшибку, Ошибка, Программа);
	
	Если Результат = Неопределено Тогда
		ОписаниеОшибки = Ошибка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Проверяет действительность подписи и сертификата.
//
// Параметры:
//   МенеджерКриптографии - Неопределено - получить менеджер криптографии для проверки
//                          электронных подписей, как настроил администратор.
//                        - МенеджерКриптографии - использовать указанный менеджер криптографии.
//
//   ИсходныеДанные       - ДвоичныеДанные - двоичные данные, которые были подписаны.
//                        - Строка         - адрес временного хранилища, содержащего двоичные данные.
//                        - Строка         - полное имя файла, содержащего двоичные данные,
//                                           которые были подписаны.
//
//   Подпись              - ДвоичныеДанные - двоичные данные электронной подписи.
//                        - Строка         - адрес временного хранилища, содержащего двоичные данные.
//                        - Строка         - полное имя файла, содержащего двоичные данные
//                                           электронной подписи.
//
//   ОписаниеОшибки       - Null - вызвать исключение при ошибке проверки.
//                        - Строка - содержит описание ошибки, если произошла ошибка.
// 
// Возвращаемое значение:
//  Булево - Истина, если проверка выполнена успешно.
//         - Ложь,   если не удалось получить менеджер криптографии (когда не указан),
//                   или произошла ошибка указанная в параметре ОписаниеОшибки.
//
Функция ПроверитьПодпись(МенеджерКриптографии, ИсходныеДанные, Подпись, ОписаниеОшибки = Null) Экспорт
	
	МенеджерКриптографииДляПроверки = МенеджерКриптографии;
	Если МенеджерКриптографииДляПроверки = Неопределено Тогда
		МенеджерКриптографииДляПроверки = МенеджерКриптографии("ПроверкаПодписи", ОписаниеОшибки = Null, ОписаниеОшибки);
		Если МенеджерКриптографииДляПроверки = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	ИсходныеДанныеДляПроверки = ИсходныеДанные;
	Если ТипЗнч(ИсходныеДанные) = Тип("Строка") И ЭтоАдресВременногоХранилища(ИсходныеДанные) Тогда
		ИсходныеДанныеДляПроверки = ПолучитьИзВременногоХранилища(ИсходныеДанные);
	КонецЕсли;
	
	ПодписьДляПроверки = Подпись;
	Если ТипЗнч(Подпись) = Тип("Строка") И ЭтоАдресВременногоХранилища(Подпись) Тогда
		ПодписьДляПроверки = ПолучитьИзВременногоХранилища(Подпись);
	КонецЕсли;
	
	Сертификат = Неопределено;
	Попытка
		МенеджерКриптографииДляПроверки.ПроверитьПодпись(ИсходныеДанныеДляПроверки, ПодписьДляПроверки, Сертификат);
	Исключение
		Если ОписаниеОшибки = Null Тогда
			ВызватьИсключение;
		КонецЕсли;
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	Если Не ПроверитьСертификат(МенеджерКриптографииДляПроверки, Сертификат, ОписаниеОшибки) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
	
КонецФункции

// Проверяет действительность сертификата криптографии.
//
// Параметры:
//   МенеджерКриптографии - Неопределено - получить менеджер криптографии автоматически.
//                        - МенеджерКриптографии - использовать указанный менеджер криптографии.
//
//   Сертификат           - СертификатКриптографии - сертификат.
//                        - ДвоичныеДанные - двоичные данные сертификата.
//                        - Строка - адрес временного хранилища, содержащего двоичные данные сертификата.
//
//   ОписаниеОшибки       - Null - вызвать исключение при ошибке проверки.
//                        - Строка - содержит описание ошибки, если произошла ошибка.
//
// Возвращаемое значение:
//  Булево - Истина, если проверка выполнена успешно,
//         - Ложь, если не удалось получить менеджер криптографии (когда не указан).
//
Функция ПроверитьСертификат(МенеджерКриптографии, Сертификат, ОписаниеОшибки = Null) Экспорт
	
	МенеджерКриптографииДляПроверки = МенеджерКриптографии;
	
	Если МенеджерКриптографииДляПроверки = Неопределено Тогда
		МенеджерКриптографииДляПроверки = МенеджерКриптографии("ПроверкаСертификата", ОписаниеОшибки = Null, ОписаниеОшибки);
		Если МенеджерКриптографииДляПроверки = Неопределено Тогда
			Возврат Ложь;
		КонецЕсли;
	КонецЕсли;
	
	СертификатДляПроверки = Сертификат;
	
	Если ТипЗнч(Сертификат) = Тип("Строка") Тогда
		СертификатДляПроверки = ПолучитьИзВременногоХранилища(Сертификат);
	КонецЕсли;
	
	Если ТипЗнч(СертификатДляПроверки) = Тип("ДвоичныеДанные") Тогда
		СертификатДляПроверки = Новый СертификатКриптографии(СертификатДляПроверки);
	КонецЕсли;
	
	РежимыПроверкиСертификата = ЭлектроннаяПодписьСлужебныйКлиентСервер.РежимыПроверкиСертификата();
	
	Попытка
		МенеджерКриптографииДляПроверки.ПроверитьСертификат(СертификатДляПроверки, РежимыПроверкиСертификата);
	Исключение
		ОписаниеОшибки = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
		Возврат Ложь;
	КонецПопытки;
	
	Возврат Истина;
	
КонецФункции

// Находит сертификат на компьютере по строке отпечатка.
//
// Параметры:
//   Отпечаток              - Строка - Base64 кодированный отпечаток сертификата.
//   ТолькоВЛичномХранилище - Булево - если Истина, тогда искать в личном хранилище, иначе везде.
//
// Возвращаемое значение:
//   СертификатКриптографии - сертификат электронной подписи и шифрования.
//   Неопределено - сертификат не найден в хранилище.
//
Функция ПолучитьСертификатПоОтпечатку(Отпечаток, ТолькоВЛичномХранилище) Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебный.ПолучитьСертификатПоОтпечатку(Отпечаток, ТолькоВЛичномХранилище);
	
КонецФункции

// Добавляет подпись в табличную часть объекта и записывает его.
// Устанавливает реквизиту ПодписанЭП значение Истина.
// 
// Параметры:
//  Объект - Ссылка - по ссылке будет получен объект, заблокирован, изменен, записан.
//                    Объект должен иметь табличную часть ЭлектронныеПодписи и реквизит ПодписанЭП.
//         - Объект - объект будет изменен без блокировки и без записи.
//
//  СвойстваПодписи - Массив - массив описанных ниже структур или адресов структур.
//                  - Строка - адрес временного хранилища, содержащий описанную ниже структуру.
//                  - Структура - развернутое описание подписи:
//     * Подпись             - ДвоичныеДанные - результат подписания.
//     * УстановившийПодпись - СправочникСсылка.Пользователи - пользователь, который
//                                подписал объект информационной базы.
//     * Комментарий         - Строка - комментарий, если он был введен при подписании.
//     * ИмяФайлаПодписи     - Строка - если подпись добавлена из файла.
//     * ДатаПодписи         - Дата   - дата, когда подпись была сделана. Имеет смысл для случая,
//                                      когда дату невозможно извлечь из данных подписи. Если не
//                                      указана или пустая, тогда используется текущая дата сеанса.
//     Производные свойства:
//     * Сертификат          - ДвоичныеДанные - содержит выгрузку сертификата,
//                                который использовался для подписания (содержится в подписи).
//     * Отпечаток           - Строка - отпечаток сертификата в формате строки Base64.
//     * КомуВыданСертификат - Строка - представление субъекта, полученное из двоичных данных сертификата.
//
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, используемый для блокировки,
//                       если передана ссылка на объект.
//
//  ВерсияОбъекта      - Строка - версия данных объекта, если передана ссылка на объект. Используемая
//                       для блокировки объекта перед записью, с учетом того, что подписание
//                       выполняется на клиенте и за время подписания объект мог быть изменен.
//
//  ЗаписанныйОбъект   - Объект - объект, который был получен и записан, если передавалась ссылка.
//
Процедура ДобавитьПодпись(Объект, Знач СвойстваПодписи, ИдентификаторФормы = Неопределено,
			ВерсияОбъекта = Неопределено, ЗаписанныйОбъект = Неопределено) Экспорт
	
	Если ТипЗнч(СвойстваПодписи) = Тип("Строка") Тогда
		СвойстваПодписи = ПолучитьИзВременногоХранилища(СвойстваПодписи);
		
	ИначеЕсли ТипЗнч(СвойстваПодписи) = Тип("Массив") Тогда
		ИндексПоследнего = СвойстваПодписи.Количество()-1;
		Для Индекс = 0 По ИндексПоследнего Цикл
			Если ТипЗнч(СвойстваПодписи[Индекс]) = Тип("Строка") Тогда
				СвойстваПодписи[Индекс] = ПолучитьИзВременногоХранилища(СвойстваПодписи[Индекс]);
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			ЗаблокироватьДанныеДляРедактирования(Объект, ВерсияОбъекта, ИдентификаторФормы);
			ОбъектДанных = Объект.ПолучитьОбъект();
		Иначе
			ОбъектДанных = Объект;
		КонецЕсли;
		
		Если ТипЗнч(СвойстваПодписи) = Тип("Массив") Тогда
			Для каждого ТекущиеСвойства Из СвойстваПодписи Цикл
				ДобавитьСтрокуПодписи(ОбъектДанных, ТекущиеСвойства);
			КонецЦикла;
		Иначе
			ДобавитьСтрокуПодписи(ОбъектДанных, СвойстваПодписи);
		КонецЕсли;
		
		ОбъектДанных.ПодписанЭП = Истина;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			// Чтобы определить, что это запись с целью добавления/удаления подписи.
			ОбъектДанных.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
			ОбъектДанных.Записать();
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, ИдентификаторФормы);
			ЗаписанныйОбъект = ОбъектДанных;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Помещает сертификаты шифрования в табличную часть объекта и записывает его.
// Устанавливает реквизит Зашифрован по наличию строк в табличной части.
// 
// Параметры:
//  Объект - Ссылка - по ссылке будет получен объект, заблокирован, изменен, записан.
//                    Объект должен иметь табличную часть СертификатыШифрования и реквизит Зашифрован.
//         - Объект - объект будет изменен без блокировки и без записи.
//
//  СертификатыШифрования - Строка - адрес временного хранилища, содержащий описанный ниже массив.
//                        - Массив - массив описанных ниже структур:
//                             * Отпечаток     - Строка - отпечаток сертификата в формате строки Base64.
//                             * Представление - Строка - сохраненное представление субъекта,
//                                                  полученное из двоичных данных сертификата.
//                             * Сертификат    - ДвоичныеДанные - содержит выгрузку сертификата,
//                                                  который использовался для шифрования.
//
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, используемый для блокировки,
//                       если передана ссылка на объект.
//
//  ВерсияОбъекта      - Строка - версия данных объекта, если передана ссылка на объект. Используемая
//                       для блокировки объекта перед записью, с учетом того, что подписание
//                       выполняется на клиенте и за время подписания объект мог быть изменен.
//
//  ЗаписанныйОбъект   - Объект - объект, который был получен и записан, если передавалась ссылка.
//
Процедура ЗаписатьСертификатыШифрования(Объект, Знач СертификатыШифрования, ИдентификаторФормы = Неопределено,
			ВерсияОбъекта = Неопределено, ЗаписанныйОбъект = Неопределено) Экспорт
	
	Если ТипЗнч(СертификатыШифрования) = Тип("Строка") Тогда
		СертификатыШифрования = ПолучитьИзВременногоХранилища(СертификатыШифрования);
	КонецЕсли;
	
	НачатьТранзакцию();
	Попытка
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			ЗаблокироватьДанныеДляРедактирования(Объект, ВерсияОбъекта, ИдентификаторФормы);
			ОбъектДанных = Объект.ПолучитьОбъект();
		Иначе
			ОбъектДанных = Объект;
		КонецЕсли;
		
		ОбъектДанных.СертификатыШифрования.Очистить();
		
		Для каждого СертификатШифрования Из СертификатыШифрования Цикл
			ЗаполнитьЗначенияСвойств(ОбъектДанных.СертификатыШифрования.Добавить(), СертификатШифрования);
		КонецЦикла;
		
		ОбъектДанных.Зашифрован = ОбъектДанных.СертификатыШифрования.Количество() > 0;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			// Чтобы определить, что это запись с целью шифрования/расшифровки.
			ОбъектДанных.ДополнительныеСвойства.Вставить("ЗаписьПриШифрованииРасшифровкеОбъекта", Истина);
			ОбъектДанных.Записать();
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, ИдентификаторФормы);
			ЗаписанныйОбъект = ОбъектДанных;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Удалят подпись из табличной части объекта и записывает его.
// 
// Параметры:
//  Объект - Ссылка - по ссылке будет получен объект, заблокирован, изменен, записан.
//                    Объект должен иметь табличную часть ЭлектронныеПодписи и реквизит ПодписанЭП.
//         - Объект - объект будет изменен без блокировки и без записи.
// 
//  ИдентификаторПодписи - Число - индекс строки табличной части.
//                       - Массив - значения указанного выше типа.
//
//  ИдентификаторФормы - УникальныйИдентификатор - идентификатор формы, используемый для блокировки,
//                       если передана ссылка на объект.
//
//  ВерсияОбъекта      - Строка - версия данных объекта, если передана ссылка на объект. Используемая
//                       для блокировки объекта перед записью, с учетом того, что подписание
//                       выполняется на клиенте и за время подписания объект мог быть изменен.
//
//  ЗаписанныйОбъект   - Объект - объект, который был получен и записан, если передавалась ссылка.
//
Процедура УдалитьПодпись(Объект, ИдентификаторПодписи, ИдентификаторФормы = Неопределено,
			ВерсияОбъекта = Неопределено, ЗаписанныйОбъект = Неопределено) Экспорт
	
	НачатьТранзакцию();
	Попытка
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			ЗаблокироватьДанныеДляРедактирования(Объект, ВерсияОбъекта, ИдентификаторФормы);
			ОбъектДанных = Объект.ПолучитьОбъект();
		Иначе
			ОбъектДанных = Объект;
		КонецЕсли;
		
		Если ТипЗнч(ИдентификаторПодписи) = Тип("Массив") Тогда
			Список = Новый СписокЗначений;
			Список.ЗагрузитьЗначения(ИдентификаторПодписи);
			Список.СортироватьПоЗначению(НаправлениеСортировки.Убыв);
			Для каждого ЭлементСписка Из Список Цикл
				УдалитьСтрокуПодписи(ОбъектДанных, ЭлементСписка.Значение);
			КонецЦикла;
		Иначе
			УдалитьСтрокуПодписи(ОбъектДанных, ИдентификаторПодписи);
		КонецЕсли;
		
		ОбъектДанных.ПодписанЭП = ОбъектДанных.ЭлектронныеПодписи.Количество() <> 0;
		
		Если ОбщегоНазначения.ЭтоСсылка(ТипЗнч(Объект)) Тогда
			// Чтобы определить, что это запись с целью добавления/удаления подписи.
			ОбъектДанных.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
			ОбъектДанных.Записать();
			РазблокироватьДанныеДляРедактирования(Объект.Ссылка, ИдентификаторФормы);
			ЗаписанныйОбъект = ОбъектДанных;
		КонецЕсли;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

// Возвращает дату, извлеченную из двоичных данных подписи или Неопределено.
//
// Параметры:
//  Подпись - ДвоичныеДанные - данные подписи из которых нужно извлечь дату.
//  ПривестиКЧасовомуПоясуСеанса - Булево - привести универсальное время к времени сеанса.
//
// Возвращаемое значение:
//  Дата - успешно извлеченная дата подписи.
//  Неопределено - не удалось извлечь дату из данных подписи.
//
Функция ДатаПодписания(Подпись, ПривестиКЧасовомуПоясуСеанса = Истина) Экспорт
	
	ДатаПодписания = Неопределено;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Подпись.Записать(ИмяВременногоФайла);
	
	ЧтениеТекста = Новый ЧтениеТекста(ИмяВременногоФайла);
	Символ = ЧтениеТекста.Прочитать(1);
	
	Пока Символ <> Неопределено Цикл
		Если КодСимвола(Символ) = 15 Тогда
			Символ = ЧтениеТекста.Прочитать(2);
			Если КодСимвола(Символ, 1) = 23 И КодСимвола(Символ, 2) = 13 Тогда
				ДатаСтрокой = ЧтениеТекста.Прочитать(12);
				ДатаПодписания = Дата("20" + ДатаСтрокой);
				Если ПривестиКЧасовомуПоясуСеанса Тогда
					ДатаПодписания = МестноеВремя(ДатаПодписания, ЧасовойПоясСеанса());
				КонецЕсли;
				Прервать;
			КонецЕсли;
		КонецЕсли;
		Символ = ЧтениеТекста.Прочитать(1);
	КонецЦикла;
	
	ЧтениеТекста.Закрыть();
	УдалитьФайлы(ИмяВременногоФайла);
	
	Возврат ДатаПодписания;
	
КонецФункции

// Устарела. Следует использовать процедуру УдалитьПодпись.
Процедура УдалитьПодписи(ОбъектСсылка, ТаблицаВыделенныеСтроки, РеквизитПодписанИзменен,
		КоличествоПодписей, УникальныйИдентификатор = Неопределено) Экспорт
	
	РеквизитПодписанИзменен = Ложь;
	
	// Сортировка по убыванию номера строки - вначале будут последние строки.
	ТаблицаВыделенныеСтроки.Сортировать("НомерСтроки Убыв");
	
	ПодписанныйОбъект = ОбъектСсылка.ПолучитьОбъект();
	ЗаблокироватьДанныеДляРедактирования(ОбъектСсылка, , УникальныйИдентификатор);
	
	Для Каждого ДанныеПодписи Из ТаблицаВыделенныеСтроки Цикл
		УдалитьПодпись2(ПодписанныйОбъект, ДанныеПодписи);
	КонецЦикла;
	
	КоличествоПодписей = ПодписанныйОбъект.ЭлектронныеПодписи.Количество();
	ПодписанныйОбъект.ПодписанЭП = (КоличествоПодписей <> 0);
	РеквизитПодписанИзменен = НЕ ПодписанныйОбъект.ПодписанЭП;
	
	// Чтобы прошла запись ранее подписанного объекта.
	ПодписанныйОбъект.ДополнительныеСвойства.Вставить("ЗаписьПодписанногоОбъекта", Истина);
	УстановитьПривилегированныйРежим(Истина);
	ПодписанныйОбъект.Записать();
	РазблокироватьДанныеДляРедактирования(ОбъектСсылка, УникальныйИдентификатор);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Возвращает общие настройки всех пользователей для работы с электронной подписью.
//
// Возвращаемое значение: 
//   Структура - Общие настройки подсистемы для работы с электронной подписью.
//     * ИспользоватьЭлектронныеПодписи       - Булево - если Истина, то электронный подписи используются.
//     * ИспользоватьШифрование               - Булево - если Истина, то шифрование используются.
//     * ПроверятьЭлектронныеПодписиНаСервере - Булево - если Истина, то электронные подписи и
//                                                       сертификаты проверяются на сервере.
//     * СоздаватьЭлектронныеПодписиНаСервере - Булево - если Истина, то электронные подписи создаются
//                                                       сначала на сервере, а в случае неудачи на клиенте.
//
// См. также:
//   ЭлектроннаяПодписьКлиентСервер.ОбщиеНастройки() - единая точка входа.
//   ОбщаяФорма.НастройкиЭлектроннойПодписиИШифрования - место определения данных параметров и
//   их текстовые описания.
//
Функция ОбщиеНастройки() Экспорт
	
	Возврат ЭлектроннаяПодписьСлужебныйПовтИсп.ОбщиеНастройки();
	
КонецФункции

// Возвращает настройки текущего пользователя для работы с электронной подписью.
//
// Возвращаемое значение:
//   Структура - Персональные настройки для работы с электронной подписью.
//       * ДействияПриСохраненииСЭП - Строка - Что делать при сохранении файлов с электронной подписью:
//           ** "Спрашивать" - Показывать диалог выбора подписей для сохранения.
//           ** "СохранятьВсеПодписи" - Всегда все подписи.
//       * ПутиКПрограммамЭлектроннойПодписиИШифрования - Соответствие - где:
//           ** Ключ     - СправочникСсылка.ПрограммыЭлектроннойПодписиИШифрования - программа.
//           ** Значение - Строка - путь к программе на компьютере пользователя.
//       * РасширениеДляФайловПодписи - Строка - Расширение для файлов ЭП.
//       * РасширениеДляЗашифрованныхФайлов - Строка - Расширение для зашифрованных файлов.
//
// См. также:
//   ЭлектроннаяПодписьКлиентСервер.ПерсональныеНастройки() - программный интерфейс для получения.
//   ОбщаяФорма.ПерсональныеНастройкиЭП - место ввода данных параметров и их пользовательские представления.
//
Функция ПерсональныеНастройки() Экспорт
	
	ПерсональныеНастройки = Новый Структура;
	// Начальные значения.
	ПерсональныеНастройки.Вставить("ДействияПриСохраненииСЭП", "Спрашивать");
	ПерсональныеНастройки.Вставить("ПутиКПрограммамЭлектроннойПодписиИШифрования", Новый Соответствие);
	ПерсональныеНастройки.Вставить("РасширениеДляФайловПодписи", "p7s");
	ПерсональныеНастройки.Вставить("РасширениеДляЗашифрованныхФайлов", "p7m");
	
	КлючПодсистемы = ЭлектроннаяПодписьСлужебный.КлючХраненияНастроек();
	
	Для Каждого КлючИЗначение Из ПерсональныеНастройки Цикл
		СохраненноеЗначение = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(КлючПодсистемы,
			КлючИЗначение.Ключ);
		
		Если ЗначениеЗаполнено(СохраненноеЗначение)
		   И ТипЗнч(КлючИЗначение.Значение) = ТипЗнч(СохраненноеЗначение) Тогда
			
			ПерсональныеНастройки.Вставить(КлючИЗначение.Ключ, СохраненноеЗначение);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ПерсональныеНастройки;
	
КонецФункции

// Извлекает сертификаты из данных подписи.
//
// Параметры:
//   Подпись - ДвоичныеДанные - Файл подписи.
//
// Возвращаемое значение:
//   Неопределено - Если при разборе возникла ошибка.
//   Структура - Данные подписи.
//       * Отпечаток                 - Строка.
//       * КомуВыданСертификат       - Строка.
//       * ДвоичныеДанныеСертификата - ДвоичныеДанные.
//       * Подпись                   - ХранилищеЗначения.
//       * Сертификат                - ХранилищеЗначения.
//
Функция ПрочитатьДанныеПодписи(Подпись) Экспорт
	
	Результат = Неопределено;
	
	МенеджерКриптографии = МенеджерКриптографии("ПолучениеСертификатов");
	Если МенеджерКриптографии = Неопределено Тогда
		Возврат Результат;
	КонецЕсли;
	
	Попытка
		Сертификаты = МенеджерКриптографии.ПолучитьСертификатыИзПодписи(Подпись);
	Исключение
		Возврат Результат;
	КонецПопытки;
	
	Если Сертификаты.Количество() > 0 Тогда
		Сертификат = Сертификаты[0];
		
		Результат = Новый Структура;
		Результат.Вставить("Отпечаток", Base64Строка(Сертификат.Отпечаток));
		Результат.Вставить("КомуВыданСертификат", ЭлектроннаяПодписьКлиентСервер.ПредставлениеСубъекта(Сертификат));
		Результат.Вставить("ДвоичныеДанныеСертификата", Сертификат.Выгрузить());
		Результат.Вставить("Подпись", Новый ХранилищеЗначения(Подпись));
		Результат.Вставить("Сертификат", Новый ХранилищеЗначения(Сертификат.Выгрузить()));
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

// Для процедуры ДобавитьПодпись.
Процедура ДобавитьСтрокуПодписи(ОбъектДанных, СвойстваПодписи)
	
	НоваяЗапись = ОбъектДанных.ЭлектронныеПодписи.Добавить();
	ЗаполнитьЗначенияСвойств(НоваяЗапись, СвойстваПодписи,, "Подпись, Сертификат");
	
	НоваяЗапись.Подпись    = Новый ХранилищеЗначения(СвойстваПодписи.Подпись);
	НоваяЗапись.Сертификат = Новый ХранилищеЗначения(СвойстваПодписи.Сертификат);
	
	Если Не ЗначениеЗаполнено(НоваяЗапись.УстановившийПодпись) Тогда
	 	НоваяЗапись.УстановившийПодпись = Пользователи.АвторизованныйПользователь();
	КонецЕсли;
	
	ДатаПодписи = ДатаПодписания(СвойстваПодписи.Подпись);
	
	Если ДатаПодписи <> Неопределено Тогда
		НоваяЗапись.ДатаПодписи = ДатаПодписи;
	
	ИначеЕсли Не ЗначениеЗаполнено(НоваяЗапись.ДатаПодписи) Тогда
		НоваяЗапись.ДатаПодписи = ТекущаяДатаСеанса();
	КонецЕсли;
	
КонецПроцедуры

// Для процедуры УдалитьПодпись.
Процедура УдалитьСтрокуПодписи(ПодписанныйОбъект, ИндексСтроки)
	
	Если ПодписанныйОбъект.ЭлектронныеПодписи.Количество() < ИндексСтроки + 1 Тогда
		ВызватьИсключение НСтр("ru = 'Строка с подписью не найдена.'");
	КонецЕсли;
	
	СтрокаТабличнойЧасти = ПодписанныйОбъект.ЭлектронныеПодписи.Получить(ИндексСтроки);
		
	Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда 
		Если СтрокаТабличнойЧасти.УстановившийПодпись <> Пользователи.ТекущийПользователь() Тогда
			ВызватьИсключение НСтр("ru = 'Недостаточно прав на удаление подписи.'");
		КонецЕсли;
	КонецЕсли;
	
	ПодписанныйОбъект.ЭлектронныеПодписи.Удалить(СтрокаТабличнойЧасти);
	
КонецПроцедуры

// Для устаревшей процедуры УдалитьПодписи.
Процедура УдалитьПодпись2(ПодписанныйОбъект, ДанныеПодписи)
	
	НомерСтроки = ДанныеПодписи.НомерСтроки;
	
	СтрокаТабличнойЧасти = ПодписанныйОбъект.ЭлектронныеПодписи.Найти(НомерСтроки, "НомерСтроки");
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		
		Если НЕ Пользователи.ЭтоПолноправныйПользователь() Тогда 
			Если СтрокаТабличнойЧасти.УстановившийПодпись <> Пользователи.ТекущийПользователь() Тогда
				ВызватьИсключение НСтр("ru = 'Недостаточно прав на удаление подписи.'");
			КонецЕсли;
		КонецЕсли;
		
		ПодписанныйОбъект.ЭлектронныеПодписи.Удалить(СтрокаТабличнойЧасти);
	Иначе	
		ВызватьИсключение НСтр("ru = 'Строка с подписью не найдена.'");
	КонецЕсли;
		
КонецПроцедуры

#КонецОбласти
