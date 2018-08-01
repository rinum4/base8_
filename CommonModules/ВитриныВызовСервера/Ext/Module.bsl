﻿#Область СлужебныйПрограммныйИнтерфейс

Процедура ПриНачалеРаботыСистемы() Экспорт
	
	Если НЕ РаботаВМоделиСервиса.ИспользованиеРазделителяСеанса() Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписьЖурналаРегистрации(
		ИмяСобытияЖурналаРегистрации(), 
		УровеньЖурналаРегистрации.Информация, , 
		ПолучитьНавигационнуюСсылкуИнформационнойБазы());
	
	КонецПроцедуры
	
#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ИмяСобытияЖурналаРегистрации()
	
	Возврат НСтр("ru = 'Технология 1cFresh.Начало сеанса области данных'", 
		ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());	
	
КонецФункции

#КонецОбласти