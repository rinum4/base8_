﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

// Для внутреннего использования.
//
Процедура ВыполнитьСопоставлениеОбъектов(Параметры, АдресВременногоХранилища) Экспорт
	
	ПоместитьВоВременноеХранилище(РезультатСопоставленияОбъектов(Параметры), АдресВременногоХранилища);
	
КонецПроцедуры

// Для внутреннего использования.
//
Функция РезультатСопоставленияОбъектов(Параметры)
	
	СопоставлениеОбъектов = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	ОбменДаннымиСервер.ЗагрузитьКонтекстОбъекта(Параметры.КонтекстОбъекта, СопоставлениеОбъектов);
	
	Отказ = Ложь;
	
	// Применяем таблицу неутвержденных связей к базе данных.
	Если Параметры.РеквизитыФормы.ТолькоПрименитьТаблицуНеутвержденныхЗаписей Тогда
		
		СопоставлениеОбъектов.ПрименитьТаблицуНеутвержденныхЗаписей(Отказ);
		
		Если Отказ Тогда
			ВызватьИсключение НСтр("ru = 'Возникли ошибки в процессе сопоставления объектов.'");
		КонецЕсли;
		
		Возврат Неопределено;
	КонецЕсли;
	
	// Применяем результаты автоматического сопоставления объектов, полученные пользователем.
	Если Параметры.РеквизитыФормы.ПрименитьРезультатАвтоматическогоСопоставления Тогда
		
		// Дополняем таблицу неутвержденных связей.
		Для Каждого СтрокаТаблицы Из Параметры.ТаблицаАвтоматическиСопоставленныхОбъектов Цикл
			
			ЗаполнитьЗначенияСвойств(СопоставлениеОбъектов.ТаблицаНеутвержденныхСвязей.Добавить(), СтрокаТаблицы);
			
		КонецЦикла;
		
	КонецЕсли;
	
	// Применяем таблицу неутвержденных связей к базе данных.
	Если Параметры.РеквизитыФормы.ПрименитьТаблицуНеутвержденныхЗаписей Тогда
		
		СопоставлениеОбъектов.ПрименитьТаблицуНеутвержденныхЗаписей(Отказ);
		
		Если Отказ Тогда
			ВызватьИсключение НСтр("ru = 'Возникли ошибки в процессе сопоставления объектов.'");
		КонецЕсли;
		
	КонецЕсли;
	
	// Получаем таблицу сопоставления.
	СопоставлениеОбъектов.ВыполнитьСопоставлениеОбъектов(Отказ);
	
	Если Отказ Тогда
		ВызватьИсключение НСтр("ru = 'Возникли ошибки в процессе сопоставления объектов.'");
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("КоличествоОбъектовВИсточнике",       СопоставлениеОбъектов.КоличествоОбъектовВИсточнике());
	Результат.Вставить("КоличествоОбъектовВПриемнике",       СопоставлениеОбъектов.КоличествоОбъектовВПриемнике());
	Результат.Вставить("КоличествоОбъектовСопоставленных",   СопоставлениеОбъектов.КоличествоОбъектовСопоставленных());
	Результат.Вставить("КоличествоОбъектовНесопоставленных", СопоставлениеОбъектов.КоличествоОбъектовНесопоставленных());
	Результат.Вставить("ПроцентСопоставленияОбъектов",       СопоставлениеОбъектов.ПроцентСопоставленияОбъектов());
	Результат.Вставить("ТаблицаСопоставления",               СопоставлениеОбъектов.ТаблицаСопоставления());
	
	Результат.Вставить("КонтекстОбъекта", ОбменДаннымиСервер.ПолучитьКонтекстОбъекта(СопоставлениеОбъектов));
	
	Возврат Результат;
КонецФункции

// Для внутреннего использования.
//
Процедура ВыполнитьАвтоматическоеСопоставлениеОбъектов(Параметры, АдресВременногоХранилища) Экспорт
	
	ПоместитьВоВременноеХранилище(РезультатАвтоматическогоСопоставленияОбъектов(Параметры), АдресВременногоХранилища);
	
КонецПроцедуры

// Для внутреннего использования.
//
Функция РезультатАвтоматическогоСопоставленияОбъектов(Параметры)
	
	СопоставлениеОбъектов = Обработки.СопоставлениеОбъектовИнформационныхБаз.Создать();
	ОбменДаннымиСервер.ЗагрузитьКонтекстОбъекта(Параметры.КонтекстОбъекта, СопоставлениеОбъектов);
	
	// Определяем свойство "СписокИспользуемыхПолей".
	СопоставлениеОбъектов.СписокИспользуемыхПолей.Очистить();
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(Параметры.РеквизитыФормы.СписокИспользуемыхПолей, СопоставлениеОбъектов.СписокИспользуемыхПолей);
	
	// Определяем свойство "СписокПолейТаблицы".
	СопоставлениеОбъектов.СписокПолейТаблицы.Очистить();
	ОбщегоНазначенияКлиентСервер.ЗаполнитьКоллекциюСвойств(Параметры.РеквизитыФормы.СписокПолейТаблицы, СопоставлениеОбъектов.СписокПолейТаблицы);
	
	// Загружаем таблицу неутвержденных связей.
	СопоставлениеОбъектов.ТаблицаНеутвержденныхСвязей.Загрузить(Параметры.ТаблицаНеутвержденныхСвязей);
	
	Отказ = Ложь;
	
	// Получаем таблицу автоматического сопоставления объектов.
	СопоставлениеОбъектов.ВыполнитьАвтоматическоеСопоставлениеОбъектов(Отказ, Параметры.РеквизитыФормы.СписокПолейСопоставления);
	
	Если Отказ Тогда
		ВызватьИсключение НСтр("ru = 'Возникли ошибки в процессе автоматического сопоставления объектов.'");
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ПустойРезультат", СопоставлениеОбъектов.ТаблицаАвтоматическиСопоставленныхОбъектов.Количество() = 0);
	Результат.Вставить("КонтекстОбъекта", ОбменДаннымиСервер.ПолучитьКонтекстОбъекта(СопоставлениеОбъектов));
	
	Возврат Результат;
КонецФункции

#КонецОбласти

#КонецЕсли
