﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ОбменДаннымиСервер.ФормаНастройкиУзлаПриСозданииНаСервере(ЭтотОбъект, "_ДемоАвтономнаяРабота");
	
	РежимСинхронизацииДанных =
		?(ИспользоватьОтборПоОрганизациям, "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям", "СинхронизироватьВсеДанные");
	
	ОрганизацииДляОтображения.Загрузить(ВсеОрганизацииПриложения());
	
	Для Каждого СтрокаТаблицы Из Организации Цикл
		
		ОрганизацииДляОтображения.НайтиСтроки(Новый Структура("Организация", СтрокаТаблицы.Организация))[0].Использовать = Истина;
		
	КонецЦикла;
	
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	РежимСинхронизацииДанныхПриИзмененииЗначения();
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("ВыбратьИЗакрыть", ЭтотОбъект);
	ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(Оповещение, Отказ);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ КОМАНД ФОРМЫ

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ВыбратьИЗакрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Истина, "ОрганизацииДляОтображения");
	
КонецПроцедуры

&НаКлиенте
Процедура ОтключитьВсеОрганизации(Команда)
	
	ВключитьОтключитьВсеЭлементыВТаблице(Ложь, "ОрганизацииДляОтображения");
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииДанныхПриИзменении(Элемент)
	
	РежимСинхронизацииДанныхПриИзмененииЗначения();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьИЗакрыть(Результат = Неопределено, ДополнительныеПараметры = Неопределено) Экспорт
	
	ЗаписатьИЗакрытьНаСервере();
	ОбменДаннымиКлиент.ФормаНастройкиУзлаКомандаЗакрытьФорму(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура РежимСинхронизацииДанныхПриИзмененииЗначения()
	
	Элементы.Организации.Доступность =
		(РежимСинхронизацииДанных = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьОтключитьВсеЭлементыВТаблице(Включить, ИмяТаблицы)
	
	Для Каждого ЭлементКоллекции Из ЭтотОбъект[ИмяТаблицы] Цикл
		
		ЭлементКоллекции.Использовать = Включить;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаписатьИЗакрытьНаСервере()
	
	ИспользоватьОтборПоОрганизациям =
		(РежимСинхронизацииДанных = "СинхронизироватьДанныеТолькоПоВыбраннымОрганизациям");
	
	Если ИспользоватьОтборПоОрганизациям Тогда
		
		Организации.Загрузить(ОрганизацииДляОтображения.Выгрузить(Новый Структура("Использовать", Истина), "Организация"));
		
	Иначе
		
		Организации.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВсеОрганизацииПриложения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	ЛОЖЬ КАК Использовать,
	|	Организации.Ссылка КАК Организация
	|ИЗ
	|	Справочник.Организации КАК Организации
	|ГДЕ
	|	НЕ Организации.ПометкаУдаления
	|
	|УПОРЯДОЧИТЬ ПО
	|	Организации.Наименование";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	Возврат Запрос.Выполнить().Выгрузить();
КонецФункции

#КонецОбласти
