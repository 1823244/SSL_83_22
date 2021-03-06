﻿////////////////////////////////////////////////////////////////////////////////
//  Методы, позволяющие начать и закончить замер времени выполнения ключевой операции.
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Активизирует замер времени выполнения ключевой операции.
//
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции.
//  При вызове с сервера аргумент игнорируется.
//
// Возвращаемое значение:
//  Дата или число - время начала с точностью до миллисекунд или секунд в зависимости от версии платформы.
//
Функция НачатьЗамерВремени(КлючеваяОперация = Неопределено) Экспорт
	
	ВремяНачала = 0;
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ДатаНачала = ЗначениеТаймера(Ложь);
		ВремяНачала = ЗначениеТаймера();
		#Если Клиент Тогда
			Если Не ЗначениеЗаполнено(КлючеваяОперация) Тогда
				ВызватьИсключение НСтр("ru = 'Не указана ключевая операция.'");
			КонецЕсли;
			
			ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
			
			Если ПараметрыПриложения = Неопределено Тогда
				ПараметрыПриложения = Новый Соответствие;
			КонецЕсли;
			
			Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
				ТекущийПериодЗаписи = ОценкаПроизводительностиВызовСервераПолныеПрава.ПериодЗаписи();
				ДатаИВремяНаСервере = ОценкаПроизводительностиВызовСервераПолныеПрава.ДатаИВремяНаСервере();
				ДатаИВремяНаКлиенте = ТекущаяДата();
				
				ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
				ПараметрыПриложения[ИмяПараметра].Вставить("Замеры", Новый Соответствие);
				ПараметрыПриложения[ИмяПараметра].Вставить("ПериодЗаписи", ТекущийПериодЗаписи);
				ПараметрыПриложения[ИмяПараметра].Вставить("СмещениеДатыКлиента", ДатаИВремяНаСервере - ДатаИВремяНаКлиенте);
				
				ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", ТекущийПериодЗаписи, Истина);
			КонецЕсли;
			Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"]; 
			СмещениеДатыКлиента = ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];
			
			БуферКлючевойОперации = Замеры.Получить(КлючеваяОперация);
			Если БуферКлючевойОперации = Неопределено Тогда
				БуферКлючевойОперации = Новый Соответствие;
				Замеры.Вставить(КлючеваяОперация, БуферКлючевойОперации);
			КонецЕсли;
			
			ДатаНачала = ДатаНачала + СмещениеДатыКлиента;
			НачатыйЗамер = БуферКлючевойОперации.Получить(ДатаНачала);
			Если НачатыйЗамер = Неопределено Тогда
				БуферЗамера = Новый Соответствие;
				БуферЗамера.Вставить("ВремяНачала", ВремяНачала);
				БуферКлючевойОперации.Вставить(ДатаНачала, БуферЗамера);
			КонецЕсли;
			
			ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);
		#КонецЕсли
	КонецЕсли;

	Возврат ВремяНачала;
	
КонецФункции

// Процедура завершает замер времени на сервере и записывает результат на сервере.
// Параметры:
//  КлючеваяОперация - СправочникСсылка.КлючевыеОперации - ключевая операция
//						либо Строка - название ключевой операции.
//  ВремяНачала - Число или Дата.
Процедура ЗакончитьЗамерВремени(КлючеваяОперация, ВремяНачала) Экспорт
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ДатаОкончания = ЗначениеТаймера(Ложь);
		ВремяОкончания = ЗначениеТаймера();
		Если ТипЗнч(ВремяНачала) = Тип("Число") Тогда
			Длительность = (ВремяОкончания - ВремяНачала);
			ДатаНачала = ДатаОкончания - Длительность;
		Иначе
			Длительность = (ДатаОкончания - ВремяНачала);
			ДатаНачала = ВремяНачала;
		КонецЕсли;
		ОценкаПроизводительностиВызовСервераПолныеПрава.ЗафиксироватьДлительностьКлючевойОперации(
		КлючеваяОперация,
		Длительность,
		ДатаНачала,
		ДатаОкончания);
	КонецЕсли;	
КонецПроцедуры

// Функция вызывается при старте замера времени и его завершении.
// ТекущаяДата вместо ТекущаяДатаСеанса используется осмысленно.
// Но нужно помнить, что если время начала замера получено на клиенте, 
// то и время конца замера нужно вычислять на клиенте. Для сервера то же самое.
//
// Возвращаемое значение:
//  Дата - время начала замера.
Функция ЗначениеТаймера(ВысокаяТочность = Истина) Экспорт
	
	Перем ЗначениеТаймера;
	Если ВысокаяТочность Тогда
		
		ЗначениеТаймера = ТекущаяУниверсальнаяДатаВМиллисекундах() / 1000.0;
		Возврат ЗначениеТаймера;
		
	Иначе
		
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Возврат ТекущаяДатаСеанса();
#Иначе
		Возврат ТекущаяДата();
#КонецЕсли
		
	КонецЕсли;
	
КонецФункции

// Ключ параметра регламентного задания, соответствующий локальному каталогу экспорта.
Функция ЛокальныйКаталогЭкспортаКлючЗадания() Экспорт
	
	Возврат "ЛокальныйКаталогЭкспорта";
	
КонецФункции

// Ключ параметра регламентного задания, соответствующий ftp каталогу экспорта.
Функция FTPКаталогЭкспортаКлючЗадания() Экспорт
	
	Возврат "FTPКаталогЭкспорта";
	
КонецФункции

#Если Сервер Тогда
// Процедура записывает данные в журнал регистрации.
//
// Параметры:
//  ИмяСобытия - Строка
//  Уровень - УровеньЖурналаРегистрации
//  ТекстСообщения - Строка
//
Процедура ЗаписатьВЖурналРегистрации(ИмяСобытия, Уровень, ТекстСообщения) Экспорт
	
	ЗаписьЖурналаРегистрации(ИмяСобытия,
		Уровень,
		,
		НСтр("ru = 'Оценка производительности'"),
		ТекстСообщения);
	
КонецПроцедуры
#КонецЕсли

// Получает имя дополнительного свойства не проверять приоритеты при записи ключевой операции.
//
// Возвращаемое значение:
//  Строка - имя дополнительного свойства.
//
Функция НеПроверятьПриоритет() Экспорт
	
	Возврат "НеПроверятьПриоритет";
	
КонецФункции

#КонецОбласти
