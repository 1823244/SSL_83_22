﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Дополнительные отчеты и обработки".
// 
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Имена видов объектов.

// Печатная форма.
Функция ВидОбработкиПечатнаяФорма() Экспорт
	
	Возврат "ПечатнаяФорма"; // не локализуется
	
КонецФункции

// Заполнение объекта.
Функция ВидОбработкиЗаполнениеОбъекта() Экспорт
	
	Возврат "ЗаполнениеОбъекта"; // не локализуется
	
КонецФункции

// Создание связанных объектов.
Функция ВидОбработкиСозданиеСвязанныхОбъектов() Экспорт
	
	Возврат "СозданиеСвязанныхОбъектов"; // не локализуется
	
КонецФункции

// Назначаемый отчет.
Функция ВидОбработкиОтчет() Экспорт
	
	Возврат "Отчет"; // не локализуется
	
КонецФункции

// Дополнительная обработка.
Функция ВидОбработкиДополнительнаяОбработка() Экспорт
	
	Возврат "ДополнительнаяОбработка"; // не локализуется
	
КонецФункции

// Дополнительный отчет.
Функция ВидОбработкиДополнительныйОтчет() Экспорт
	
	Возврат "ДополнительныйОтчет"; // не локализуется
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Имена типов команд.

// Вызов клиентского метода.
Функция ТипКомандыВызовКлиентскогоМетода() Экспорт
	
	Возврат "ВызовКлиентскогоМетода"; // не локализуется
	
КонецФункции

// Вызов серверного метода.
Функция ТипКомандыВызовСерверногоМетода() Экспорт
	
	Возврат "ВызовСерверногоМетода"; // не локализуется
	
КонецФункции

// Открытие формы.
Функция ТипКомандыОткрытиеФормы() Экспорт
	
	Возврат "ОткрытиеФормы"; // не локализуется
	
КонецФункции

// Заполнение формы.
Функция ТипКомандыЗаполнениеФормы() Экспорт
	
	Возврат "ЗаполнениеФормы"; // не локализуется
	
КонецФункции

// Сценарий в безопасном режиме.
Функция ТипКомандыСценарийВБезопасномРежиме() Экспорт
	
	Возврат "СценарийВБезопасномРежиме"; // не локализуется
	
КонецФункции

// Загрузка данных из файла.
Функция ТипКомандыЗагрузкаДанныхИзФайла() Экспорт
	
	Возврат "ЗагрузкаДанныхИзФайла"; // не локализуется
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Имена типов форм. Используются при настройке назначаемых объектов.

// Идентификатор формы списка.
Функция ТипФормыСписка() Экспорт
	
	Возврат "ФормаСписка"; // не локализуется
	
КонецФункции

// Идентификатор формы объекта.
Функция ТипФормыОбъекта() Экспорт
	
	Возврат "ФормаОбъекта"; // не локализуется
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Другие процедуры и функции.

// Фильтр для диалогов выбора или сохранения дополнительных отчетов и обработок.
Функция ФильтрДиалоговВыбораИСохранения() Экспорт
	
	Фильтр = НСтр("ru = 'Внешние отчеты и обработки (*.%1, *.%2)|*.%1;*.%2|Внешние отчеты (*.%1)|*.%1|Внешние обработки (*.%2)|*.%2'");
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(Фильтр, "erf", "epf");
	Возврат Фильтр;
	
КонецФункции

// Идентификатор, который используется для рабочего стола.
Функция ИдентификаторРабочегоСтола() Экспорт
	
	Возврат "РабочийСтол"; // не локализуется
	
КонецФункции

// Наименование подсистемы.
Функция НаименованиеПодсистемы(КодЯзыка) Экспорт
	
	Возврат НСтр("ru = 'Дополнительные отчеты и обработки'", ?(КодЯзыка = Неопределено, ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(), КодЯзыка));
	
КонецФункции

#КонецОбласти
