﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Возвращает список реквизитов, которые не нужно редактировать
// с помощью обработки группового изменения объектов.
//
Функция РеквизитыНеРедактируемыеВГрупповойОбработке() Экспорт
	
	НеРедактируемыеРеквизиты = Новый Массив;
	НеРедактируемыеРеквизиты.Добавить("КомуВыдан");
	НеРедактируемыеРеквизиты.Добавить("Фирма");
	НеРедактируемыеРеквизиты.Добавить("Фамилия");
	НеРедактируемыеРеквизиты.Добавить("Имя");
	НеРедактируемыеРеквизиты.Добавить("Отчество");
	НеРедактируемыеРеквизиты.Добавить("Должность");
	НеРедактируемыеРеквизиты.Добавить("КемВыдан");
	НеРедактируемыеРеквизиты.Добавить("ДействителенДо");
	НеРедактируемыеРеквизиты.Добавить("Подписание");
	НеРедактируемыеРеквизиты.Добавить("Шифрование");
	НеРедактируемыеРеквизиты.Добавить("Отпечаток");
	НеРедактируемыеРеквизиты.Добавить("ДанныеСертификата");
	НеРедактируемыеРеквизиты.Добавить("Программа");
	НеРедактируемыеРеквизиты.Добавить("Отозван");
	НеРедактируемыеРеквизиты.Добавить("УсиленнаяЗащитаЗакрытогоКлюча");
	НеРедактируемыеРеквизиты.Добавить("Организация");
	НеРедактируемыеРеквизиты.Добавить("Пользователь");
	НеРедактируемыеРеквизиты.Добавить("Добавил");
	НеРедактируемыеРеквизиты.Добавить("СостояниеЗаявления");
	НеРедактируемыеРеквизиты.Добавить("СодержаниеЗаявления");
	
	Возврат НеРедактируемыеРеквизиты;
	
КонецФункции

#КонецОбласти

#КонецЕсли

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияФормы(ВидФормы, Параметры, ВыбраннаяФорма, ДополнительнаяИнформация, СтандартнаяОбработка)
	
	Если ВидФормы = "ФормаСписка" Тогда
		СтандартнаяОбработка = Ложь;
		Параметры.Вставить("ПоказатьСтраницуСертификаты");
		ВыбраннаяФорма = Метаданные.ОбщиеФормы.НастройкиЭлектроннойПодписиИШифрования;
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПолученияДанныхВыбора(ДанныеВыбора, Параметры, СтандартнаяОбработка)
	
	Параметры.Отбор.Вставить("ПометкаУдаления", Ложь);
	
КонецПроцедуры

#КонецОбласти
