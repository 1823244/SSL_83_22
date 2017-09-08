﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ОткрытиеИзСписка") Тогда
		// Открытие по навигационной ссылке.
		Если РаботаСБанками.КлассификаторАктуален() Тогда
			ОповеститьКлассификаторАктуален = Истина;
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		АвтоматическоеСохранениеДанныхВНастройках = АвтоматическоеСохранениеДанныхФормыВНастройках.НеИспользовать;
		Элементы.ВариантЗагрузки.Доступность = Ложь;
		Элементы.ПутьКДискуИТС.Доступность = Ложь;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЗагрузкаССайтаРБК;
	Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
	КонецЕсли;
	
	ВыполнитьПроверкуПравДоступа("Изменение", Метаданные.Справочники.КлассификаторБанковРФ);
	ВариантЗагрузки = "РБК";
	
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ОповеститьКлассификаторАктуален Тогда
		РаботаСБанкамиКлиент.ОповеститьКлассификаторАктуален();
		Отказ = Истина;
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВариантЗагрузкиПриИзменении(Элемент)
	УстановитьИзмененияВИнтерфейсе();
КонецПроцедуры

&НаКлиенте
Процедура ПутьКДискуИТСНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОчиститьСообщения();
	
	ДиалогВыбораКаталога = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогВыбораКаталога.Заголовок = НСтр("ru = 'Укажите путь к диску ИТС'");
	ДиалогВыбораКаталога.Каталог   = ПутьКДискуИТС;
	
	Если НЕ ДиалогВыбораКаталога.Выбрать() Тогда
		Возврат;
	КонецЕсли;
	
	ПутьКДискуИТС = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ДиалогВыбораКаталога.Каталог);
	
	ФайлДанных = Новый Файл(ПутьКДискуИТС + "Database\Garant\MorphDB\Morph.dlc");
	Если НЕ ФайлДанных.Существует() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru ='В указанном каталоге не обнаружены данные классификатора. Необходимо указать путь к диску 1С:ИТС, на котором содержится база ""Гарант. Налоги, бухучет, предпринимательство.""'"),
			,
			"ПутьКДискуИТС");
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		Закрыть();
	Иначе
		ОчиститьСообщения();
		
		Если ВариантЗагрузки = "ИТС" И НЕ ЗначениеЗаполнено(ПутьКДискуИТС) И ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
			// Под Linux - перебор букв дисков невозможен.
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'При работе в ОС Linux необходимо явно указать путь к диску'"),
				,
				"ПутьКДискуИТС");
			Возврат;
		КонецЕсли;
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыполняетсяЗагрузка;
		УстановитьИзмененияВИнтерфейсе();
		ПодключитьОбработчикОжидания("ЗагрузитьКлассификатор", 0.1, Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)
	ТекущаяСтраница = Элементы.СтраницыФормы.ТекущаяСтраница;
	
	Если ТекущаяСтраница = Элементы.СтраницаРезультат Тогда
		#Если ВебКлиент Тогда
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЗагрузкаССайтаРБК;
		#Иначе
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника;
		#КонецЕсли
	КонецЕсли;
	
	УстановитьИзмененияВИнтерфейсе();

КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		ЗавершитьФоновоеЗадание(ИдентификаторЗадания);
	КонецЕсли;
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Клиент

&НаКлиенте
Процедура ЗагрузитьКлассификатор()
	// Загружает классификатор банков с диска ИТС или с сайта РБК.
	
	ПараметрыЗагрузкиКлассификатора = Новый Соответствие;
	// (Число) Количество новых записей классификатора:
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", 0);
	// (Число) Количество обновленных записей классификатора:
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", 0);
	// (Строка) Тест сообщения о результатах загрузки:
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", "");
	// (Булево) Флаг успешного завершения загрузки данных классификатора:
	ПараметрыЗагрузкиКлассификатора.Вставить("ЗагрузкаВыполнена", Ложь);
	
	Если ВариантЗагрузки = "ИТС" Тогда
		ПолучитьДанныеБИКРФДискИТС(ПараметрыЗагрузкиКлассификатора);
		АдресХранилища = ПоместитьВоВременноеХранилище(Неопределено, УникальныйИдентификатор);
		ПоместитьВоВременноеХранилище(ПараметрыЗагрузкиКлассификатора, АдресХранилища);
		Результат = Новый Структура("ЗаданиеВыполнено, АдресХранилища", Истина, АдресХранилища);
	ИначеЕсли ВариантЗагрузки = "РБК" Тогда
		Результат = ПолучитьДанныеРБКНаСервере(ПараметрыЗагрузкиКлассификатора);
	КонецЕсли;
	
	АдресХранилища = Результат.АдресХранилища;
	Если НЕ Результат.ЗаданиеВыполнено Тогда
		ИдентификаторЗадания = Результат.ИдентификаторЗадания;
		
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
	Иначе
		ЗагрузитьРезультат();
	КонецЕсли;
 КонецПроцедуры 

&НаКлиенте
Процедура ЗагрузитьРезультат()
	// Отображает результат попытки загрузки классификатора банков РФ в журнале регистрации
	// и в форме загрузки.
	
	Если ВариантЗагрузки = "ИТС" Тогда
		Источник = НСтр("ru ='Диск ИТС'");
	Иначе
		Источник = НСтр("ru ='Сайт РБК'");
	КонецЕсли;
	
	ПараметрыЗагрузкиКлассификатора = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	ИмяСобытия = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru ='Загрузка классификатора банков. %1.'"), Источник);
	
	Если ПараметрыЗагрузкиКлассификатора["ЗагрузкаВыполнена"] Тогда
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия,, 
			ПараметрыЗагрузкиКлассификатора["ТекстСообщения"],, Истина);
		РаботаСБанкамиКлиент.ОповеститьКлассификаторУспешноОбновлен();
	Иначе
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(ИмяСобытия, 
			"Ошибка", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"],, Истина);
	КонецЕсли;
	Элементы.ПоясняющийТекст.Заголовок = ПараметрыЗагрузкиКлассификатора["ТекстСообщения"];
	
	Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
	УстановитьИзмененияВИнтерфейсе();
	
	Если (ПараметрыЗагрузкиКлассификатора["Обновлено"] > 0) Или (ПараметрыЗагрузкиКлассификатора["Загружено"] > 0) Тогда
		ОповеститьОбИзменении(Тип("СправочникСсылка.КлассификаторБанковРФ"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()
	ЗаданиеВыполнено = Неопределено;
	Попытка
		ЗаданиеВыполнено = ЗаданиеВыполнено(ИдентификаторЗадания);
	Исключение
		ЖурналРегистрацииКлиент.ДобавитьСообщениеДляЖурналаРегистрации(НСтр("ru = 'Загрузка классификатора банков'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка()),
			"Ошибка", ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()), , Истина);
			
		Элементы.ПоясняющийТекст.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Загрузка классификатора банков прервана по причине:
				|%1
				|Подробности см. в журнале регистрации.'"),
			КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
			
		Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаРезультат;
		УстановитьИзмененияВИнтерфейсе();
		Возврат;
	КонецПопытки;
		
	Если ЗаданиеВыполнено Тогда 
		ЗагрузитьРезультат();
	Иначе
		ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания(
			"Подключаемый_ПроверитьВыполнениеЗадания", 
			ПараметрыОбработчикаОжидания.ТекущийИнтервал, 
			Истина);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеБИКРФДискИТС(ПараметрыЗагрузкиКлассификатора) 
	// Получает, сортирует, записывает данные классификатора БИК РФ с диска ИТС.
	
	ПараметрыЗагрузкиФайловИТС = Новый Соответствие;
	// (Строка) Путь к диску ИТС:
	ПараметрыЗагрузкиФайловИТС.Вставить("ПутьКДискуИТС", "");
	// (Строка) Адрес во временном хранилище, по которому размещен файл данных классификатора:
	ПараметрыЗагрузкиФайловИТС.Вставить("ДанныеИТСАдресДвоичныхДанных", "");
	// (Строка) Адрес во временном хранилище, по которому размещен файл обработки подготовки данных:
	ПараметрыЗагрузкиФайловИТС.Вставить("ПодготовкаИТСАдресДвоичныхДанных", "");
	// (Строка) Текст ошибки:
	ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", ПараметрыЗагрузкиКлассификатора["ТекстСообщения"]);
	// Другие параметры - см. описание переменной ПараметрыЗагрузкиФайловРБК в ЗагрузитьКлассификатор():
	ПараметрыЗагрузкиФайловИТС.Вставить("Загружено", ПараметрыЗагрузкиКлассификатора["Загружено"]);
	ПараметрыЗагрузкиФайловИТС.Вставить("Обновлено", ПараметрыЗагрузкиКлассификатора["Обновлено"]);
	
	ПолучитьДанныеБИКДискИТС(ПараметрыЗагрузкиФайловИТС);
	
	Если Не ПустаяСтрока(ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]);
		Возврат;
	КонецЕсли;
	
	ПолучитьСортировщикДискИТС(ПараметрыЗагрузкиФайловИТС);
	
	Если Не ПустаяСтрока(ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]) Тогда
		ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]);
		Возврат;
	КонецЕсли;
	
	ЗагрузитьДанныеДискИТСНаСервере(ПараметрыЗагрузкиФайловИТС);
	
	ПараметрыЗагрузкиКлассификатора.Вставить("Загружено", ПараметрыЗагрузкиФайловИТС["Загружено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("Обновлено", ПараметрыЗагрузкиФайловИТС["Обновлено"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("ТекстСообщения", ПараметрыЗагрузкиФайловИТС["ТекстСообщения"]);
	ПараметрыЗагрузкиКлассификатора.Вставить("ЗагрузкаВыполнена", Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьДанныеБИКДискИТС(ПараметрыЗагрузкиФайловИТС)
	// Получает данные классификатора БИК РФ с диска ИТС.
	// 
// Параметры:
	//   ПараметрыЗагрузкиФайловИТС - см. описание одноименной переменной в ПолучитьДанныеБИКРФДискИТС().
	
	ФайлДанных = Неопределено;
	ФайлНайден = Ложь;
	
	Результат = Новый Структура;
	Если ЗначениеЗаполнено(ПутьКДискуИТС) Тогда
		// Путь к диску указан явно.
		ПутьКДискуИТС = ОбщегоНазначенияКлиентСервер.ДобавитьКонечныйРазделительПути(ПутьКДискуИТС);
		ФайлДанных = Новый Файл(ПутьКДискуИТС + "Database\Garant\MorphDB\Morph.dlc");
		Если ФайлДанных.Существует() Тогда
			ПараметрыЗагрузкиФайловИТС.Вставить("ПутьКДискуИТС", ПутьКДискуИТС);
			ФайлНайден = Истина;
		Иначе
			ДанныеИТС = "";
		КонецЕсли;
	Иначе
		// Под Linux - проверка расположена ранее в Далее().
		// Под Windows - перебор букв дисков с D по Z.
		Для Индекс = 68 По 90 Цикл
			НайденныйПутьКДискуИТС = Символ(Индекс) + ":\";
			ФайлДанных = Новый Файл(НайденныйПутьКДискуИТС + "Database\Garant\MorphDB\Morph.dlc");
			Если ФайлДанных.Существует() Тогда
				ПараметрыЗагрузкиФайловИТС.Вставить("ПутьКДискуИТС", НайденныйПутьКДискуИТС);
				ФайлНайден = Истина;
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Если ФайлНайден Тогда
		ДанныеИТСАдресДвоичныхДанных = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ФайлДанных.ПолноеИмя));
		ПараметрыЗагрузкиФайловИТС.Вставить("ДанныеИТСАдресДвоичныхДанных", ДанныеИТСАдресДвоичныхДанных);
		ФайлДанных = Неопределено;
	Иначе
		ТекстСообщения = НСтр("ru ='На диске 1С:ИТС не обнаружены данные классификатора БИК РФ. 
		|Для установки требуется диск 1С:ИТС, на котором содержится база ""Гарант. Налоги, бухучет, предпринимательство.""'");
		ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", ТекстСообщения);
	КонецЕсли;
	
	ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", ТекстСообщения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьСортировщикДискИТС(ПараметрыЗагрузкиФайловИТС)
	// Получает обработку сортировки классификатора БИК РФ с диска ИТС.
	// 
// Параметры:
	//   ПараметрыЗагрузкиФайловИТС - см. описание одноименной переменной в ПолучитьДанныеБИКРФДискИТС().
	
	ФайлОбработки = Новый Файл(ПараметрыЗагрузкиФайловИТС["ПутьКДискуИТС"] + "1CITS\EXE\EXTDB\BIKr5v82_MA.epf");
	
	Если ФайлОбработки.Существует() Тогда
		АдресДвоичныхДанных = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ФайлОбработки.ПолноеИмя));
		ПараметрыЗагрузкиФайловИТС.Вставить("ПодготовкаИТСАдресДвоичныхДанных", АдресДвоичныхДанных);
	Иначе
		ПараметрыЗагрузкиФайловИТС.Вставить("ТекстСообщения", НСтр("ru ='На диске ИТС не обнаружен файл обработки подготовки данных классификатора БИК РФ.'"));
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вызов сервера

&НаСервереБезКонтекста
Функция ЗаданиеВыполнено(ИдентификаторЗадания)
	Возврат ДлительныеОперации.ЗаданиеВыполнено(ИдентификаторЗадания);
КонецФункции

&НаСервере
Процедура УстановитьИзмененияВИнтерфейсе()
	// В зависимости от текущей страницы устанавливает доступность тех или иных полей для пользователя.
	
	Элементы.ПутьКДискуИТС.Доступность = (ВариантЗагрузки = "ИТС");
	
	Если Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.СтраницаВыборИсточника
		Или Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ЗагрузкаССайтаРБК Тогда
		Элементы.ФормаКнопкаНазад.Видимость  = Ложь;
		Элементы.ФормаКнопкаДалее.Заголовок = НСтр("ru ='Загрузить'");
		Элементы.ФормаКнопкаОтмена.Доступность = Истина;
		Элементы.ФормаКнопкаДалее.Доступность  = Истина;
	ИначеЕсли Элементы.СтраницыФормы.ТекущаяСтраница = Элементы.ВыполняетсяЗагрузка Тогда
		Элементы.ФормаКнопкаНазад.Видимость = Ложь;
		Элементы.ФормаКнопкаДалее.Доступность  = Ложь;
		Элементы.ФормаКнопкаОтмена.Доступность = Истина;
	Иначе
		Элементы.ФормаКнопкаНазад.Видимость = Истина;
		Элементы.ФормаКнопкаДалее.Заголовок = НСтр("ru ='Закрыть'");
		Элементы.ФормаКнопкаОтмена.Доступность = Ложь;
		Элементы.ФормаКнопкаДалее.Доступность  = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗавершитьФоновоеЗадание(ИдентификаторЗадания)
	ФоновоеЗадание = ФоновыеЗадания.НайтиПоУникальномуИдентификатору(ИдентификаторЗадания);
	Если ФоновоеЗадание <> Неопределено Тогда
		ФоновоеЗадание.Отменить();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанныеДискИТСНаСервере(ПараметрыЗагрузкиФайловИТС)
	// Загружает в классификатор банков данные с диска ИТС.
	// 
// Параметры:
	//   ПараметрыЗагрузкиФайловИТС - см. описание переменной ПараметрыЗагрузкиКлассификатора в
	//                                ПолучитьДанныеБИКРФДискИТС().
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ВызватьИсключение ТекстЗагрузкаЗапрещена();
	КонецЕсли;
	
	РаботаСБанками.ЗагрузитьДанныеДискИТС(ПараметрыЗагрузкиФайловИТС);
	
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеРБКНаСервере(ПараметрыЗагрузкиФайловРБК)
	// Загружает в классификатор банков данные с диска ИТС.
	//
// Параметры:
	//   ПараметрыЗагрузкиФайловРБК - см. описание одноименной переменной в ЗагрузитьКлассификатор().
	
	Если ОбщегоНазначенияПовтИсп.РазделениеВключено() Тогда
		ВызватьИсключение ТекстЗагрузкаЗапрещена();
	КонецЕсли;
	
	НаименованиеЗадания = НСтр("ru = 'Загрузка классификатора банков РФ'");
	
	Результат = ДлительныеОперации.ЗапуститьВыполнениеВФоне(
		УникальныйИдентификатор,
		"РаботаСБанками.ПолучитьДанныеРБК", 
		ПараметрыЗагрузкиФайловРБК, 
		НаименованиеЗадания);
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Сервер

&НаСервере
Функция ТекстЗагрузкаЗапрещена()
	Возврат НСтр("ru = 'Загрузка классификатора банков в разделенном режиме запрещена.'");
КонецФункции

#КонецОбласти
