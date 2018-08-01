﻿////////////////////////////////////////////////////////////////////////////////
// Подсистема "Обновление конфигурации".
//  
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Определяет короткое имя (идентификатор) конфигурации.
//
// Параметры:
//	КраткоеИмя - Строка- короткое имя конфигурации.
//
Процедура ПриОпределенииКраткогоИмениКонфигурации(КраткоеИмя) Экспорт
	
	// _Демо начало примера
	Если СтандартныеПодсистемыСервер.ЭтоБазоваяВерсияКонфигурации() Тогда
		КраткоеИмя = "SSLBase";
	Иначе
		КраткоеИмя = "SSL";
	КонецЕсли;
	// _Демо конец примера
	
КонецПроцедуры

// Получает адрес веб-сервера поставщика конфигурации, на котором находится
// информация о доступных обновлениях ("открытая" часть веб-сайта).
//
// Параметры:
//	АдресСервера - Строка - адрес веб-сервера.
//
// Примеры реализации:
//	АдресСервера = "localhost";  // локальный веб-сервер для тестирования.
//
Процедура ПриОпределенииАдресаСервераДляПроверкиНаличияОбновления(АдресСервера) Экспорт
	
КонецПроцедуры

// Получить адрес ресурса на веб-сервере для проверки наличия обновлений
// (на "открытой" части веб-сайта).
//
// Параметры:
//	АдресРесурса - Строка - Адрес ресурса для проверки наличия обновления.
//
Процедура ПриОпределенииАдресаРесурсаДляПроверкиНаличияОбновления(АдресРесурса) Экспорт
	
КонецПроцедуры

// Получает адрес веб-сайта с каталогом обновлений ("закрытая" часть веб-сайта).
//
// Параметры:
//	АдресКаталогаОбновлений - Строка - Адрес каталога обновлений.
//
// Примеры реализации:
//	АдресКаталогаОбновлений = "localhost/tmplts/"; // локальный веб-сервер для тестирования.
//
Процедура ПриОпределенииАдресаКаталогаОбновлений(АдресКаталогаОбновлений) Экспорт
	
КонецПроцедуры

// Определяет группу версий конфигурации. Для каждой конфигурации возможно сквозное
// (без разрыва цепочки и необходимости запуска) обновление в пределах одной группы.
//
// Параметры:
//    ГруппаВерсий - Число - Группа версий конфигурации.
//
Процедура ПриОпределенииГруппыВерсий(ГруппаВерсий) Экспорт
	
КонецПроцедуры

#КонецОбласти
