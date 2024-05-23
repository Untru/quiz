﻿
#Область ПрограммныйИнтерфейс

//Это не совсем стратегия, так как выбор стратегии происходит на клиенте и передается в контекст
Функция ОтветПринят(Вопрос, ЭталонныйОтвет, Ответ) Экспорт
	
	НастройкаСтратегии = Константы.СтратегииОценкиПравильногоОтвета.Получить();
	
	Если Не ЗначениеЗаполнено(НастройкаСтратегии) Тогда
		Возврат Ложь;
	КонецЕсли;
	
	Стратегия = СтратегияОпределенияВерногоОтвета(НастройкаСтратегии);
	Возврат Стратегия.ОтветПринят(Вопрос, ЭталонныйОтвет, Ответ);
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СтратегияОпределенияВерногоОтвета(НастройкаСтратегии)
	
	Менеджер = Перечисления.СтратегииОценкиПравильногоОтвета;
	
	СтратегияОпределенияВерногоОтвета = Новый Соответствие;
	СтратегияОпределенияВерногоОтвета.Вставить(Менеджер.ОдинКОдному, ОценкаПравильногоОтветаОдинКОдному);
	СтратегияОпределенияВерногоОтвета.Вставить(Менеджер.НечеткоеСравнение, ОценкаПравильногоОтветаНечеткоеСравнение);
	СтратегияОпределенияВерногоОтвета.Вставить(Менеджер.ИИGigaChat, ОценкаПравильногоОтветаИИGigaChat);
	
	Возврат СтратегияОпределенияВерногоОтвета[НастройкаСтратегии];
	
КонецФункции

#КонецОбласти
