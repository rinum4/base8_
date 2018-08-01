﻿#Область ПрограммныйИнтерфейс

// Начинает замер времени ключевой операции.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
//
// Параметры:
//	АвтоЗавершение - Булево	 - 	признак автоматического завершения замера.
//								Истина - завершение замера будет выполнено автоматически
//								через глобальный обработчик ожидания.
//								Ложь - завершить замер необходимо явно вызовом процедуры
//								ЗавершитьЗамерВремени.
//	КлючеваяОперация - Строка - имя ключевой операции. Если Неопределено> то ключевую операцию
//								необходимо указать явно вызовом процедуры
//								УстановитьКлючевуюОперациюЗамера.
//
// Возвращаемое значение:
//	УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция НачатьЗамерВремени(АвтоЗавершение = Истина, КлючеваяОперация = Неопределено) Экспорт
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
		Параметры.Вставить("ВыполненаСОшибкой", Ложь);
				
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
	КонецЕсли;
		
	Возврат УИДЗамера;
	
КонецФункции

// Начинает технологический замер времени ключевой операции.
// Результат замера будет записан в РегистрСведений.ЗамерыВремени.
//
// Параметры:
//	АвтоЗавершение - Булево	 - 	признак автоматического завершения замера.
//								Истина - завершение замера будет выполнено автоматически
//								через глобальный обработчик ожидания.
//								Ложь - завершить замер необходимо явно вызовом процедуры
//								ЗавершитьЗамерВремени.
//	КлючеваяОперация - Строка - имя ключевой операции. Если Неопределено> то ключевую операцию
//								необходимо указать явно вызовом процедуры
//								УстановитьКлючевуюОперациюЗамера.
//
// Возвращаемое значение:
//	УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция НачатьЗамерВремениТехнологический(АвтоЗавершение = Истина, КлючеваяОперация = Неопределено) Экспорт
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
		Параметры.Вставить("Технологический", Истина);
		Параметры.Вставить("ВыполненаСОшибкой", Ложь);
		
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
	КонецЕсли;
		
	Возврат УИДЗамера;
	
КонецФункции

// Завершает замер времени на клиенте.
//
// Параметры:
//  УИДЗамера - УникальныйИдентификатор - уникальный идентификатор замера.
//
Процедура ЗавершитьЗамерВремени(УИДЗамера) Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ЗавершитьЗамерВремениСлужебный(УИДЗамера, ВремяОкончания);
		
		Замеры = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["Замеры"];
		Замер = Замеры[УИДЗамера];
		Если Замер <> Неопределено Тогда
			ЗамерыЗавершенные = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["ЗамерыЗавершенные"];
			ЗамерыЗавершенные.Вставить(УИДЗамера, Замер);
			Замеры.Удалить(УИДЗамера);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает параметры замера.
//
// Параметры:
//	УИДЗамера	- УникальныйИдентификатор - уникальный идентификатор замера.
//	ПараметрыЗамера	- Структура - структура со свойствами:
//		* КлючеваяОперация 	- Строка					- имя ключевой операции.
//		* ВесЗамера			- Число						- количественный показатель сложности замера
//		* Комментарий		- Строка, Соответствие		- дополнительная произвольной информации замера.
//		* ВыполненаСОшибкой - Булево					- признак выполнения замера с ошибкой,
//														  см. процедуру УстановитьПризнакОшибкиЗамера.
//
Процедура УстановитьПараметрыЗамера(УИДЗамера, ПараметрыЗамера) Экспорт
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];
		Для Каждого Параметр Из ПараметрыЗамера Цикл
			Замеры[УИДЗамера][Параметр.Ключ] = Параметр.Значение;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает ключевую операцию замера.
//
// Параметры:
//	УИДЗамера 			- УникальныйИдентификатор - уникальный идентификатор замера.
//	КлючеваяОперация	- Строка - наименование ключевой операции.
//
// Если на момент начала замера имя ключевой операции еще неизвестно,
// то с помощью этой процедуры в любой момент до завершения замера можно
// доопределить имя ключевой операции.
// Например, при проведении документа, т.к. в момент начала проведения
// мы не можем гарантировать, что проведение документа завершиться и не будет отказа.
// 
// &НаКлиенте
// Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
//	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
//		ИдентификаторЗамераПроведение = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина);
//	КонецЕсли;
// КонецПроцедуры
//
// &НаКлиенте
// Процедура ПослеЗаписи(ПараметрыЗаписи)
//	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.Проведение Тогда
//		ОценкаПроизводительностиКлиент.УстановитьКлючевуюОперациюЗамера(ИдентификаторЗамераПроведение, "_ДемоПроведениеДокумента");
//	КонецЕсли;
// КонецПроцедуры
//
Процедура УстановитьКлючевуюОперациюЗамера(УИДЗамера, КлючеваяОперация) Экспорт
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["КлючеваяОперация"] = КлючеваяОперация;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает вес операции замера.
//
// Параметры:
//	УИДЗамера - УникальныйИдентификатор - уникальный идентификатор замера.
//	ВесЗамера - Число					- количественный показатель сложности
//										  замера, например количество строк в документе.
//
Процедура УстановитьВесЗамера(УИДЗамера, ВесЗамера) Экспорт
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["ВесЗамера"] = ВесЗамера;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает комментарий операции замера.
//
// Параметры:
//  УИДЗамера   - УникальныйИдентификатор - уникальный идентификатор замера.
//  Комментарий - Строка, Соответствие    - дополнительная произвольной информации замера.
//                                          В случае указания соответствия:
//                                            * Ключ     - Строка - имя дополнительного параметра информации замера.
//                                            * Значение - Строка, Число, Булево - значение дополнительного параметра замера.
//
Процедура УстановитьКомментарийЗамера(УИДЗамера, Комментарий) Экспорт
		
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["Комментарий"] = Комментарий;
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает признак ошибки операции замера.
//
// Параметры:
//	УИДЗамера	- УникальныйИдентификатор	- уникальный идентификатор замера.
//	Признак		- Булево					- признак замера. Истина - замер выполнился без ошибок.
//											  Ложь - при выполнении замера есть ошибка.
//
Процедура УстановитьПризнакОшибкиЗамера(УИДЗамера, Признак) Экспорт
	
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];	
		Замеры[УИДЗамера]["ВыполненаСОшибкой"] = Признак;
	КонецЕсли;
	
КонецПроцедуры

// Начинает замер времени выполнения длительной ключевой операции. Закончить замер нужно явно вызовом
// процедуры ЗакончитьЗамерДлительнойОперации.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
//
// Параметры:
//	КлючеваяОперация - Строка - имя ключевой операции. 
//
// Возвращаемое значение:
// 	ОписаниеЗамера - соответствие.
//   КлючеваяОперация - имя ключевой операции.
//   ВремяНачала - время начала ключевой операции в миллисекундах.
//   ВремяПоследнегоЗамера - время последнего замера ключевой операции в миллисекундах.
//   ВесЗамера - количество данных, обработанных в ходе выполнения действий.
//   ВложенныеЗамеры - коллекция замеров вложенных шагов.
//
Функция НачатьЗамерДлительнойОперации(КлючеваяОперация) Экспорт
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	Замер = Новый Соответствие;
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("ВыполненаСОшибкой", Ложь);
		Параметры.Вставить("АвтоЗавершение", Ложь);
				
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
		
		ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
		Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];
		Замер = Замеры[УИДЗамера]; 		
		Замер.Вставить("ВремяПоследнегоЗамера", Замер["ВремяНачала"]);
		Замер.Вставить("УдельноеВремя", 0.0);
		Замер.Вставить("ВесЗамера", 0);
		Замер.Вставить("ВложенныеЗамеры", Новый Соответствие);
		Замер.Вставить("УИДЗамера", УИДЗамера);
		Замер.Вставить("Клиентский", Истина);
		
	КонецЕсли;
		
	Возврат Замер;
	
КонецФункции

// Фиксирует замер вложенного шага длительной операции.
// Параметры:
//	ОписаниеЗамера 		- Соответствие	 - должно быть получено вызовом метода НачатьЗамерДлительнойОперации.
//	КоличествоДанных 	- Число			 - количество данных, например, строк, обработанных в ходе выполнения вложенного шага.
//	ИмяШага 			- Строка		 - произвольное имя вложенного шага.
//	Комментарий 		- Строка		 - произвольное дополнительное описание замера.
//
Процедура ЗафиксироватьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанных, ИмяШага, Комментарий = "") Экспорт
	
	Если НЕ ЗначениеЗаполнено(ОписаниеЗамера) Тогда
		Возврат;
	КонецЕсли;
	
	ТекущееВремя = ТекущаяУниверсальнаяДатаВМиллисекундах();
	КоличествоДанныхШага = ?(КоличествоДанных = 0, 1, КоличествоДанных);
	
	Длительность = ТекущееВремя - ОписаниеЗамера["ВремяПоследнегоЗамера"];
	// Если вложенный замер выполняется первый раз, то инициализируем его.
	ВложенныеЗамеры = ОписаниеЗамера["ВложенныеЗамеры"];
	Если ВложенныеЗамеры[ИмяШага] = Неопределено Тогда
		ВложенныеЗамеры.Вставить(ИмяШага, Новый Соответствие);
		ШагВложенногоЗамера = ВложенныеЗамеры[ИмяШага];
		ШагВложенногоЗамера.Вставить("Комментарий", Комментарий);
		ШагВложенногоЗамера.Вставить("ВремяНачала", ОписаниеЗамера["ВремяПоследнегоЗамера"]);
		ШагВложенногоЗамера.Вставить("Длительность", 0.0);	
		ШагВложенногоЗамера.Вставить("ВесЗамера", 0);
	КонецЕсли;                                                            
	// Пишем данные вложенного замера.
	ШагВложенногоЗамера = ВложенныеЗамеры[ИмяШага];
	ШагВложенногоЗамера.Вставить("ВремяОкончания", ТекущееВремя);
	ШагВложенногоЗамера.Вставить("Длительность", Длительность + ШагВложенногоЗамера["Длительность"]);
	ШагВложенногоЗамера.Вставить("ВесЗамера", КоличествоДанныхШага + ШагВложенногоЗамера["ВесЗамера"]);
	
	// Пишем данные длительного замера
	ОписаниеЗамера.Вставить("ВремяПоследнегоЗамера", ТекущееВремя);
	ОписаниеЗамера.Вставить("ВесЗамера", КоличествоДанныхШага + ОписаниеЗамера["ВесЗамера"]);
	
КонецПроцедуры

// Завершает замер длительной операции.
// Если указано имя шага, фиксирует его как отдельный вложенный шаг
// Параметры:
//	ОписаниеЗамера 		- Соответствие	 - должно быть получено вызовом метода НачатьЗамерДлительнойОперации.
//	КоличествоДанных 	- Число			 - количество данных, например, строк, обработанных в ходе выполнения вложенного шага.
//	ИмяШага 			- Строка		 - произвольное имя вложенного шага.
//	Комментарий 		- Строка		 - произвольное дополнительное описание замера.
//
Процедура ЗакончитьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанных, ИмяШага = "", Комментарий = "") Экспорт
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		
		Если ОписаниеЗамера["ВложенныеЗамеры"].Количество() Тогда
			КоличествоДанныхШага = ?(КоличествоДанных = 0, 1, КоличествоДанных);
			ЗафиксироватьЗамерДлительнойОперации(ОписаниеЗамера, КоличествоДанныхШага, ?(ПустаяСтрока(ИмяШага), "ПоследнийШаг", ИмяШага), Комментарий);
		КонецЕсли;
		
		УИДЗамера = ОписаниеЗамера["УИДЗамера"];
		ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
		ЗавершитьЗамерВремениСлужебный(УИДЗамера, ВремяОкончания);
		
		Замеры = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["Замеры"];
		Замер = Замеры[УИДЗамера];
		
		Если Замер <> Неопределено Тогда
			ЗамерыЗавершенные = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["ЗамерыЗавершенные"];
			ОписаниеЗамера.Вставить("ВремяОкончания", Замер["ВремяОкончания"]);
			ЗамерыЗавершенные.Вставить(УИДЗамера, ОписаниеЗамера);
			Замеры.Удалить(УИДЗамера);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий подсистем конфигурации.

// См. ОбщегоНазначенияКлиентПереопределяемый.ПередНачаломРаботыСистемы.
Процедура ПередНачаломРаботыСистемы(Параметры) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительности.ВремяНачалаЗапуска";
	ВремяНачала = ПараметрыПриложения[ИмяПараметра];
	ПараметрыПриложения.Удалить(ИмяПараметра);
	
	НачатьЗамерВремениСоСмещением(ВремяНачала, Истина, "ОбщееВремяЗапускаПриложения");
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Начинает замер времени ключевой операции.
// Результат замера будет записан в регистр сведений ЗамерыВремени.
//
// Параметры:
//	Смещение - Число	 	 - 	дата и время начала замера в миллисекундах (см. ТекущаяУниверсальнаяДатаВМиллисекундах).
//	АвтоЗавершение - Булево	 - 	признак автоматического завершения замера.
//								Истина - завершение замера будет выполнено автоматически
//								через глобальный обработчик ожидания.
//								Ложь - завершить замер необходимо явно вызовом процедуры
//								ЗавершитьЗамерВремени.
//	КлючеваяОперация - Строка - имя ключевой операции. Если Неопределено> то ключевую операцию
//								необходимо указать явно вызовом процедуры
//								УстановитьКлючевуюОперациюЗамера.
//
// Возвращаемое значение:
//	УникальныйИдентификатор - уникальный идентификатор замера, который позволяет идентифицировать замер.
//
Функция НачатьЗамерВремениСоСмещением(Смещение, АвтоЗавершение = Истина, КлючеваяОперация = Неопределено)
	
	УИДЗамера = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	
	Если ВыполнятьЗамерыПроизводительности() Тогда
		УИДЗамера = Новый УникальныйИдентификатор();
		Параметры = Новый Структура;
		Параметры.Вставить("КлючеваяОперация", КлючеваяОперация);
		Параметры.Вставить("УИДЗамера", УИДЗамера);
		Параметры.Вставить("АвтоЗавершение", АвтоЗавершение);
		Параметры.Вставить("ВыполненаСОшибкой", Ложь);
		Параметры.Вставить("Смещение", Смещение);
				
		НачатьЗамерВремениНаКлиентеСлужебный(Параметры);
	КонецЕсли;
		
	Возврат УИДЗамера;
	
КонецФункции

Функция ВыполнятьЗамерыПроизводительности()
	
	ВыполнятьЗамерыПроизводительности = Ложь;
	
	ИмяПараметраСтандартныеПодсистемы = "СтандартныеПодсистемы.ПараметрыКлиента";
	
	Если ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы] = Неопределено Тогда
		ВыполнятьЗамерыПроизводительности = ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности();
	Иначе
		Если ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы].Свойство("ОценкаПроизводительности") Тогда
			ВыполнятьЗамерыПроизводительности = ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы]["ОценкаПроизводительности"]["ВыполнятьЗамерыПроизводительности"];
		Иначе
			ВыполнятьЗамерыПроизводительности = ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности();
		КонецЕсли;
	КонецЕсли;
	
	Возврат ВыполнятьЗамерыПроизводительности; 
	
КонецФункции

Процедура НачатьЗамерВремениНаКлиентеСлужебный(Параметры)
    
    ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();
    
	Если ПараметрыПриложения = Неопределено Тогда
		ПараметрыПриложения = Новый Соответствие;
	КонецЕсли;
		
	ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
	Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
		ПараметрыПриложения.Вставить(ИмяПараметра, Новый Структура);
		ПараметрыПриложения[ИмяПараметра].Вставить("Замеры", Новый Соответствие);
		ПараметрыПриложения[ИмяПараметра].Вставить("ЗамерыЗавершенные", Новый Соответствие);
		ПараметрыПриложения[ИмяПараметра].Вставить("ЕстьОбработчик", Ложь);
		ПараметрыПриложения[ИмяПараметра].Вставить("ВремяПодключенияОбработчика", ВремяНачала);
		
		ИмяПараметраСтандартныеПодсистемы = "СтандартныеПодсистемы.ПараметрыКлиента";
		Если ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы] = Неопределено Тогда
			ПараметрыОценкиПроизводительности = ОценкаПроизводительностиВызовСервера.ПолучитьПараметрыНаСервере();
			ТекущийПериодЗаписи = ПараметрыОценкиПроизводительности.ПериодЗаписи;
			ДатаИВремяНаСервере = ПараметрыОценкиПроизводительности.ДатаИВремяНаСервере;
		
			// Получаем дату в UTC
			ДатаИВремяНаКлиенте = ТекущаяУниверсальнаяДатаВМиллисекундах();
			ПараметрыПриложения[ИмяПараметра].Вставить("СмещениеДатыКлиента", ДатаИВремяНаСервере - ДатаИВремяНаКлиенте);
		Иначе
			ПараметрыПриложенияСтандартныеПодсистемы = ПараметрыПриложения[ИмяПараметраСтандартныеПодсистемы];
			Если ПараметрыПриложенияСтандартныеПодсистемы.Свойство("ОценкаПроизводительности") Тогда
				ТекущийПериодЗаписи = ПараметрыПриложенияСтандартныеПодсистемы["ОценкаПроизводительности"]["ПериодЗаписи"];
				ПараметрыПриложения[ИмяПараметра].Вставить("СмещениеДатыКлиента", ПараметрыПриложенияСтандартныеПодсистемы["СмещениеДатыКлиента"]);
			Иначе
				ПараметрыОценкиПроизводительности = ОценкаПроизводительностиВызовСервера.ПолучитьПараметрыНаСервере();
				ТекущийПериодЗаписи = ПараметрыОценкиПроизводительности.ПериодЗаписи;
				ДатаИВремяНаСервере = ПараметрыОценкиПроизводительности.ДатаИВремяНаСервере;
				
				// Получаем дату в UTC
				ДатаИВремяНаКлиенте = ТекущаяУниверсальнаяДатаВМиллисекундах();
				ПараметрыПриложения[ИмяПараметра].Вставить("СмещениеДатыКлиента", ДатаИВремяНаСервере - ДатаИВремяНаКлиенте);
			КонецЕсли;
		КонецЕсли;
				
		ИнформацияПрограммыПросмотра = "";
		#Если ТолстыйКлиентУправляемоеПриложение Тогда
			ИнформацияПрограммыПросмотра = "ТолстыйКлиентУправляемоеПриложение";
		#ИначеЕсли ТолстыйКлиентОбычноеПриложение Тогда
			ИнформацияПрограммыПросмотра = "ТолстыйКлиент";
		#ИначеЕсли ТонкийКлиент Тогда
			ИнформацияПрограммыПросмотра = "ТонкийКлиент";
		#ИначеЕсли ВебКлиент Тогда
			ИнфоКлиента = Новый СистемнаяИнформация();
			ИнформацияПрограммыПросмотра = ИнфоКлиента.ИнформацияПрограммыПросмотра;
		#КонецЕсли
		ПараметрыПриложения[ИмяПараметра].Вставить("ИнформацияПрограммыПросмотра", ИнформацияПрограммыПросмотра);
						
		ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", ТекущийПериодЗаписи, Истина);
	КонецЕсли;
	
	// Фактическое начало замера времени на клиенте.
	// Выше поднять нельзя, т.к. при замере времени открытия приложения ПараметрыПриложения
	// еще не инициализированы.
	//
	
	Если Параметры.Свойство("Смещение") Тогда
		ВремяНачала = Параметры.Смещение + ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];;
	Иначе
		ВремяНачала = ВремяНачала + ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];
	КонецЕсли;
		
	КлючеваяОперация = Параметры.КлючеваяОперация;
	УИДЗамера = Параметры.УИДЗамера;
	АвтоЗавершение = Параметры.АвтоЗавершение;
	
	Если Параметры.Свойство("Комментарий") Тогда
		Комментарий = Параметры.Комментарий;
	Иначе
		Комментарий = Неопределено;
	КонецЕсли;
	
	Если Параметры.Свойство("Технологический") Тогда
		Технологический = Параметры.Технологический;
	Иначе
		Технологический = Ложь;
	КонецЕсли;
	
	Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"]; 
	Замеры.Вставить(УИДЗамера, Новый Соответствие);
	Замер = Замеры[УИДЗамера];
	Замер.Вставить("КлючеваяОперация", КлючеваяОперация);
	Замер.Вставить("АвтоЗавершение", АвтоЗавершение);
	Замер.Вставить("ВремяНачала", ВремяНачала);
	Замер.Вставить("Комментарий", Комментарий);
	Замер.Вставить("Технологический", Технологический);
	Замер.Вставить("ВесЗамера", 1);
	
	Если АвтоЗавершение Тогда
		Если НЕ ПараметрыПриложения[ИмяПараметра]["ЕстьОбработчик"] Тогда
			ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);
			ПараметрыПриложения[ИмяПараметра]["ЕстьОбработчик"] = Истина;
			ПараметрыПриложения[ИмяПараметра]["ВремяПодключенияОбработчика"] = ТекущаяУниверсальнаяДатаВМиллисекундах() + ПараметрыПриложения[ИмяПараметра]["СмещениеДатыКлиента"];
		КонецЕсли;	
	КонецЕсли;	
	
КонецПроцедуры

// Автоматически завершает замер времени на клиенте.
//
Процедура ЗавершитьЗамерВремениНаКлиентеАвто() Экспорт
	
	ВремяОкончания = ТекущаяУниверсальнаяДатаВМиллисекундах();
	
	ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
	ВремяПодключенияОбработчика = ОценкаПроизводительностиЗамерВремени["ВремяПодключенияОбработчика"];
		
    Если ОценкаПроизводительностиЗамерВремени <> Неопределено Тогда
        
        Замеры = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["Замеры"];
		ЗамерыЗавершенные = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["ЗамерыЗавершенные"];
		
		ДляУдаления = Новый Массив;
        
        КоличествоНеЗавершенныхАвтоЗамеров = 0;
		Для Каждого Замер Из Замеры Цикл
			ЗамерЗначение = Замер.Значение;
            Если ЗамерЗначение["АвтоЗавершение"] Тогда 
                Если ЗамерЗначение["ВремяНачала"] <= ВремяПодключенияОбработчика И ЗамерЗначение["ВремяОкончания"] = Неопределено Тогда
                    // Смещение даты клиента рассчитывается внутри процедуры
                    ЗавершитьЗамерВремениСлужебный(Замер.Ключ, ВремяОкончания);
                    Если ЗначениеЗаполнено(Замер.Значение["КлючеваяОперация"]) Тогда
                        ЗамерыЗавершенные.Вставить(Замер.Ключ, Замер.Значение);
                    КонецЕсли;
                    ДляУдаления.Добавить(Замер.Ключ);
                Иначе
                    КоличествоНеЗавершенныхАвтоЗамеров = КоличествоНеЗавершенныхАвтоЗамеров + 1;
                КонецЕсли;
            КонецЕсли;
		КонецЦикла;
		
		Для Каждого ТекЗамер Из ДляУдаления Цикл
			Замеры.Удалить(ТекЗамер);
		КонецЦикла;
	КонецЕсли;
	
	Если КоличествоНеЗавершенныхАвтоЗамеров = 0 Тогда
		ОценкаПроизводительностиЗамерВремени["ЕстьОбработчик"] = Ложь;
	Иначе
		ПодключитьОбработчикОжидания("ЗакончитьЗамерВремениАвто", 0.1, Истина);
		ОценкаПроизводительностиЗамерВремени["ЕстьОбработчик"] = Истина;
		ОценкаПроизводительностиЗамерВремени["ВремяПодключенияОбработчика"] = ТекущаяУниверсальнаяДатаВМиллисекундах() + ОценкаПроизводительностиЗамерВремени["СмещениеДатыКлиента"];
	КонецЕсли;
КонецПроцедуры

Процедура ЗавершитьЗамерВремениСлужебный(УИДЗамера, Знач ВремяОкончания)
		
	Если ОценкаПроизводительностиВызовСервераПовтИсп.ВыполнятьЗамерыПроизводительности() Тогда
		ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
		Если ОценкаПроизводительностиЗамерВремени <> Неопределено Тогда
			СмещениеДатыКлиента = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["СмещениеДатыКлиента"];
			ВремяОкончания = ВремяОкончания + СмещениеДатыКлиента;
			
			Замеры = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"]["Замеры"];
			Замер = Замеры[УИДЗамера];
			Если Замер <> Неопределено Тогда
				Замер.Вставить("ВремяОкончания", ВремяОкончания);
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

// Произвести запись накопленных замеров времени выполнения ключевых операций на сервере.
//
// Параметры:
//  ПередЗавершением - Булево - Истина, если метод вызывается перед закрытием приложения.
//
Процедура ЗаписатьРезультатыАвтоНеГлобальный(ПередЗавершением = Ложь) Экспорт
	
	ОценкаПроизводительностиЗамерВремени = ПараметрыПриложения["СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени"];
	
	Если ОценкаПроизводительностиЗамерВремени <> Неопределено Тогда
		ЗамерыЗавершенные = ОценкаПроизводительностиЗамерВремени["ЗамерыЗавершенные"];
		ОценкаПроизводительностиЗамерВремени["ЗамерыЗавершенные"] = Новый Соответствие;
		
		ЗамерыДляЗаписи = Новый Структура;
		ЗамерыДляЗаписи.Вставить("ЗамерыЗавершенные", ЗамерыЗавершенные);
		ЗамерыДляЗаписи.Вставить("ИнформацияПрограммыПросмотра", ОценкаПроизводительностиЗамерВремени["ИнформацияПрограммыПросмотра"]);
		НовыйПериодЗаписи = ОценкаПроизводительностиВызовСервера.ЗафиксироватьДлительностьКлючевыхОпераций(ЗамерыДляЗаписи);
				
		ПодключитьОбработчикОжидания("ЗаписатьРезультатыАвто", НовыйПериодЗаписи, Истина);
	КонецЕсли;
	
КонецПроцедуры

// Процедура изменяет уникальный идентификатор замера
// Необходима для обратной совместимости, не использовать
//	Параметры:
//		УИДЗамераСтарый	- предыдущий УникальныйИдентификатор замера.
// 		УИДЗамераНовый	- новый УникальныйИдентификатор замера.
Процедура ИзменитьУИДЗамера(УИДЗамераСтарый, УИДЗамераНовый) Экспорт
	
	ИмяПараметра = "СтандартныеПодсистемы.ОценкаПроизводительностиЗамерВремени";
	Замеры = ПараметрыПриложения[ИмяПараметра]["Замеры"];
	Замеры.Вставить(УИДЗамераНовый, Замеры[УИДЗамераСтарый]);
	Замеры.Удалить(УИДЗамераСтарый);
	
КонецПроцедуры
#КонецОбласти