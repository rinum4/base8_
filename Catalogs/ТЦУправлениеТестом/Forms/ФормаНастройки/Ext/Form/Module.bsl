﻿
&НаКлиенте
Процедура Запустить(Команда)
	
	//Запуск нового клиентского приложения
	#Если ВебКлиент Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Данная возможность не доступна в веб-клиенте!";
		Сообщение.Сообщить();
	#Иначе
		ЗапуститьСистему();
	#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьСценарий(Команда)
	
	ВключитьРежимОтметкиНезаполненногоДляСценария(Истина);
	ВключитьРежимОтметкиНезаполненногоДляАгента(Ложь);
	СсылкаСценарий = ЭтаФорма.Сценарий;
	СсылкаУпрПриложение = ЭтаФорма.УправлениеТестом;
	ДатаНачала = ЭтаФорма.ДатаНачалаСценарий;
	ДатаОкончания = ЭтаФорма.ДатаОкончанияСценарий;
	СценарийДобавлен = ДобавитьСценарийНаСервере(СсылкаСценарий, СсылкаУпрПриложение, ДатаНачала, ДатаОкончания);
	Если Не СценарийДобавлен Тогда
		ПоказатьПредупреждение(, "В системе нет ни одного запущенного приложения с ролью АгентТЦ.
		                |Для создания приложения с управляющей ролью запустите как минимум одного клиента с ролью АгентТЦ");
	Иначе
		ОчисткаПараметровФормы();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Функция ДобавитьСценарийНаСервере(Сценарий, УпрПриложение, ДатаНачала, ДатаОкончания)
	
	ЕстьЗапущенныеАгенты = ТЦСервер.ПроверитьНаличиеЗапущенныхАгентов();
	Если ЕстьЗапущенныеАгенты Тогда
		Объект = УпрПриложение.ПолучитьОбъект();
		Объект.Сценарий = Сценарий;
		Объект.ТипПриложения = Перечисления.ТЦТипКлиентскогоПриложения.УправлениеТестом;
		Объект.ДатаНачала = ДатаНачала;
		Объект.ДатаОкончания = ДатаОкончания;
		Объект.ОбменДанными.Загрузка = Истина;
		Объект.Записать();
		
		Возврат Истина;
	Иначе
		Возврат Ложь;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВключитьРежимОтметкиНезаполненногоДляСценария(Флаг)
	
	ЭтаФорма.Элементы.СценарийНастройка.АвтоОтметкаНезаполненного = Флаг;
	ЭтаФорма.Элементы.УправлениеТестом1.АвтоОтметкаНезаполненного = Флаг;
	ЭтаФорма.Элементы.ДатаНачлаСценарий.АвтоОтметкаНезаполненного = Флаг;
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьАгента(Команда)
	
	ВключитьРежимОтметкиНезаполненногоДляАгента(Истина);
	ВключитьРежимОтметкиНезаполненногоДляСценария(Ложь);
	СсылкаАгент = ЭтаФорма.Агент;
	ДатаОкончания = ЭтаФорма.ДатаОкончанияАгент;
	ДобавитьАгентаНаСервере(СсылкаАгент, ДатаОкончания);
	ОчисткаПараметровФормы();
	
КонецПроцедуры

&НаСервере
Процедура ДобавитьАгентаНаСервере(Агент, ДатаОкончания)
	
	Объект = Агент.ПолучитьОбъект();
	Объект.ТипПриложения = Перечисления.ТЦТипКлиентскогоПриложения.АгентТЦ;
	Объект.ДатаОкончания = ДатаОкончания;
	Объект.ОбменДанными.Загрузка = Истина;
	Объект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура ВключитьРежимОтметкиНезаполненногоДляАгента(Флаг)
	
	ЭтаФорма.Элементы.Агент.АвтоОтметкаНезаполненного = Флаг;
	
КонецПроцедуры

&НаСервере
Функция ВернутьТипКлиентскогоПриложения(Ссылка)
	
	Если ЗначениеЗаполнено(Ссылка) И ТипЗнч(Ссылка) = Тип("СправочникСсылка.ТЦУправлениеТестом") Тогда
		Возврат Ссылка.ТипПриложения;
	КонецЕсли;
	Возврат NULL;
	
КонецФункции

&НаКлиенте
Процедура ОстановитьАгента(Команда)
	
	СсылкаАгент = ЭтаФорма.Агент;
	ОстановитьАгентаНаСервере(СсылкаАгент);
	
КонецПроцедуры

&НаСервере
Процедура ОстановитьАгентаНаСервере(СсылкаАгент)
	
	Объект = СсылкаАгент.ПолучитьОбъект();
	Объект.ДатаОкончания = ТекущаяДата();
	Объект.ОбменДанными.Загрузка = Истина;
	Объект.Записать();
	
КонецПроцедуры

&НаКлиенте
Процедура АгентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.СписокВыбора.Очистить();
	ДанныеВыбора = ПолучитьСписокНаСервере(ПредопределенноеЗначение("Перечисление.ТЦТипКлиентскогоПриложения.АгентТЦ"));
	
КонецПроцедуры

&НаСервере
Функция ПолучитьСписокНаСервере(ТипПриложения1)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТипПриложения1", ТипПриложения1);
	Запрос.УстановитьПараметр("ТипПриложения2", Перечисления.ТЦТипКлиентскогоПриложения.ПустаяСсылка());
	Запрос.Текст = "ВЫБРАТЬ
    |	ТЦУправлениеТестом.Ссылка как Ссылка
    |ИЗ
    |	Справочник.ТЦУправлениеТестом КАК ТЦУправлениеТестом
    |ГДЕ
    |	ТЦУправлениеТестом.ТипПриложения = &ТипПриложения1
    |	ИЛИ ТЦУправлениеТестом.ТипПриложения = &ТипПриложения2";
	Выборка = Запрос.Выполнить().Выбрать();
	СписокПодключений = Новый СписокЗначений;
	Пока Выборка.Следующий() Цикл
		СписокПодключений.Добавить(Выборка.Ссылка);   
	КонецЦикла;
	Возврат СписокПодключений;
	
КонецФункции

&НаКлиенте
Процедура АгентПриИзменении(Элемент)
	
	СсылкаАгент = ЭтаФорма.Агент;
	ТипПриложения = ПолучитьТипПриложенияНаСервере(СсылкаАгент);
Если ТипПриложения = ПредопределенноеЗначение("Перечисление.ТЦТипКлиентскогоПриложения.АгентТЦ") Тогда
	ЭтаФорма.Элементы.ДобавитьАгента.Доступность = Ложь;
	ЭтаФорма.Элементы.ОстановитьАгента.Доступность = Истина;
Иначе
	ЭтаФорма.Элементы.ДобавитьАгента.Доступность = Истина;
	ЭтаФорма.Элементы.ОстановитьАгента.Доступность = Ложь;
КонецЕсли;

КонецПроцедуры

&НаСервере
Функция ПолучитьТипПриложенияНаСервере(СсылкаАгент)
	
	Возврат СсылкаАгент.ТипПриложения;
	
КонецФункции

&НаКлиенте
Процедура УправлениеТестом1НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элемент.СписокВыбора.Очистить();
	ДанныеВыбора = ПолучитьСписокНаСервере(ПредопределенноеЗначение("Перечисление.ТЦТипКлиентскогоПриложения.УправлениеТестом"));
	
КонецПроцедуры

&НаКлиенте
Процедура ОчисткаПараметровФормы()
	
	ВключитьРежимОтметкиНезаполненногоДляАгента(Ложь);
	Агент = Неопределено;
	ДатаОкончанияАгент = Неопределено;
	ВключитьРежимОтметкиНезаполненногоДлясценария(Ложь);
	Сценарий = Неопределено;
	УправлениеТестом = Неопределено;
	ЭтаФорма.ДатаНачалаСценарий = Неопределено;
	ЭтаФорма.ДатаОкончанияСценарий = Неопределено;
	
КонецПроцедуры;

