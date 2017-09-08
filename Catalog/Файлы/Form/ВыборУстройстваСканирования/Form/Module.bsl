﻿
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	КоличествоЭлементов = 0;
	Если РаботаСФайламиСлужебныйКлиент.ПроинициализироватьКомпоненту() Тогда
		МассивУстройств = РаботаСФайламиСлужебныйКлиент.ПолучитьУстройства();
		Для Каждого Строка Из МассивУстройств Цикл
			КоличествоЭлементов = КоличествоЭлементов + 1;
			Элементы.ИмяУстройства.СписокВыбора.Добавить(Строка);
		КонецЦикла;
	КонецЕсли;
	Если КоличествоЭлементов = 0 Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(, НСтр("ru = 'Не установлен сканер. Обратитесь к администратору программы.'"));
	Иначе
		Элементы.ИмяУстройства.РежимВыбораИзСписка = Истина;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьСканер(Команда)
	СистемнаяИнформация = Новый СистемнаяИнформация();
	ОбщегоНазначенияВызовСервера.ХранилищеОбщихНастроекСохранить(
		"НастройкиСканирования/ИмяУстройства",
		СистемнаяИнформация.ИдентификаторКлиента,
		ИмяУстройства);
	ОбновитьПовторноИспользуемыеЗначения();
	Закрыть(ИмяУстройства);
КонецПроцедуры

#КонецОбласти