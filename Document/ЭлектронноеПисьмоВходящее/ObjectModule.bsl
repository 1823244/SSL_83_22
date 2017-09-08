﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Взаимодействия.ПриЗаписиДокумента(ЭтотОбъект);
	УправлениеЭлектроннойПочтой.УстановитьПометкуУдаленияУВложенийПисьма(Ссылка, ПометкаУдаления);
	Взаимодействия.ОтработатьПризнакИзмененияПометкиУдаленияПриЗаписиПисьма(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПередУдалением(Отказ)
	
	УправлениеЭлектроннойПочтой.УдалитьВложенияУПисьма(Ссылка);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ДополнительныеСвойства.Вставить("ПометкаУдаления",
		ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка,"ПометкаУдаления"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

 

#КонецОбласти

#КонецЕсли