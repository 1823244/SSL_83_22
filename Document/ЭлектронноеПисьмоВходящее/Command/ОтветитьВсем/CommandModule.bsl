﻿
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Основание = Новый Структура("Основание,Команда", ПараметрКоманды, "ОтветитьВсем");
	ПараметрыОткрытия = Новый Структура("Основание", Основание);
	ОткрытьФорму("Документ.ЭлектронноеПисьмоИсходящее.Форма.ФормаДокумента", ПараметрыОткрытия);
	ПараметрыВыполненияКоманды.Источник.Закрыть();
	
КонецПроцедуры
