﻿#Область ОписаниеПеременных

&НаКлиенте
Перем ЗаписатьНастройки, МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии().
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоВебКлиент() Тогда
		ВызватьИсключение НСтр("ru = 'Резервное копирование недоступно в веб-клиенте.'");
	КонецЕсли;
	
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	
	Объект.ВариантВыполнения = НастройкиРезервногоКопирования.ВариантВыполнения;
	Объект.ВыполнятьАвтоматическоеРезервноеКопирование = НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование;
	Объект.РезервноеКопированиеНастроено = НастройкиРезервногоКопирования.РезервноеКопированиеНастроено;
	
	Если Не Объект.РезервноеКопированиеНастроено Тогда
		Объект.ВыполнятьАвтоматическоеРезервноеКопирование = Истина;
	КонецЕсли;
	ЭтоБазоваяВерсияКонфигурации = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	Элементы.Обычный.Видимость = Не ЭтоБазоваяВерсияКонфигурации;
	Элементы.Базовый.Видимость = ЭтоБазоваяВерсияКонфигурации;
	
	ПарольАдминистратораИБ = НастройкиРезервногоКопирования.ПарольАдминистратораИБ;
	Расписание = ОбщегоНазначенияКлиентСервер.СтруктураВРасписание(НастройкиРезервногоКопирования.РасписаниеКопирования);
	Элементы.ИзменитьРасписание.Заголовок = Строка(Расписание);
	Объект.КаталогСРезервнымиКопиями = НастройкиРезервногоКопирования.КаталогХраненияРезервныхКопий;
	
	// Заполнение настроек по хранению старых копий.
	
	ЗаполнитьЗначенияСвойств(Объект, НастройкиРезервногоКопирования.ПараметрыУдаления);
	
	ОбновитьТипОграниченияКаталогаСРезервнымиКопиями(ЭтотОбъект);
	
	ИнформацияОПользователе = РезервноеКопированиеИБСервер.ИнформацияОПользователе();
	ТребуетсяВводПароля = ИнформацияОПользователе.ТребуетсяВводПароля;
	Если ТребуетсяВводПароля Тогда
		АдминистраторИБ = ИнформацияОПользователе.Имя;
	Иначе
		Элементы.ГруппаАвторизации.Видимость = Ложь;
		Элементы.АвторизацияАдминистратораИнформационнойБазы.Видимость = Ложь;
		ПарольАдминистратораИБ = "";
	КонецЕсли;
	
	Элементы.ИзменитьРасписание.Доступность = (Объект.ВариантВыполнения = "ПоРасписанию");
	Элементы.ГруппаПараметры.Доступность = Объект.ВыполнятьАвтоматическоеРезервноеКопирование;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Резервное копирование не поддерживается в клиенте под управлением ОС Linux.'");
		ПоказатьПредупреждение(, ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	ПараметрыРезервногоКопированияИБ = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	
	МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
	ЗаписатьНастройки = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	
	Если Не ЗаписатьНастройки Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ";
		ПараметрыПриложения[ИмяПараметра].МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования
			= МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования;
	КонецЕсли;
	
	Оповестить("ЗакрытаФормаНастройкиРезервногоКопирования");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипОграниченияКаталогаСРезервнымиКопиямиПриИзменении(Элемент)
	
	
	ОбновитьТипОграниченияКаталогаСРезервнымиКопиями(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуАрхивовНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	ДиалогОткрытияФайла.Заголовок= НСтр("ru = 'Выберите каталог для сохранения резервных копий'");
	ДиалогОткрытияФайла.Каталог = Элементы.ПутьККаталогуАрхивов.ТекстРедактирования;
	
	Если ДиалогОткрытияФайла.Выбрать() Тогда
		Объект.КаталогСРезервнымиКопиями = ДиалогОткрытияФайла.Каталог;
	КонецЕсли;
	
КонецПроцедуры

// Обработчик перехода к журналу регистрации.
&НаКлиенте
Процедура НадписьПерейтиВЖурналРегистрацииНажатие(Элемент)
	ОткрытьФорму("Обработка.ЖурналРегистрации.Форма.ЖурналРегистрации", , ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура ВариантПроведенияРезервногоКопированияПриИзменении(Элемент)
	
	Элементы.ИзменитьРасписание.Доступность = (Объект.ВариантВыполнения = "ПоРасписанию");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	
	ЗаписатьНастройки = Истина;
	ПерейтиСоСтраницыНастройки();
	
КонецПроцедуры

// Вызывает стандартную форму настройки расписания регламентного задания, 
// заполняя его текущими настройками расписания резервного копирования.
&НаКлиенте
Процедура ИзменитьРасписание(Команда)
	
	ДиалогРасписания = Новый ДиалогРасписанияРегламентногоЗадания(Расписание);
	ОписаниеОповещения = Новый ОписаниеОповещения("ИзменитьРасписаниеЗавершение", ЭтотОбъект);
	ДиалогРасписания.Показать(ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПерейтиСоСтраницыНастройки()
	
	ПараметрыРезервногоКопированияИБ = ПараметрыПриложения["СтандартныеПодсистемы.ПараметрыРезервногоКопированияИБ"];
	ТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	
	Если Объект.ВыполнятьАвтоматическоеРезервноеКопирование Тогда
		
		Если Не ПроверитьКаталогСРезервнымиКопиями() Тогда
			Возврат;
		КонецЕсли;
		
		РезультатПодключения = РезервноеКопированиеИБКлиент.ПроверитьДоступКИнформационнойБазе(ПарольАдминистратораИБ);
		Если РезультатПодключения.ОшибкаПодключенияКомпоненты Тогда
			Элементы.СтраницыПомощника.ТекущаяСтраница = Элементы.ДополнительныеНастройки;
			ОбнаруженнаяОшибкаПодключения = РезультатПодключения.КраткоеОписаниеОшибки;
			Возврат;
		КонецЕсли;
		
		ЗаписатьНастройки(ТекущийПользователь);
		
		Если Объект.ВариантВыполнения = "ПоРасписанию" Тогда
			ТекущаяДата = ОбщегоНазначенияКлиент.ДатаСеанса();
			ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = ТекущаяДата;
			ПараметрыРезервногоКопированияИБ.ДатаПоследнегоРезервногоКопирования = ТекущаяДата;
			ПараметрыРезервногоКопированияИБ.РасписаниеЗначение = Расписание;
		ИначеЕсли Объект.ВариантВыполнения = "ПриЗавершенииРаботы" Тогда
			ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
		КонецЕсли;
		
		РезервноеКопированиеИБКлиент.ПодключитьОбработчикОжиданияРезервногоКопирования();
		
		ИмяФормыНастроек = "e1cib/app/%1";
		ИмяФормыНастроек = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ИмяФормыНастроек, РезервноеКопированиеИБКлиент.ИмяФормыНастроекРезервногоКопирования());
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Резервное копирование'"), ИмяФормыНастроек,
			НСтр("ru = 'Резервное копирование настроено.'"));
		
	Иначе
		
		ОстановитьСервисОповещения(ТекущийПользователь);
		РезервноеКопированиеИБКлиент.ОтключитьОбработчикОжиданияРезервногоКопирования();
		ПараметрыРезервногоКопированияИБ.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
		
	КонецЕсли;
	
	ПараметрыРезервногоКопированияИБ.ПараметрОповещения = "НеОповещать";
	
	ОбновитьПовторноИспользуемыеЗначения();
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьКаталогСРезервнымиКопиями()
	
	РеквизитыЗаполнены = Истина;
	
	Если ПустаяСтрока(Объект.КаталогСРезервнымиКопиями) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не выбран каталог для резервной копии.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.КаталогСРезервнымиКопиями");
		РеквизитыЗаполнены = Ложь;
		
	ИначеЕсли НайтиФайлы(Объект.КаталогСРезервнымиКопиями).Количество() = 0 Тогда
		
		ТекстСообщения = НСтр("ru = 'Указан несуществующий каталог.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.КаталогСРезервнымиКопиями");
		РеквизитыЗаполнены = Ложь;
		
	Иначе
		
		Попытка
			ТестовыйФайл = Новый ЗаписьXML;
			ТестовыйФайл.ОткрытьФайл(Объект.КаталогСРезервнымиКопиями + "/test.test1С");
			ТестовыйФайл.ЗаписатьОбъявлениеXML();
			ТестовыйФайл.Закрыть();
		Исключение
			ТекстСообщения = НСтр("ru = 'Нет доступа к каталогу с резервными копиями.'");
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "Объект.КаталогСРезервнымиКопиями");
			РеквизитыЗаполнены = Ложь;
		КонецПопытки;
		
		Если РеквизитыЗаполнены Тогда
			
			Попытка
				УдалитьФайлы(Объект.КаталогСРезервнымиКопиями, "*.test1С");
			Исключение
				// Исключение не обрабатываем т.к. на этом шаге не происходит удаления файлов.
			КонецПопытки;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ТребуетсяВводПароля И ПустаяСтрока(ПарольАдминистратораИБ) Тогда
		
		ТекстСообщения = НСтр("ru = 'Не задан пароль администратора.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,, "ПарольАдминистратораИБ");
		РеквизитыЗаполнены = Ложь;
		
	КонецЕсли;
	
	Возврат РеквизитыЗаполнены;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ОстановитьСервисОповещения(ТекущийПользователь)
	// Останавливает оповещения о резервном копировании.
	НастройкиРезервногоКопирования = РезервноеКопированиеИБСервер.НастройкиРезервногоКопирования();
	НастройкиРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование = Ложь;
	НастройкиРезервногоКопирования.РезервноеКопированиеНастроено = Истина;
	НастройкиРезервногоКопирования.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(НастройкиРезервногоКопирования, ТекущийПользователь);
КонецПроцедуры

&НаСервере
Процедура ЗаписатьНастройки(ТекущийПользователь)
	
	ЭтоБазоваяВерсияКонфигурации = СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации();
	Если ЭтоБазоваяВерсияКонфигурации Тогда
		Объект.ВариантВыполнения = "ПриЗавершенииРаботы";
	КонецЕсли;
	
	ПараметрыРезервногоКопирования = РезервноеКопированиеИБСервер.ПараметрыРезервногоКопирования();
	
	ПараметрыРезервногоКопирования.Вставить("АдминистраторИБ", АдминистраторИБ);
	ПараметрыРезервногоКопирования.Вставить("ПарольАдминистратораИБ", ?(ТребуетсяВводПароля, ПарольАдминистратораИБ, ""));
	ПараметрыРезервногоКопирования.ДатаПоследнегоОповещения = Дата('29990101');
	ПараметрыРезервногоКопирования.КаталогХраненияРезервныхКопий = Объект.КаталогСРезервнымиКопиями;
	ПараметрыРезервногоКопирования.ВариантВыполнения = Объект.ВариантВыполнения;
	ПараметрыРезервногоКопирования.ВыполнятьАвтоматическоеРезервноеКопирование = Объект.ВыполнятьАвтоматическоеРезервноеКопирование;
	ПараметрыРезервногоКопирования.РезервноеКопированиеНастроено = Истина;
	
	ЗаполнитьЗначенияСвойств(ПараметрыРезервногоКопирования.ПараметрыУдаления, Объект);
	
	Если Объект.ВариантВыполнения = "ПоРасписанию" Тогда
		
		РасписаниеСтруктура = ОбщегоНазначенияКлиентСервер.РасписаниеВСтруктуру(Расписание);
		ПараметрыРезервногоКопирования.РасписаниеКопирования = РасписаниеСтруктура;
		ПараметрыРезервногоКопирования.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = ТекущаяДатаСеанса();
		ПараметрыРезервногоКопирования.ДатаПоследнегоРезервногоКопирования = ТекущаяДатаСеанса();
		
	ИначеЕсли Объект.ВариантВыполнения = "ПриЗавершенииРаботы" Тогда
		
		ПараметрыРезервногоКопирования.МинимальнаяДатаСледующегоАвтоматическогоРезервногоКопирования = '29990101';
		
	КонецЕсли;
	
	РезервноеКопированиеИБСервер.УстановитьПараметрыРезервногоКопирования(ПараметрыРезервногоКопирования, ТекущийПользователь);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьТипОграниченияКаталогаСРезервнымиКопиями(Форма)
	
	Форма.Элементы.ГруппаВыбораТипаОчистки.Доступность = (Форма.Объект.ТипОграничения <> "ХранитьВсе");
	Форма.Элементы.ГруппаХранитьПоследниеЗаПериод.Доступность = (Форма.Объект.ТипОграничения = "ПоПериоду");
	Форма.Элементы.ГруппаКоличествоКопийВКаталоге.Доступность = (Форма.Объект.ТипОграничения = "ПоКоличеству");
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРасписаниеЗавершение(РасписаниеРезультат, ДополнительныеПараметры) Экспорт
	
	Если РасписаниеРезультат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Расписание = РасписаниеРезультат;
	Элементы.ИзменитьРасписание.Заголовок = Строка(Расписание);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции проведения резервного копирования.

&НаКлиенте
Процедура ВыполнятьАвтоматическоеРезервноеКопированиеПриИзменении(Элемент)
	
	Элементы.ГруппаПараметры.Доступность = Объект.ВыполнятьАвтоматическоеРезервноеКопирование;
	
КонецПроцедуры

#КонецОбласти
