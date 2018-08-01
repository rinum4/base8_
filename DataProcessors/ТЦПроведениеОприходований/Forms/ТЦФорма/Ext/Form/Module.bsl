﻿///////////////////////////////////////////////////////////////////////////////
// В Н И М А Н И Е!
// ПЕРЕМЕННЫЕ, ПРОЦЕДУРЫ И ФУНКЦИИ, НАЧИНАЮЩИЕСЯ С "ТЦ", НЕЛЬЗЯ УДАЛЯТЬ, Т.К.
// ОНИ НЕОБХОДИМЫ ДЛЯ ПРАВИЛЬНОЙ РАБОТЫ ТЕСТ-ЦЕНТРА
//

&НаКлиенте
Перем ТЦКонтекстВыполнения; // Служебная переменная Тест-центра
&НаКлиенте
Перем ТЦИмяОбработчика;     // Служебная переменная Тест-центра
&НаКлиенте
Перем ТЦДокументыДляПроведения;
&НаКлиенте
Перем ТЦВремяНачалаТеста;

///////////////////////////////////////////////////////////////////////////////
// ИНТЕРФЕЙС РАЗРАБОТЧИКА СЦЕНАРИЯ

&НаКлиенте
// Единовременная подготовка данных перед выполнением действия.
// Эта подготовка выполняется только при необходимости и не является
// обязательной.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.
//   Успешно - если при инициализации ошибок не возникло
//   Предупреждение - если возникшие ошибки позволяют продолжить выполнение
//   Ошибка - если возникли ошибки, которые не позволяют продолжить выполнение
//
Функция ТЦИнициализировать() Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Код обычного приложения
	#Иначе
		// Код управляемого приложения
		ТЦДокументыДляПроведения = ТЦПолучитьСписокДокументовДляПроведения();
		
	#КонецЕсли
	
	Возврат ТЦРезультатВыполненияУспешно();
	
КонецФункции // ТЦИнициализировать()

&НаСервере
Функция ТЦПолучитьСписокДокументовДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 100
	|	_ДемоОприходованиеТоваров.Ссылка
	|ИЗ
	|	Документ._ДемоОприходованиеТоваров КАК _ДемоОприходованиеТоваров
	|ГДЕ
	|	_ДемоОприходованиеТоваров.Проведен
	|	И НЕ _ДемоОприходованиеТоваров.ПометкаУдаления";
	
	МассивДокументов = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Возврат МассивДокументов;
	
КонецФункции

&НаКлиенте
// Выполнение действия.
// В этой функции содержится основной код действия, необходимый для выполнения
// сценария.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.
//   Успешно - если при инициализации ошибок не возникло
//   Предупреждение - если возникшие ошибки позволяют продолжить выполнение
//   Ошибка - если возникли ошибки, которые не позволяют продолжить выполнение
//
Функция ТЦВыполнить() Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Код обычного приложения
	#Иначе
		// Код управляемого приложения
		ТЦВремяНачалаТеста = ТекущаяДата();
		
	#КонецЕсли
	
	// ТЦЗаписатьПоказатель("ВремяВыполнения", ВремяВыполнения);
	Возврат ТЦРезультатВыполненияПродолжить("ТЦВыполнитьИтерациюТеста", ТЦОбъект.ПериодичностьВыполненияОпераций, Истина);
	
КонецФункции // ТЦВыполнить()

&НаКлиенте
Функция ТЦВыполнитьИтерациюТеста()
	
	Если (ТекущаяДата() - ТЦВремяНачалаТеста) < ТЦОбъект.ДлительностьТеста*60 Тогда
		ГСЧ = Новый ГенераторСлучайныхЧисел;
		ИндексДокумента = ГСЧ.СлучайноеЧисло(0, ТЦДокументыДляПроведения.ВГраница());
		
		ДокументСсылка = ТЦДокументыДляПроведения[ИндексДокумента];
		ТЦПровестиДокументНаСервере(ДокументСсылка);
		Сообщить("Проведен документ: " + ДокументСсылка);
		
		Возврат ТЦРезультатВыполненияПродолжить("ТЦВыполнитьИтерациюТеста", ТЦОбъект.ПериодичностьВыполненияОпераций, Истина);
	Иначе
		ТЦЗавершитьВыполнение(ПредопределенноеЗначение("Перечисление.ТЦРезультатВыполнения.Успешно"), Ложь);
		Возврат ТЦРезультатВыполненияУспешно();
	КонецЕсли;
	
КонецФункции

&НаСервереБезКонтекста
Процедура ТЦПровестиДокументНаСервере(ДокументСсылка)
	
	ВремяНачала = ОценкаПроизводительностиКлиентСервер.НачатьЗамерВремени();
	
	Попытка
		ДокОбъект = ДокументСсылка.ПолучитьОбъект();
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
	Исключение
		ТЦЗаписатьВЖурналНаСервере(ОписаниеОшибки(),,, Истина);
	КонецПопытки;
	
	ОценкаПроизводительностиКлиентСервер.ЗакончитьЗамерВремени("Проведение оприходования", ВремяНачала);
	
КонецПроцедуры

&НаКлиенте
// Единовременное удаление созданных при инициализации данных, после выполнения
// действия. Это удаление выполняется только при необходимости и не является
// обязательным.
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.
//   Успешно - если при инициализации ошибок не возникло
//   Предупреждение - если возникшие ошибки позволяют продолжить выполнение
//   Ошибка - если возникли ошибки, которые не позволяют продолжить выполнение
//
Функция ТЦУдалитьДанные() Экспорт
	
	#Если ТолстыйКлиентОбычноеПриложение Тогда
		// Код обычного приложения
	#Иначе
		// Код управляемого приложения
	#КонецЕсли
	
	Возврат ТЦРезультатВыполненияУспешно();
	
КонецФункции // ТЦУдалитьДанные()


///////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ РАЗРАБОТЧИКА СЦЕНАРИЯ

&НаКлиенте
// Записать значение показателя производительности
//
// Параметры:
//  ИмяПоказателя - Строка, произвольное имя показателя производительности
//  ЗначениеПоказателя - Число, значение показателя
//
Процедура ТЦЗаписатьПоказатель(ИмяПоказателя, ЗначениеПоказателя)
	
	МодульТЦКлиент = ТЦПолучитьОбщийМодульПоИмени("ТЦКлиент");
	Если МодульТЦКлиент <> Неопределено Тогда
		МодульТЦКлиент.ДобавитьРезультат(ТЦКонтекст(), ИмяПоказателя, ЗначениеПоказателя);
	КонецЕсли;
	
КонецПроцедуры // ТЦЗаписатьПоказатель()

&НаКлиенте
// Завершить выполнение действия
//
// Параметры:
//  Результат - ПеречислениеСсылка.ТЦРезультатВыполнения
//  ВозниклоИсключение - Булево, при выполнении обработчика ожидания
//                 возникла и обработана исключительная ситуация
//                 указывать этот параметр явно не следует
//
Процедура ТЦЗавершитьВыполнение(Результат, ВозниклоИсключение = Ложь, ТекстОшибкиОбработки = "")
	
	ОтключитьОбработчикОжидания("ТЦОбработчикВыполнения");
	ФормаВРМ = ТЦКонтекст().ФормаВРМ;
	
	Если ФормаВРМ <> Неопределено Тогда
		ФормаВРМ.РезультатВыполнения = Результат;
		ФормаВРМ.ВозниклоИсключение = ВозниклоИсключение;
		ФормаВРМ.ТекстОшибкиОбработки = ТекстОшибкиОбработки;
	КонецЕсли;
	
	ТЦКонтекстВыполнения.ТекущийРезультатВыполнения = Результат;
	ТЦКонтекстВыполнения.ВозниклоИсключение = ВозниклоИсключение;
	ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = ТекстОшибкиОбработки;
	
КонецПроцедуры // ТЦЗавершитьВыполнение()

&НаКлиенте
// Номер ВРМ, уникальный в рамках сценария
//
// Возвращаемое значение:
//  Число - номер текущего ВРМ
//
Функция ТЦНомерВРМ()
	
	Возврат ТЦКонтекст().ВРМ.Номер;
	
КонецФункции // ТЦНомерВРМ()

&НаКлиенте
// Ссылка на сценарий
//
// Возвращаемое значение:
//  СправочникСсылка.ТЦСценарии
//
Функция ТЦСценарий()
	
	Возврат ТЦКонтекст().ВРМ.Сценарий;
	
КонецФункции // ТЦСценарий()

&НаКлиенте
// Возвращает коэффициент интенсивности текущего сценария
//
// Возвращаемое значение:
//  Число
//
Функция ТЦКоэффициентИнтенсивности()
	
	Возврат ТЦКонтекст().КоэффициентИнтенсивности;
	
КонецФункции // ТЦСценарий()

&НаКлиенте
// Получить имя текущей роли
//
// Возвращаемое значение:
//  Строка - имя текущей роли
//
Функция ТЦИмяРоли()
	
	Возврат ТЦКонтекст().ВРМ.ИмяРоли;
	
КонецФункции // ТЦИмяРоли()

&НаКлиенте
// Получить имя текущей роли
//
// Возвращаемое значение:
//  Строка - имя текущей роли
//
Функция ТЦРоль()
	
	Возврат ТЦКонтекст().ВРМ.Роль;
	
КонецФункции // ТЦРоль()

&НаКлиенте
// Получить имя текущего пользователя
//
// Возвращаемое значение:
//  Строка - имя текущего пользователя
//
Функция ТЦИмяПользователя()
	
	Возврат ТЦКонтекст().ВРМ.Пользователь;
	
КонецФункции // ТЦИмяПользователя()

&НаКлиенте
// Получить имя текущего компьютера
//
// Возвращаемое значение:
//  Строка - имя текущего компьютера
//
Функция ТЦИмяКомпьютера()
	
	Возврат ТЦКонтекст().ВРМ.Компьютер;
	
КонецФункции // ТЦИмяКомпьютера()

&НаКлиенте
// Получить результат выполнения "Успешно"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Успешно
//
Функция ТЦРезультатВыполненияУспешно()
	
	Возврат ТЦКонтекст().РезультатВыполнения.Успешно;
	
КонецФункции // ТЦРезультатВыполненияУспешно()

&НаКлиенте
// Получить результат выполнения "Предупреждение"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Предупреждение
//
Функция ТЦРезультатВыполненияПредупреждение()
	
	Возврат ТЦКонтекст().РезультатВыполнения.Предупреждение;
	
КонецФункции // ТЦРезультатВыполненияПредупреждение()

&НаКлиенте
// Получить результат выполнения "Ошибка"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Ошибка
//
Функция ТЦРезультатВыполненияОшибка()
	
	Возврат ТЦКонтекст().РезультатВыполнения.Ошибка;
	
КонецФункции // ТЦРезультатВыполненияОшибка()

&НаКлиенте
// Получить результат выполнения "Продолжить" и подключить обработчик
// ТЦОбработчикВыполнения с указанным интервалом, который в свою очередь,
// Периодически выполняет функцию указанную в параметре Обработчик.
//
// Параметры:
//  Интервал - Число, через которое будет вызываться обработчик
//  Однократно - Булево, Признак однократного выполнения обработчика ожидания
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦРезультатВыполнения.Продолжить
//
Функция ТЦРезультатВыполненияПродолжить(Обработчик, Интервал, Однократно = Ложь)
	
	ТЦИмяОбработчика = Обработчик;
	ПодключитьОбработчикОжидания("ТЦОбработчикВыполнения", Интервал, Однократно);
	Возврат ТЦКонтекст().РезультатВыполнения.Продолжить;
	
КонецФункции // ТЦРезультатВыполненияОшибка()

&НаКлиенте
// Получить статус сообщения "Информация"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦСтатусСообщения.Информация
//
Функция ТЦСтатусСообщенияИнформация()
	
	Возврат ТЦКонтекст().СтатусСообщения.Информация;
	
КонецФункции // ТЦСтатусСообщенияИнформация()

&НаКлиенте
// Получить статус сообщения "Предупреждение"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦСтатусСообщения.Предупреждение
//
Функция ТЦСтатусСообщенияПредупреждение()
	
	Возврат ТЦКонтекст().СтатусСообщения.Предупреждение;
	
КонецФункции // ТЦСтатусСообщенияПредупреждение()

&НаКлиенте
// Получить статус сообщения "Ошибка"
//
// Возвращаемое значение:
//  ПеречислениеСсылка.ТЦСтатусСообщения.Ошибка
//
Функция ТЦСтатусСообщенияОшибка()
	
	Возврат ТЦКонтекст().СтатусСообщения.Ошибка;
	
КонецФункции // ТЦСтатусСообщенияОшибка()


///////////////////////////////////////////////////////////////////////////////
// СЛУЖЕБНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ТЕСТ-ЦЕНТРА

&НаКлиенте
// Обработчик команды "Выполнить".
// Выполняет инициализацию, действие и удаление созданных данных.
//
Процедура ВыполнитьДействие(Команда)
	
	ТЦВыполнитьТестирование(Ложь, Истина);
	
КонецПроцедуры // ВыполнитьДействие()

&НаКлиенте
// Обработчик выполнения действия в случае возврата из ТЦВыполнить результата
// ПеречислениеСсылка.ТЦРезультатВыполнения.ТЦПродолжить
//
Процедура ТЦОбработчикВыполнения()
	
	Попытка
		Результат = Вычислить(ТЦИмяОбработчика + "()");
	Исключение
		
		Если Не ТЦЭтоИзолированныйРежимРаботы Тогда
			
			МодульТЦОбщий = ТЦПолучитьОбщийМодульПоИмени("ТЦОбщий");
			Если МодульТЦОбщий <> Неопределено Тогда
				МодульТЦОбщий.ЗаписатьВЖурнал(ИнформацияОбОшибке(), "ВП");
				ТЦЗавершитьВыполнение(
					ТЦКонтекст().РезультатВыполнения.Неопределено,
					Истина,
					МодульТЦОбщий.ИнформациюОбОшибкеВСтроку(ИнформацияОбОшибке()));
			КонецЕсли;
			
		// дейстия в изолированном режиме работы	
		Иначе
			ТЦЗавершитьВыполнение(
					ТЦКонтекст().РезультатВыполнения.Неопределено,
					Истина,
					ТЦИнформациюОбОшибкеВСтроку(ИнформацияОбОшибке()));			
		КонецЕсли;
				
	КонецПопытки;
	
КонецПроцедуры // ТЦОбработчикВыполнения()

&НаКлиенте
// Получить контекст выполнения обработки
//
// Возвращаемое значение:
//  Структура - см. ТЦСервер.СоздатьКонтекстВыполненияОбработки()
//
Функция ТЦКонтекст() Экспорт
	
	Если ТЦКонтекстВыполнения = Неопределено Тогда
		
		Если НЕ ТЦЭтоИзолированныйРежимРаботы Тогда
			МодульТЦСервер = ТЦПолучитьОбщийМодульПоИмени("ТЦСервер");
			Если МодульТЦСервер <> Неопределено Тогда
				ТЦКонтекстВыполнения = МодульТЦСервер.СоздатьКонтекстВыполненияОбработки();
			КонецЕсли;
		Иначе
			ТЦКонтекстВыполнения = ТЦСоздатьКонтекстДляИзолированногоИсполнения();
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат ТЦКонтекстВыполнения;
	
КонецФункции // ТЦКонтекст()

&НаКлиенте
// Загрузить параметры обработки и формы
//
// Параметры:
//  ПараметрыЗагрузки - ХранилищеЗначения
//
Процедура ТЦЗагрузить(ПараметрыЗагрузки) Экспорт
	
	Если НЕ ТЦЭтоИзолированныйРежимРаботы Тогда
		ТЦЗагрузитьНаСервере(ПараметрыЗагрузки);
	КонецЕсли;
	
	ТЦКонтекст();
	
КонецПроцедуры // ТЦЗагрузить()

&НаСервере
// Загрузить параметры обработки.
// Во время загрузки устанавливаются ранее сохраненные значения реквизитов
//
// Параметры:
//  АрхивЗначений - ХранилищеЗначения, загружаемые данные
//
Процедура ТЦЗагрузитьНаСервере(АрхивЗначений)
	
	МодульТЦСервер = ТЦПолучитьОбщийМодульПоИмени("ТЦСервер");
	Если МодульТЦСервер <> Неопределено Тогда
		
		ТекущийОбъект = РеквизитФормыВЗначение("ТЦОбъект");
	
		МодульТЦСервер.ЗагрузитьРеквизитыОбработки(ТекущийОбъект, АрхивЗначений);
		ЗначениеВРеквизитФормы(ТекущийОбъект, "ТЦОбъект");
		
	КонецЕсли;
	
КонецПроцедуры // ТЦЗагрузитьНаСервере()

&НаКлиенте
// Сохранить значения реквизитов для возможности последующей загрузки
//
// Возвращаемое значение:
//  ХранилищеЗначения - запакованые значения реквизитов
//
Функция ТЦСохранить() Экспорт
	
	Если ТЦЭтоИзолированныйРежимРаботы Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат ТЦСохранитьНаСервере();
	
КонецФункции // ТЦСохранить()

&НаСервере
// Сохранить значения реквизитов для возможности последующей загрузки
//
// Возвращаемое значение:
//  ХранилищеЗначения - запакованые значения реквизитов
//
Функция ТЦСохранитьНаСервере()
	
	МодульТЦСервер = ТЦПолучитьОбщийМодульПоИмени("ТЦСервер");
	Если МодульТЦСервер <> Неопределено Тогда
		ТекущийОбъект = РеквизитФормыВЗначение("ТЦОбъект");
		Возврат МодульТЦСервер.СохранитьРеквизитыОбработки(ТекущийОбъект);
	КонецЕсли;
	
КонецФункции // ТЦСохранитьНаСервере()

&НаКлиенте
// Получить результат выполнения тестирования
//
// Возвращаемое значение:
//  Соответствие - показатели и их значения
//
Функция ТЦПолучитьРезультат() Экспорт
	
	Возврат ТЦКонтекст().Результаты;
	
КонецФункции // ТЦПолучитьРезультат()

&НаКлиенте
// Закрыть форму и вернуть значение Истина, для модального вызова
//
Процедура ТЦОК(Команда)
	
	Закрыть(Истина);
	
КонецПроцедуры // ТЦОК()

&НаСервере
// Обработчик события формы ПриСозданииНаСервере
Процедура ТЦПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Определим, присутствует ли подсистема ТестЦентр
	ТЦЭтоИзолированныйРежимРаботы = Ложь;
	ПодсистемаТестЦентр = Метаданные.Подсистемы.Найти("ТестЦентр");
	Если ПодсистемаТестЦентр = Неопределено Тогда
		ТЦЭтоИзолированныйРежимРаботы = Истина;
		
		СисИнфо = Новый СистемнаяИнформация;
		Если СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Windows_x86_64 Тогда
			ТЦОбъект.ТЦИмяФайлаЖурналаТестирования = "C:\Logs1C\TestResults.txt";
		ИначеЕсли СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.Linux_x86_64 Тогда
			ТЦОбъект.ТЦИмяФайлаЖурналаТестирования = "/var/log/1C/TestResults.txt";
		ИначеЕсли СисИнфо.ТипПлатформы = ТипПлатформы.MacOS_x86 ИЛИ СисИнфо.ТипПлатформы = ТипПлатформы.MacOS_x86_64 Тогда
			ТЦОбъект.ТЦИмяФайлаЖурналаТестирования = "/var/log/1C/TestResults.txt";
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Обработчик события формы ПриОткрытии
Процедура ТЦПриОткрытии(Отказ)
	
	Если Найти(Нрег(ПараметрЗапуска), Нрег("TCLaunchTest")) <> 0 И ТЦЭтоИзолированныйРежимРаботы Тогда
		
		Элементы.ТЦОбщийРезультат.Видимость	= Ложь;
		Элементы.ТЦРезультаты.Видимость		= Ложь;
		ТЦВыполнитьТестирование();
		
	ИначеЕсли НЕ ТЦЭтоИзолированныйРежимРаботы Тогда
		
		Элементы.ТЦОбщийРезультат.Видимость	= Ложь;
		Элементы.ТЦРезультаты.Видимость		= Ложь;
		
	Иначе
		
		Элементы.ТЦОбщийРезультат.Видимость	= Истина;
		Элементы.ТЦРезультаты.Видимость		= Истина;
		
	КонецЕсли;
	
КонецПроцедуры

///////////////////////////////////////////////////////////////////////////////
// Служебные процедуры и функции для работы в конфигурации
// без подсистемы ТестЦентр (в изолированном режиме)

&НаКлиенте
// Выполняет инициализацию, действие и удаление созданных данных в изолированном режиме работы.
Процедура ТЦВыполнитьТестирование(ЗавершатьРаботу = Истина, ПоказыватьОшибкиИСообщения = Ложь)
	
	ТЦКонтекст().ПоказыватьОшибкиИСообщения = ПоказыватьОшибкиИСообщения;
	ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения = ЗавершатьРаботу;
	
	Если ТЦЭтоИзолированныйРежимРаботы Тогда
		Элементы.ТЦОбщийРезультат.Видимость	= ПоказыватьОшибкиИСообщения;
		Элементы.ТЦРезультаты.Видимость		= ПоказыватьОшибкиИСообщения;
		ТЦЗаписатьСистемнуюИнформациюВФайлНаСервере();
	КонецЕсли;
	
	ТЦКонтекстВыполнения.МассивДействий = Новый Массив;
	ТЦКонтекстВыполнения.МассивДействий.Добавить("ТЦИнициализировать()");
	ТЦКонтекстВыполнения.МассивДействий.Добавить("ТЦВыполнить()");
	ТЦКонтекстВыполнения.МассивДействий.Добавить("ТЦУдалитьДанные()");
	
	Для Каждого ТекущееДействие Из ТЦКонтекстВыполнения.МассивДействий Цикл
		
		РезультатВыполнения = ТЦВыполнитьДействиеТеста(ТекущееДействие);

		Если РезультатВыполнения = ТЦКонтекстВыполнения.РезультатВыполнения.Продолжить
			ИЛИ РезультатВыполнения = ТЦРезультатВыполненияОшибка()
			ИЛИ ТЦКонтекстВыполнения.ВозниклоИсключение Тогда

			Возврат;
		КонецЕсли;
		
	КонецЦикла;
	
	Если ТЦЭтоИзолированныйРежимРаботы Тогда
		Если ТЦКоличествоОшибок = 0 Тогда
			ТЦОбщийРезультат = "Тесты пройдены без ошибок";
		Иначе 
			ТЦОбщийРезультат = "Количество ошибок: " + ТЦКоличествоОшибок;
		КонецЕсли;			
	КонецЕсли;
	
	Если ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения Тогда
		ЗавершитьРаботуСистемы(Ложь, Ложь);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
// Обработчик заверщения выполнения
Процедура ТЦОжиданиеЗавершенияВыполнения()
	
	ЗавершитьВыполнение = Ложь;
	
	Если ТЦЭтоИзолированныйРежимРаботы Тогда
		ТЦКонтекстВыполнения.ОкончаниеТекущегоЗамера = ТЦПолучитьВремяДляЗамера();
		Длительность = ТЦКонтекстВыполнения.ОкончаниеТекущегоЗамера-ТЦКонтекстВыполнения.НачалоТекущегоЗамера;
		Если ТЦЕстьВремяВМиллисекундах() Тогда
			Длительность = Длительность / 1000;
		КонецЕсли;
	КонецЕсли;
	
	ТекущийРезультатВыполнения = ТЦКонтекст().ТекущийРезультатВыполнения;
	ТекущаяОперация = ТЦКонтекстВыполнения.ТекущаяОперация;
	
	// Возникло исключение
	// или выполнение действия вернуло ошибку
	Если ТЦКонтекстВыполнения.ВозниклоИсключение ИЛИ ТекущийРезультатВыполнения = ТЦРезультатВыполненияОшибка() Тогда
		
		ЗавершитьВыполнение = Истина;
		Пояснение = ?(ТекущийРезультатВыполнения = ТЦРезультатВыполненияОшибка(), "Функция вернула ошибку. ", "");
		ТекстОшибкиПользователю = Пояснение;
		
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			ТекстОшибкиПользователю = Пояснение + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки + " Длительность="
				+ Формат(Длительность, "ЧДЦ=2; ЧРГ=.; ЧН=0") + " с";

			ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Действие=" + ТекущаяОперация + " Длительность="
				+ Формат(Длительность, "ЧДЦ=2; ЧРГ=.; ЧН=0") + " с"
				+ " ОшибкаПриВыполнении=" + Символы.ПС + Пояснение + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
				
		Иначе
			ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Возникла ошибка при выполнении " + ТекущаяОперация +
														Символы.ПС + Пояснение + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
		КонецЕсли;
			
		Если ТЦКонтекстВыполнения.ПоказыватьОшибкиИСообщения И НЕ ТЦЭтоИзолированныйРежимРаботы Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
			Сообщение.Сообщить();
		КонецЕсли;
	
		ТЦЗаписатьВЖурнал(ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки, "Тест-центр", ТЦСтатусСообщенияОшибка());
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			ТЦЗаписьРезультатовВФайлНаСервере(ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки);
			ТЦКоличествоОшибок = ТЦКоличествоОшибок + 1;
			ТЦПоказазатьОшибку(ТекущаяОперация, ТекстОшибкиПользователю);
		КонецЕсли;
	
	// Завершилась часть теста
	ИначеЕсли ТекущийРезультатВыполнения <> Неопределено
		И ТекущийРезультатВыполнения <> ТЦКонтекстВыполнения.РезультатВыполнения.Неопределено
		И ТекущийРезультатВыполнения <> ТЦКонтекстВыполнения.РезультатВыполнения.Продолжить Тогда

		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			ТЦЗаписьРезультатовВФайлНаСервере("Действие=" + ТекущаяОперация + " Длительность="
				+ Формат(Длительность, "ЧДЦ=2; ЧРГ=.; ЧН=0") + " с");
			ТЦПоказазатьЗамер(ТекущаяОперация, Длительность);
		КонецЕсли;
			
		Индекс = ТЦКонтекстВыполнения.МассивДействий.Найти(ТекущаяОперация);
		// Произошла ошибка
		Если Индекс = Неопределено Тогда
			ЗавершитьВыполнение = Истина;
			
			Если ТЦЭтоИзолированныйРежимРаботы Тогда
				
				ТекстОшибки = "Ошибка продолжения теста. Операция """ + ТЦКонтекстВыполнения.ТекущаяОперация + """ не найдена в ТЦМассивДействий";
				ТЦЗаписьРезультатовВФайлНаСервере(ТекстОшибки);
				ТЦКоличествоОшибок = ТЦКоличествоОшибок + 1;
				ТЦПоказазатьОшибку(ТекущаяОперация, ТекстОшибки);
				
			КонецЕсли;
			
		// Все операции выполнены	
		ИначеЕсли Индекс = ТЦКонтекстВыполнения.МассивДействий.ВГраница() Тогда
			ЗавершитьВыполнение = Истина;
			
		// Продолжаем выполнение операций
		Иначе
			ОтключитьОбработчикОжидания("ТЦОжиданиеЗавершенияВыполнения");
			
			МассивДействий = ТЦКонтекстВыполнения.МассивДействий;
			Для Сч = Индекс + 1 По МассивДействий.ВГраница() Цикл
				
				ТекущаяОперация = МассивДействий[Сч];
				РезультатВыполнения = ТЦВыполнитьДействиеТеста(ТекущаяОперация);
				
				Если РезультатВыполнения = ТЦКонтекстВыполнения.РезультатВыполнения.Продолжить
					ИЛИ РезультатВыполнения = ТЦРезультатВыполненияОшибка()
					ИЛИ ТЦКонтекстВыполнения.ВозниклоИсключение Тогда
					Возврат;
				КонецЕсли;
			КонецЦикла;
			
			ЗавершитьВыполнение = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗавершитьВыполнение Тогда
		ОтключитьОбработчикОжидания("ТЦОжиданиеЗавершенияВыполнения");
		
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			Если ТЦКоличествоОшибок = 0 Тогда
				ТЦОбщийРезультат = "Тесты пройдены без ошибок";
			Иначе 
				ТЦОбщийРезультат = "Количество ошибок: " + ТЦКоличествоОшибок;
			КонецЕсли;			
		КонецЕсли;
		
		Если ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения Тогда
			ЗавершитьРаботуСистемы(Ложь, Ложь);
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
// Служебная функция, предназначенная для выполнения указанной процедуры и записи результатов в текстовый файл.
//   Параметры:
//      ИмяПроцедуры - имя тестовой процедуры, которую нужно выполнить.
//						
Функция ТЦВыполнитьДействиеТеста(Знач ИмяФункции)
	
	ТЦКонтекст().ТекущийРезультатВыполнения = Неопределено;
	ТЦКонтекстВыполнения.ВозниклоИсключение = Ложь;
	ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "";
	ТЦКонтекстВыполнения.ТекущаяОперация = ИмяФункции;
	ТекстОшибкиПользователю = "";
	
	Если ТЦЭтоИзолированныйРежимРаботы Тогда
		ТЦКонтекстВыполнения.НачалоТекущегоЗамера = ТЦПолучитьВремяДляЗамера();
	КонецЕсли;
	
	Попытка
		РезультатВыполнения = Вычислить(ИмяФункции);
		
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			ТЦКонтекстВыполнения.ОкончаниеТекущегоЗамера = ТЦПолучитьВремяДляЗамера();
			Длительность = ТЦКонтекстВыполнения.ОкончаниеТекущегоЗамера-ТЦКонтекстВыполнения.НачалоТекущегоЗамера;
			Если ТЦЕстьВремяВМиллисекундах() Тогда
				Длительность = Длительность / 1000;
			КонецЕсли;
		КонецЕсли;

		Если РезультатВыполнения = ТЦРезультатВыполненияОшибка() Тогда
			ТЦВозниклоИсключение = Ложь;
			
			Если ТЦЭтоИзолированныйРежимРаботы Тогда
				
				ТекстОшибкиПользователю = "Функция вернула ошибку. " + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки + " Длительность="
					+ Формат(Длительность,"ЧДЦ=2; ЧРГ=.; ЧН=0") + " с";
				
				ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Действие=" + ИмяФункции + " Длительность="
					+ Формат(Длительность,"ЧДЦ=2; ЧРГ=.; ЧН=0") + " с"
					+ " ОшибкаПриВыполнении=" + Символы.ПС + "Функция вернула ошибку. " + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
			Иначе
				ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Возникла ошибка при выполнении " + ИмяФункции + Символы.ПС +
															"Функция вернула ошибку. " + ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;				
			КонецЕсли;
				
				
		КонецЕсли;
		
	Исключение
		
		РезультатВыполнения = ТЦКонтекст().РезультатВыполнения.Неопределено;
		ТЦКонтекстВыполнения.ВозниклоИсключение = Истина;		
		
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			ТЦКонтекстВыполнения.ОкончаниеТекущегоЗамера = ТЦПолучитьВремяДляЗамера();
			Длительность = ТЦКонтекстВыполнения.ОкончаниеТекущегоЗамера-ТЦКонтекстВыполнения.НачалоТекущегоЗамера;
			Если ТЦЕстьВремяВМиллисекундах() Тогда
				Длительность = Длительность / 1000;
			КонецЕсли;
			
			ТекстОшибкиПользователю = ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()) + " Длительность="
				+ Формат(Длительность, "ЧДЦ=2; ЧРГ=.; ЧН=0") + " с";
			
			ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Действие=" + ИмяФункции + " Длительность="
				+ Формат(Длительность, "ЧДЦ=2; ЧРГ=.; ЧН=0") + " с"
				+ " ОшибкаПриВыполнении=" + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		Иначе
			ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки = "Возникла ошибка при выполнении " + ИмяФункции + Символы.ПС + ПодробноеПредставлениеОшибки(ИнформацияОбОшибке());
		КонецЕсли;
			
	КонецПопытки;
				
	Если ТЦКонтекстВыполнения.ВозниклоИсключение ИЛИ РезультатВыполнения = ТЦРезультатВыполненияОшибка() Тогда
		
		Если ТЦКонтекстВыполнения.ПоказыватьОшибкиИСообщения И НЕ ТЦЭтоИзолированныйРежимРаботы Тогда
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки;
			Сообщение.Сообщить();
		КонецЕсли;
		
		ТЦЗаписатьВЖурнал(ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки, "Тест-центр", ТЦСтатусСообщенияОшибка());
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			ТЦЗаписьРезультатовВФайлНаСервере(ТЦКонтекстВыполнения.ТекстИсключенияИлиОшибки);
			ТЦКоличествоОшибок = ТЦКоличествоОшибок + 1;
			ТЦПоказазатьОшибку(ТЦКонтекстВыполнения.ТекущаяОперация, ТекстОшибкиПользователю);
		КонецЕсли;
		
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			Если ТЦКоличествоОшибок = 0 Тогда
				ТЦОбщийРезультат = "Тесты пройдены без ошибок";
			Иначе 
				ТЦОбщийРезультат = "Количество ошибок: " + ТЦКоличествоОшибок;
			КонецЕсли;			
		КонецЕсли;
		
		Если ТЦКонтекстВыполнения.ЗавершатьРаботуПослеВыполнения Тогда
			ЗавершитьРаботуСистемы(Ложь, Ложь);
		КонецЕсли;
		
	ИначеЕсли РезультатВыполнения = ТЦКонтекст().РезультатВыполнения.Продолжить Тогда
		ПодключитьОбработчикОжидания("ТЦОжиданиеЗавершенияВыполнения", 1);
	Иначе
		
		Если ТЦЭтоИзолированныйРежимРаботы Тогда
			ТЦЗаписьРезультатовВФайлНаСервере("Действие=" + ИмяФункции + " Длительность="
				+ Формат(Длительность, "ЧДЦ=2; ЧРГ=.; ЧН=0") + " с");
			ТЦПоказазатьЗамер(ИмяФункции, Длительность);
		КонецЕсли;
			
	КонецЕсли;
	
	ТЦКонтекстВыполнения.ТекущийРезультатВыполнения = РезультатВыполнения;
	Возврат РезультатВыполнения;
		
КонецФункции	// ВыполнитьДействиеТеста

&НаКлиенте
// Возвращает текущую универсальную дату в миллисекундах, либо текущее время в за
// в зависимости от версии платформы
Функция ТЦПолучитьВремяДляЗамера()
	
	Попытка
		Время = Вычислить("ТекущаяУниверсальнаяДатаВМиллисекундах()");
	Исключение
		Время = ТекущаяДата();
	КонецПопытки;
	
	Возврат Время;
	
КонецФункции

&НаКлиенте
// Истина если, если система позволяет получать универсальную дату в миллисекундах
Функция ТЦЕстьВремяВМиллисекундах()
	
	Результат = Истина;	
	Попытка
		Время = Вычислить("ТекущаяУниверсальнаяДатаВМиллисекундах()");
	Исключение
		Результат = Ложь;
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
// Создает контекст для изолированного исполнения
Функция ТЦСоздатьКонтекстДляИзолированногоИсполнения()
	
	Статус = Новый Структура;
	Статус.Вставить("Информация", 1);
	Статус.Вставить("Предупреждение", 2);
	Статус.Вставить("Ошибка", 3);
	
	Результат = Новый Структура;
	Результат.Вставить("Успешно", 1);
	Результат.Вставить("Предупреждение", 2);
	Результат.Вставить("Ошибка", 3);
	Результат.Вставить("Продолжить", 4);
	Результат.Вставить("Неопределено", 5);
	
	Контекст = Новый Структура;
	
	Контекст.Вставить("ВозниклоИсключение", Ложь);
	Контекст.Вставить("ТекстИсключенияИлиОшибки");
	Контекст.Вставить("ТекущаяОперация");
	Контекст.Вставить("МассивДействий");
	Контекст.Вставить("КоэффициентИнтенсивности", 1);
	Контекст.Вставить("НачалоТекущегоЗамера");
	Контекст.Вставить("ОкончаниеТекущегоЗамера");
	Контекст.Вставить("ЗавершатьРаботуПослеВыполнения", Ложь);
	Контекст.Вставить("ПоказыватьОшибкиИСообщения", Ложь);
	
	Контекст.Вставить("СтатусСообщения", Статус);
	Контекст.Вставить("ТекущийРезультатВыполнения");
	Контекст.Вставить("РезультатВыполнения", Результат);
	Контекст.Вставить("Результаты", Новый Соответствие);
	Контекст.Вставить("ВРМ", Новый Структура("Роль, ИмяРоли, Компьютер, Пользователь, Номер, Сценарий"));
	Контекст.Вставить("ФормаВРМ");
	
	Возврат Контекст;	
	
КонецФункции

&НаСервере
// Записывает информацию о системе в указанный файл на сервере
Процедура ТЦЗаписатьСистемнуюИнформациюВФайлНаСервере(Знач ИмяФайла = "")
	
	СистемнаяИнформация = Новый СистемнаяИнформация();
	
	Если СокрЛП(ИмяФайла) = "" Тогда
		ИмяФайла = СокрЛП(ТЦОбъект.ТЦИмяФайлаЖурналаТестирования);
	КонецЕсли;
	
	Текст = Новый ЗаписьТекста;
	ВыбранныйФайл = Новый Файл(ИмяФайла);
	Если ВыбранныйФайл.Существует() Тогда
		Текст.Открыть(ВыбранныйФайл.ПолноеИмя, КодировкаТекста.UTF8,,Истина);	
	Иначе
		СоздатьКаталог(ВыбранныйФайл.Путь);
		Текст.Открыть(ИмяФайла, КодировкаТекста.UTF8,,Истина);
	КонецЕсли;
	
	СтрокаДляЗаписи = Символы.ПС;
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "Начало теста", Формат(ТекущаяДата(),"ДЛФ=DT"));
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ВерсияПлатформы", СистемнаяИнформация.ВерсияПриложения);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ИмяКонфигурации", Метаданные.Имя);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "СинонимИмениКонфигурации", Метаданные.Синоним);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ВерсияКонфигурации", Метаданные.Версия);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ИнтерфейсКонфигурации", Метаданные.Интерфейсы);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ИнформацияПрограммыПросмотра", СистемнаяИнформация.ИнформацияПрограммыПросмотра);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "Процессор", СистемнаяИнформация.Процессор);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ОперативнаяПамять", СистемнаяИнформация.ОперативнаяПамять);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ТипОС", Строка(СистемнаяИнформация.ТипПлатформы));
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ВерсияОС", СистемнаяИнформация.ВерсияОС);
	ТЦДополнитьСтрокуИнфо(СтрокаДляЗаписи, "ИмяМодуля", ТЦПолучитьИмяМодуля());

	Текст.ЗаписатьСтроку(СтрокаДляЗаписи);
	Текст.Закрыть();	
	
КонецПроцедуры

// Служебная процедура, показывает сообщение об ошибке в изолированном режиме
//
// Параметры:
//  ИмяОперации			- Строка
//  СообщениеОбОшибке	- Строка
//
&НаКлиенте
Процедура ТЦПоказазатьОшибку(Знач ИмяОперации, Знач СообщениеОбОшибке)
	
	Если ТЦКонтекст().ПоказыватьОшибкиИСообщения Тогда
		СтрокаРезультата		= ТЦРезультаты.Добавить();
		СтрокаРезультата.Тест	= ИмяОперации;
		СтрокаРезультата.Результат = Ложь;
		СтрокаРезультата.Сообщение = СообщениеОбОшибке;
	КонецЕсли;
	
КонецПроцедуры

// Служебная процедура, показывает замер в изолированном режиме
//
// Параметры:
//  ИмяОперации	 - Строка
//  ДлительностьВСекундах - Число
//
&НаКлиенте
Процедура ТЦПоказазатьЗамер(Знач ИмяОперации, Знач ДлительностьВСекундах)
	
	Если ТЦКонтекст().ПоказыватьОшибкиИСообщения Тогда
		СтрокаРезультата		= ТЦРезультаты.Добавить();
		СтрокаРезультата.Тест	= ИмяОперации;
		СтрокаРезультата.Результат = Истина;
		СтрокаРезультата.Сообщение = Формат(ДлительностьВСекундах, "ЧДЦ=2; ЧРГ=.; ЧН=0") + " с";
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
//Служебная процедура, предназначенная для записи результатов в текстовый файл
// Параметры:
//  Результат - Строка с результатом, которая будет записана в файл
// 
//  ИмяФайла - каталог и файл, в который будут сохраняться результаты
//	
// Т.к процедура работает НаСервере, то ИмяФайла инициализируется на сервере в процедуре ПриСозданииНаСервере
// В случае необходимости переноса процедуры на клиента требуется перенести инициализацию из ПриСозданииНаСервере
// в начало процедуры ПриОткрытии
Процедура ТЦЗаписьРезультатовВФайлНаСервере(Знач Результат, Знач ИмяФайла="")
	
	Если СокрЛП(ИмяФайла) = "" Тогда
		ИмяФайла = СокрЛП(ТЦОбъект.ТЦИмяФайлаЖурналаТестирования);
	КонецЕсли;
	
	СтрокаДляЗаписи = Формат(ТекущаяДата(),"ДЛФ=DT") + " " + Результат;
	
	Текст = Новый ЗаписьТекста;
	ВыбранныйФайл = Новый Файл(ИмяФайла);
	Если ВыбранныйФайл.Существует() Тогда
		Текст.Открыть(ВыбранныйФайл.ПолноеИмя, КодировкаТекста.UTF8,,Истина);	
	Иначе
		СоздатьКаталог(ВыбранныйФайл.Путь);
		Текст.Открыть(ИмяФайла, КодировкаТекста.UTF8,,Истина);
	КонецЕсли;
	
	Текст.ЗаписатьСтроку(СтрокаДляЗаписи);
	Текст.Закрыть();

КонецПроцедуры	// ЗаписьРезультатовВФайл

&НаКлиентеНаСервереБезКонтекста
// Возвращает текущего модуля 
Функция ТЦПолучитьИмяМодуля()
	
	Попытка
		ВызватьИсключение Истина;
	Исключение
		Инфо = ИнформацияОбОшибке();
		Возврат Инфо.ИмяМодуля;
	КонецПопытки;
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
//Служебная процедура, предназначенная для составления строки с параметрами 
//   Параметры:
//      ДополняемаяСтрока - строка, в которую дополняются параметры
//      НаименованиеПараметра - наименование параметра
//      ЗначениеПараметра - значение параметра
//
Процедура ТЦДополнитьСтрокуИнфо(ДополняемаяСтрока, НаименованиеПараметра, ЗначениеПараметра)

	Если НЕ ЗначениеЗаполнено(ЗначениеПараметра) Тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ДополняемаяСтрока) Тогда
		ДополняемаяСтрока = ДополняемаяСтрока + Символы.ПС;
	КонецЕсли;
	
	ДополняемаяСтрока = ДополняемаяСтрока + НаименованиеПараметра + "=" + ЗначениеПараметра; 

КонецПроцедуры	// ДополнитьСтрокуИнфо()

&НаКлиентеНаСервереБезКонтекста
// Преобразовать объект типа ИнформацияОбОшибке в строку
//
// Параметры:
//  Ошибка - ИнформацияОбОшибке
//
// Возвращаемое значение:
//  Строка - Строковое предстваление ошибки
//
Функция ТЦИнформациюОбОшибкеВСтроку(Ошибка, НомерПричины = 0) 
	
	ТекстОшибки = "";
	
	Если Не ПустаяСтрока(Ошибка.ИмяМодуля) Тогда
		ТекстОшибки = ТекстОшибки + "{"
			+ Ошибка.ИмяМодуля + "("
			+ Ошибка.НомерСтроки + ")}: ";
	КонецЕсли;
	
	ТекстОшибки = ТекстОшибки
		+ Ошибка.Описание + "
		|" + Ошибка.ИсходнаяСтрока;
	
	Если Ошибка.Причина <> Неопределено Тогда
		ТекстОшибки = ТекстОшибки + "
			|
			|ПРИЧИНА №" + Формат(НомерПричины + 1, "ЧГ=0") + "
			|" + ТЦИнформациюОбОшибкеВСтроку(Ошибка.Причина, НомерПричины + 1);
	КонецЕсли;
	
	Возврат ТекстОшибки;
	
КонецФункции // ИнформациюОбОшибкеВСтроку()

&НаКлиентеНаСервереБезКонтекста 
// Записать Сообщение в журнал регистрации
Процедура ТЦЗаписатьВЖурнал(Сообщение, Событие = Неопределено, Важность = Неопределено)
	
	ЭтоОшибка = ТипЗнч(Сообщение) = Тип("ИнформацияОбОшибке")
	        Или ТипЗнч(Сообщение) = Тип("Структура");
	
	Если ЭтоОшибка Тогда
		ТекстОшибки = ТЦИнформациюОбОшибкеВСтроку(Сообщение);
	Иначе
		ТекстОшибки = Сообщение;
	КонецЕсли;
	
	ТЦЗаписатьВЖурналНаСервере(
		ТекстОшибки,
		Событие,
		Важность,
		ЭтоОшибка);	
	
КонецПроцедуры

&НаСервереБезКонтекста
// Записать Сообщение в журнал регистрации
Процедура ТЦЗаписатьВЖурналНаСервере(ТекстОшибки, Событие, Важность, ЭтоОшибка)
	
	Имя = ?(Событие = Неопределено, "Тест-центр", Событие);
	
	Если Важность = Неопределено Тогда
		Если ЭтоОшибка Тогда
			Уровень = УровеньЖурналаРегистрации.Ошибка;
		Иначе
			Уровень = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
	Иначе
		Если Важность = 3 Тогда
			Уровень = УровеньЖурналаРегистрации.Ошибка;
		ИначеЕсли Важность = 2 Тогда
			Уровень = УровеньЖурналаРегистрации.Предупреждение;
		ИначеЕсли Важность = 1 Тогда
			Уровень = УровеньЖурналаРегистрации.Информация;
		КонецЕсли;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(Имя, Уровень,, "Тест-центр", ТекстОшибки);
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста 
// Возвращает ссылку на модуль или Неопределено
Функция ТЦПолучитьОбщийМодульПоИмени(ИмяМодуля)
	
	Попытка
		НужныйМодуль = Вычислить(ИмяМодуля);
		
		#Если Не ВебКлиент Тогда
		Если ТипЗнч(НужныйМодуль) <> Тип("ОбщийМодуль") Тогда
			НужныйМодуль = Неопределено;
		КонецЕсли;
		#КонецЕсли
	
	Исключение
		НужныйМодуль = Неопределено;
	КонецПопытки;

	Возврат НужныйМодуль;
	
КонецФункции

