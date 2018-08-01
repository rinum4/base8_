﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Пользователи".
//
////////////////////////////////////////////////////////////////////////////////

#Область СлужебныйПрограммныйИнтерфейс

// Открывает форму, в которой пользователь может сменить пароль.
Процедура ОткрытьФормуСменыПароля(Пользователь = Неопределено, ОбработкаПродолжения = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВернутьПарольБезУстановки", Ложь);
	ПараметрыФормы.Вставить("СтарыйПароль", Неопределено);
	Если ДополнительныеПараметры <> Неопределено Тогда
		ЗаполнитьЗначенияСвойств(ПараметрыФормы, ДополнительныеПараметры);
	КонецЕсли;
	ПараметрыФормы.Вставить("Пользователь", Пользователь);
	
	ОткрытьФорму("ОбщаяФорма.СменаПароля", ПараметрыФормы,,,,, ОбработкаПродолжения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Для работы интерфейса ролей в управляемой форме.

// Только для внутреннего использования.
//
Процедура РазвернутьПодсистемыРолей(Форма, Безусловно = Истина) Экспорт
	
	Элементы = Форма.Элементы;
	
	Если НЕ Безусловно
	   И НЕ Элементы.РолиПоказатьТолькоВыбранныеРоли.Пометка Тогда
		
		Возврат;
	КонецЕсли;
	
	// Развернуть все.
	Для каждого Строка Из Форма.Роли.ПолучитьЭлементы() Цикл
		Элементы.Роли.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

// Только для внутреннего использования.
//
Функция ВыбратьНазначение(ДанныеФормы, Заголовок, ВыбиратьПользователей = Истина, ЭтоОтбор = Ложь, ОписаниеОповещения = Неопределено) Экспорт
	
	ДополнительныеПараметры = Новый Структура;
	ДополнительныеПараметры.Вставить("ДанныеФормы", ДанныеФормы);
	ДополнительныеПараметры.Вставить("ЭтоОтбор", ЭтоОтбор);
	ДополнительныеПараметры.Вставить("ОписаниеОповещения", ОписаниеОповещения);
	
	ОписаниеОповещенияОЗакрытии = Новый ОписаниеОповещения("ПослеВыбораНазначения", ЭтотОбъект, ДополнительныеПараметры);
	
	Назначение = ?(ЭтоОтбор, ДанныеФормы.ВидПользователей, ДанныеФормы.Объект.Назначение);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Заголовок", Заголовок);
	ПараметрыФормы.Вставить("Назначение", Назначение);
	ПараметрыФормы.Вставить("ВыбиратьПользователей", ВыбиратьПользователей);
	ПараметрыФормы.Вставить("ЭтоОтбор", ЭтоОтбор);
	ОткрытьФорму("ОбщаяФорма.ВыборТиповПользователей", ПараметрыФормы,,,,, ОписаниеОповещенияОЗакрытии);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Обработчики условных вызовов из других подсистем.

// Вызывается перед интерактивным началом работы пользователя с областью данных.
// Соответствует событию ПередНачаломРаботыСистемы модулей приложения.
//
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске(); 
	
	Если ПараметрыКлиента.Свойство("ОшибкаНедостаточноПравДляВходаВПрограмму") Тогда
		Параметры.ПолученныеПараметрыКлиента.Вставить("ОшибкаНедостаточноПравДляВходаВПрограмму");
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограмму",
			ЭтотОбъект,
			ПараметрыКлиента.ОшибкаНедостаточноПравДляВходаВПрограмму);
	КонецЕсли;
	
КонецПроцедуры

// Выполняется при интерактивном начале работы пользователя с областью данных или в локальном режиме.
// Вызывается после завершения действий ПриНачалеРаботыСистемы.
// Используется для подключения обработчиков ожидания, которые не должны вызываться
// в случае интерактивных действий перед и при начале работы системы.
//
// Начальная страница (рабочий стол) в этот момент еще не открыта, поэтому запрещено открывать
// формы напрямую, а следует использовать для этих целей обработчик ожидания.
// Запрещено использовать это событие для интерактивного взаимодействия с пользователем
// (ПоказатьВопрос и аналогичные действия). Для этих целей следует использовать
// событие ПриНачалеРаботыСистемы, который поддерживает продолжение своего выполнения.
//
Процедура ПослеНачалаРаботыСистемы() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Ключ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыРаботыКлиента, "КлючПредупрежденияБезопасности");
	Если ЗначениеЗаполнено(Ключ) Тогда
		// Небольшая задержка чтобы платформа успела отрисовать текущее окно, поверх которого выводится окно предупреждения.
		ПодключитьОбработчикОжидания("ПоказатьПредупреждениеБезопасностиПослеЗапуска", 0.3, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Проверяет авторизацию пользователя и уведомляет об ошибке.
Процедура ПередНачаломРаботыСистемыДоАвторизации(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ОшибкаАвторизации") Тогда
		Параметры.ПолученныеПараметрыКлиента.Вставить("ОшибкаАвторизации");
		Параметры.Отказ = Истина;
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ИнтерактивнаяОбработкаПриОшибкеАвторизации", ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Требует сменить пароль при необходимости.
Процедура ПередНачаломРаботыСистемыПослеОбновленияИнформационнойБазы(Параметры) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	Если ПараметрыКлиента.Свойство("ТребуетсяСменитьПароль") Тогда
		Параметры.ИнтерактивнаяОбработка = Новый ОписаниеОповещения(
			"ИнтерактивнаяОбработкаПриСменеПароляПриЗапуске", ЭтотОбъект);
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик ожидания проверяет, что срок действия учетной записи истек и нужно завершить работу.
Процедура ПриВыполненииСтандартныхПериодическихПроверок(Параметры, ОбработкаПродолжения) Экспорт
	
	Если Не Параметры.ВходВПрограммуЗапрещен Тогда
		ВыполнитьОбработкуОповещения(ОбработкаПродолжения);
		Возврат;
	КонецЕсли;
	
	ОткрытьФорму("ОбщаяФорма.ВходВПрограммуЗапрещен");
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Обработчики ожидания.

// Открывает окно предупреждения безопасности.
Процедура ПоказатьПредупреждениеБезопасности() Экспорт
	
	ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	Ключ = ОбщегоНазначенияКлиентСервер.СвойствоСтруктуры(ПараметрыРаботыКлиента, "КлючПредупрежденияБезопасности");
	Если ЗначениеЗаполнено(Ключ) Тогда
		ОткрытьФорму("ОбщаяФорма.ПредупреждениеБезопасности", Новый Структура("Ключ", Ключ));
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

///////////////////////////////////////////////////////////////////////////////
// Обработчики оповещений.

// Предупреждает пользователя об ошибке недостатка прав для входа в программу.
Процедура ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограмму(Параметры, ОписаниеОшибки) Экспорт
	
	ПоказатьПредупреждение(
		Новый ОписаниеОповещения("ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограммуПослеПредупреждения",
			ЭтотОбъект, Параметры),
		ОписаниеОшибки);
	
КонецПроцедуры

// Завершает работу после предупреждения пользователя об ошибке недостатка прав для входа в программу.
Процедура ИнтерактивнаяОбработкаПриОшибкеНедостаточноПравДляВходаВПрограммуПослеПредупреждения(Параметры) Экспорт
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Предупреждает пользователя об ошибке авторизации.
Процедура ИнтерактивнаяОбработкаПриОшибкеАвторизации(Параметры, Неопределен) Экспорт
	
	ПараметрыКлиента = СтандартныеПодсистемыКлиентПовтИсп.ПараметрыРаботыКлиентаПриЗапуске();
	
	СтандартныеПодсистемыКлиент.ПоказатьПредупреждениеИПродолжить(
		Параметры, ПараметрыКлиента.ОшибкаАвторизации);
	
КонецПроцедуры

// Предлагает пользователю сменить пароль или завершить работу.
Процедура ИнтерактивнаяОбработкаПриСменеПароляПриЗапуске(Параметры, Неопределен) Экспорт
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ПриВходеВПрограмму", Истина);
	
	ОткрытьФорму("ОбщаяФорма.СменаПароля", ПараметрыФормы,,,,, Новый ОписаниеОповещения(
		"ИнтерактивнаяОбработкаПриСменеПароляПриЗапускеЗавершение", ЭтотОбъект, Параметры));
	
КонецПроцедуры

// Продолжение процедуры ИнтерактивнаяОбработкаПриСменеПароляПриЗапуске.
Процедура ИнтерактивнаяОбработкаПриСменеПароляПриЗапускеЗавершение(Результат, Параметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат) Тогда
		Параметры.Отказ = Истина;
	КонецЕсли;
	
	ВыполнитьОбработкуОповещения(Параметры.ОбработкаПродолжения);
	
КонецПроцедуры

// Записывает в форму результат выбора назначения
Процедура ПослеВыбораНазначения(РезультатЗакрытия, ДополнительныеПараметры) Экспорт
	
	Если РезультатЗакрытия = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Не ДополнительныеПараметры.ЭтоОтбор Тогда
		Назначение = ДополнительныеПараметры.ДанныеФормы.Объект.Назначение;
		Назначение.Очистить();
	КонецЕсли;
	
	МассивСинонимов = Новый Массив;
	МассивТипов = Новый Массив;
	
	Для Каждого Элемент Из РезультатЗакрытия Цикл
		
		Если Элемент.Пометка Тогда
			МассивСинонимов.Добавить(Элемент.Представление);
			МассивТипов.Добавить(Элемент.Значение);
			Если Не ДополнительныеПараметры.ЭтоОтбор Тогда
				НоваяСтрока = Назначение.Добавить();
				НоваяСтрока.ТипПользователей = Элемент.Значение;
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ЗаголовокЭлемента = СтрСоединить(МассивСинонимов, ", ");
	
	Если ДополнительныеПараметры.ЭтоОтбор Тогда
		ДополнительныеПараметры.ДанныеФормы.ВидПользователей = ЗаголовокЭлемента;
	Иначе
		ДополнительныеПараметры.ДанныеФормы.Элементы.ВыбратьНазначение.Заголовок = ЗаголовокЭлемента;
	КонецЕсли;
	
	Если ДополнительныеПараметры.ОписаниеОповещения <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ДополнительныеПараметры.ОписаниеОповещения, МассивТипов);
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Процедуры и функции обработки "НастройкиПользователей".

// Предназначена для открытия переданного отчета или формы.
//
// Параметры:
//  ТекущийЭлемент               - ТаблицаФормы - выделенная строка дерева значений.
//  Пользователь                 - Строка - имя пользователя информационной базы,
//  ТекущийПользователь          - Строка - имя пользователя информационной базы, для открытия формы
//                                 должен совпадать значением параметра "Пользователь".
//  ИмяФормыПерсональныхНастроек - Строка - путь для открытия формы персональных настроек.
//                                 Вида "ОбщаяФорма.НазваниеФормы".
Процедура ОткрытьОтчетИлиФорму(ТекущийЭлемент, Пользователь, ТекущийПользователь, ИмяФормыПерсональныхНастроек) Экспорт
	
	ЭлементДереваЗначений = ТекущийЭлемент;
	Если ЭлементДереваЗначений.ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Пользователь <> ТекущийПользователь Тогда
		ТекстПредупреждения =
			НСтр("ru = 'Для просмотра настроек другого пользователя необходимо
			           |запустить программу от его имени и открыть нужный отчет или форму.'");
		ПоказатьПредупреждение(,ТекстПредупреждения);
		Возврат;
	КонецЕсли;
	
	Если ЭлементДереваЗначений.Имя = "НастройкиОтчетовДерево" Тогда
		
		КлючОбъекта = ЭлементДереваЗначений.ТекущиеДанные.Ключи[0].Значение;
		КлючОбъектаМассивСтрок = СтрРазделить(КлючОбъекта, "/", Ложь);
		КлючВарианта = КлючОбъектаМассивСтрок[1];
		ПараметрыОтчета = Новый Структура("КлючВарианта, КлючПользовательскихНастроек", КлючВарианта, "");
		
		Если ЭлементДереваЗначений.ТекущиеДанные.Тип = "НастройкаОтчета" Тогда
			КлючПользовательскихНастроек = ЭлементДереваЗначений.ТекущиеДанные.Ключи[0].Представление;
			ПараметрыОтчета.Вставить("КлючПользовательскихНастроек", КлючПользовательскихНастроек);
		КонецЕсли;
		
		ОткрытьФорму(КлючОбъектаМассивСтрок[0] + ".Форма", ПараметрыОтчета);
		Возврат;
		
	ИначеЕсли ЭлементДереваЗначений.Имя = "ВнешнийВид" Тогда
		
		Для Каждого КлючОбъекта Из ЭлементДереваЗначений.ТекущиеДанные.Ключи Цикл
			
			Если КлючОбъекта.Пометка = Истина Тогда
				
				ИмяФормы = СтрРазделить(КлючОбъекта.Значение, "/")[0];
				ОткрытьФорму(ИмяФормы);
				Возврат;
			Иначе
				РодительЭлемента = ЭлементДереваЗначений.ТекущиеДанные.ПолучитьРодителя();
				
				Если ЭлементДереваЗначений.ТекущиеДанные.ТипСтроки = "НастройкиРабочегоСтола" Тогда
					ПоказатьПредупреждение(,
						НСтр("ru = 'Для просмотра настроек рабочего стола перейдите к разделу
						           |""Рабочий стол"" в командном интерфейсе программы.'"));
					Возврат;
				КонецЕсли;
				
				Если ЭлементДереваЗначений.ТекущиеДанные.ТипСтроки = "НастройкиКомандногоИнтерфейса" Тогда
					ПоказатьПредупреждение(,
						НСтр("ru = 'Для просмотра настроек командного интерфейса
						           |выберите нужный раздел командного интерфейса программы.'"));
					Возврат;
				КонецЕсли;
				
				Если РодительЭлемента <> Неопределено Тогда
					ТекстПредупреждения =
						НСтр("ru = 'Для просмотра данной настройки необходимо открыть ""%1"" 
						           |и затем перейти к форме ""%2"".'");
					ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстПредупреждения,
						РодительЭлемента.Настройка, ЭлементДереваЗначений.ТекущиеДанные.Настройка);
					ПоказатьПредупреждение(,ТекстПредупреждения);
					Возврат;
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
		
		ПоказатьПредупреждение(,НСтр("ru = 'Данную настройку невозможно просмотреть.'"));
		Возврат;
		
	ИначеЕсли ЭлементДереваЗначений.Имя = "ПрочиеНастройки" Тогда
		
		Если ЭлементДереваЗначений.ТекущиеДанные.Тип = "ПерсональныеНастройки"
			И ИмяФормыПерсональныхНастроек <> "" Тогда
			ОткрытьФорму(ИмяФормыПерсональныхНастроек);
			Возврат;
		КонецЕсли;
		
		ПоказатьПредупреждение(,НСтр("ru = 'Данную настройку невозможно просмотреть.'"));
		Возврат;
		
	КонецЕсли;
	
	ПоказатьПредупреждение(,НСтр("ru = 'Выберите настройку для просмотра.'"));
	
КонецПроцедуры

// Предназначена для формирования строки пояснения при копировании настроек.
//
// Параметры:
//  ПредставлениеНастройки            - Строка - название настройки. Используется если копируется одна настройка.
//  КоличествоНастроек                - Число  - количество настроек. Используется, если копируется две более настроек.
//  ПояснениеКомуСкопированыНастройки - Строка - кому копируются настройки.
//
// Возвращаемое значение:
//  Строка - текст пояснения при копировании настройки.
//
Функция ФормированиеПоясненияПриКопировании(ПредставлениеНастройки, КоличествоНастроек, ПояснениеКомуСкопированыНастройки) Экспорт
	
	Если КоличествоНастроек = 1 Тогда
		
		Если СтрДлина(ПредставлениеНастройки) > 24 Тогда
			ПредставлениеНастройки = Лев(ПредставлениеНастройки, 24) + "...";
		КонецЕсли;
		
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '""%1"" скопирована %2'"),
			ПредставлениеНастройки, ПояснениеКомуСкопированыНастройки);
	Иначе
		ПрописьПредмета = Формат(КоличествоНастроек, "ЧДЦ=0") + " "
			+ ПользователиСлужебныйКлиентСервер.ПредметЦелогоЧисла(КоличествоНастроек,
				"Л = ru_RU", НСтр("ru = 'настройка,настройки,настроек,,,,,,0'"));
		
		ТекстПояснения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Скопировано %1 %2'"),
			ПрописьПредмета, ПояснениеКомуСкопированыНастройки);
	КонецЕсли;
	
	Возврат ТекстПояснения;
	
КонецФункции

// Формирует строку получателя настройки.
//
// Параметры:
//  КоличествоПользователей - Число  - используется, если значение больше единицы.
//  Пользователь            - Строка - имя пользователя. Используется, если количество пользователей
//                            равно единице.
//
// Возвращаемое значение:
//  Строка - пояснение кому копируется настройка.
//
Функция ПояснениеПользователи(КоличествоПользователей, Пользователь) Экспорт
	
	Если КоличествоПользователей = 1 Тогда
		ПояснениеКомуСкопированыНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'пользователю ""%1""'"), Пользователь);
	Иначе
		ПояснениеКомуСкопированыНастройки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = '%1 пользователям'"), КоличествоПользователей);
	КонецЕсли;
	
	Возврат ПояснениеКомуСкопированыНастройки;
	
КонецФункции

#КонецОбласти
