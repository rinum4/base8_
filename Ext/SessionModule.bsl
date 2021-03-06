﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура УстановкаПараметровСеанса(ИменаПараметровСеанса)
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыСервер.УстановкаПараметровСеанса(ИменаПараметровСеанса);
	// Конец СтандартныеПодсистемы
	
	// ТехнологияСервиса
	ТехнологияСервиса.ВыполнитьДействияПриУстановкеПараметровСеанса(ИменаПараметровСеанса);
	// Конец ТехнологияСервиса
	
	// Установка параметра сеанса подсистемы "Оценка производительности" при использовании отдельно от БСП.
	ОценкаПроизводительностиСлужебный.УстановкаПараметровСеанса("КомментарийЗамераВремени", Новый Массив);
	
	// ТестЦентр
	ТЦСервер.УстановитьПараметрыСеанса(ИменаПараметровСеанса);
	// Конец ТестЦентр
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли