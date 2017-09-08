﻿////////////////////////////////////////////////////////////////////////////////
// Серверные события формы отчета.
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// В данной процедуре следует описать дополнительные зависимости объектов метаданных
//   конфигурации, которые будут использоваться для связи настроек отчетов.
//
// Параметры:
//   СвязиОбъектовМетаданных - ТаблицаЗначений - Таблица связей.
//       * ПодчиненныйРеквизит - Строка - Имя реквизита подчиненного объекта метаданных.
//       * ПодчиненныйТип      - Тип    - Тип подчиненного объекта метаданных.
//       * ВедущийТип          - Тип    - Тип ведущего объекта метаданных.
//
Процедура ДополнитьСвязиОбъектовМетаданных(СвязиОбъектовМетаданных) Экспорт
	
	
	
КонецПроцедуры

// Вызывается в форме отчета перед выводом настройки.
//
// Параметры:
//   Форма - УправляемаяФорма, Неопределено - Форма отчета.
//   СвойстваНастройки - Структура - Описание настройки отчета, которая будет выведена в форме отчета.
//       * ОписаниеТипов - ОписаниеТипов -
//           Тип настройки.
//       * ЗначенияДляВыбора - СписокЗначений -
//           Объекты, которые будут предложены пользователю в списке выбора.
//           Дополняет список объектов, уже выбранных пользователем ранее.
//       * ЗапросЗначенийВыбора - Запрос -
//           Возвращает объекты, которыми необходимо дополнить ЗначенияДляВыбора.
//           Первой колонкой (с 0м индексом) должен выбираться объект,
//           который следует добавить в ЗначенияДляВыбора.Значение.
//           Для отключения автозаполнения
//           в свойство ЗапросЗначенийВыбора.Текст следует записать пустую строку.
//       * ОграничиватьВыборУказаннымиЗначениями - Булево -
//           Когда Истина, то выбор пользователя будет ограничен значениями,
//           указанными в ЗначенияДляВыбора (его конечным состоянием).
//
Процедура ПриОпределенииПараметровВыбора(Форма, СвойстваНастройки) Экспорт
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   Отказ - Передается из параметров обработчика "как есть".
//   СтандартнаяОбработка - Передается из параметров обработчика "как есть".
//
// См. также:
//   "УправляемаяФорма.ПриСозданииНаСервере" в синтакс-помощнике.
//
Процедура ПриСозданииНаСервере(Форма, Отказ, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры

// Вызывается в обработчике одноименного события формы отчета после выполнения кода формы.
//
// Параметры:
//   Форма - УправляемаяФорма - Форма отчета.
//   НовыеНастройкиКД - НастройкиКомпоновкиДанных - Настройки для загрузки в компоновщик настроек.
//
// См. также:
//   "Расширение управляемой формы для отчета.ПриЗагрузкеВариантаНаСервере" в синтакс-помощнике.
//
Процедура ПередЗагрузкойВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Устаревшие процедуры и функции.

// Устарела: следует использовать аналогичную процедуру в модуле объекта отчета.
Процедура ПриЗагрузкеВариантаНаСервере(Форма, НовыеНастройкиКД) Экспорт
	
КонецПроцедуры

// Устарела: следует использовать аналогичную процедуру в модуле объекта отчета.
Процедура ПриЗагрузкеПользовательскихНастроекНаСервере(Форма, НовыеПользовательскиеНастройкиКД) Экспорт
	
КонецПроцедуры

// Устарела: следует использовать аналогичную процедуру в модуле объекта отчета.
Процедура ПередЗаполнениемПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	
КонецПроцедуры

// Устарела: следует использовать аналогичную процедуру в модуле объекта отчета.
Процедура ПослеЗаполненияПанелиБыстрыхНастроек(Форма, ПараметрыЗаполнения) Экспорт
	
КонецПроцедуры

// Устарела: следует использовать аналогичную процедуру в модуле объекта отчета.
Процедура КонтекстныйВызовСервера(Форма, Ключ, Параметры, Результат) Экспорт
	
КонецПроцедуры

#КонецОбласти
