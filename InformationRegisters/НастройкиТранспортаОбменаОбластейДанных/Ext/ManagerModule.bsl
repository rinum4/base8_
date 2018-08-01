﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда


// Процедура обновляет запись в регистре по переданным значениям структуры
//
Процедура ОбновитьЗапись(СтруктураЗаписи) Экспорт
	
	ОбменДаннымиСервер.ОбновитьЗаписьВРегистрСведений(СтруктураЗаписи, "НастройкиТранспортаОбменаОбластейДанных");
	
КонецПроцедуры

//

Функция НастройкиТранспорта(Знач КонечнаяТочкаКорреспондента) Экспорт
	
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	НастройкиТранспортаОбменаОбластейДанных.FILEКаталогОбменаИнформацией,
	|	НастройкиТранспортаОбменаОбластейДанных.FILEСжиматьФайлИсходящегоСообщения,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСжиматьФайлИсходящегоСообщения,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеМаксимальныйДопустимыйРазмерСообщения,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПассивноеСоединение,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПользователь,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПорт,
	|	НастройкиТранспортаОбменаОбластейДанных.FTPСоединениеПуть,
	|	НастройкиТранспортаОбменаОбластейДанных.ВидТранспортаСообщенийОбменаПоУмолчанию
	|ИЗ
	|	РегистрСведений.НастройкиТранспортаОбменаОбластейДанных КАК НастройкиТранспортаОбменаОбластейДанных
	|ГДЕ
	|	НастройкиТранспортаОбменаОбластейДанных.КонечнаяТочкаКорреспондента = &КонечнаяТочкаКорреспондента";
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("КонечнаяТочкаКорреспондента", КонечнаяТочкаКорреспондента);
	Запрос.Текст = ТекстЗапроса;
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		ВызватьИсключение СтрШаблон(НСтр("ru = 'Не заданы настройки подключения для конечной точки %1.'"),
			Строка(КонечнаяТочкаКорреспондента));
	КонецЕсли;
	
	Результат = ОбменДаннымиСервер.РезультатЗапросаВСтруктуру(РезультатЗапроса);
	УстановитьПривилегированныйРежим(Истина);
	Пароли = ОбщегоНазначения.ПрочитатьДанныеИзБезопасногоХранилища(КонечнаяТочкаКорреспондента, "FTPСоединениеПарольОбластейДанных,ПарольАрхиваСообщенияОбменаОбластейДанных");
	УстановитьПривилегированныйРежим(Ложь);
	Результат.Вставить("ПарольАрхиваСообщенияОбмена", Пароли.ПарольАрхиваСообщенияОбменаОбластейДанных);
	Результат.Вставить("FTPСоединениеПароль", Пароли.FTPСоединениеПарольОбластейДанных);
	
	Если Результат.ВидТранспортаСообщенийОбменаПоУмолчанию = Перечисления.ВидыТранспортаСообщенийОбмена.FTP Тогда
		
		ПараметрыFTP = ОбменДаннымиСервер.FTPИмяСервераИПуть(Результат.FTPСоединениеПуть);
		
		Результат.Вставить("FTPСервер", ПараметрыFTP.Сервер);
		Результат.Вставить("FTPПуть",   ПараметрыFTP.Путь);
	Иначе
		Результат.Вставить("FTPСервер", "");
		Результат.Вставить("FTPПуть",   "");
	КонецЕсли;
	
	ОбменДаннымиСервер.ДополнитьНастройкиТранспортаКоличествомЭлементовВТранзакции(Результат);
	
	Возврат Результат;
	
КонецФункции

#КонецЕсли