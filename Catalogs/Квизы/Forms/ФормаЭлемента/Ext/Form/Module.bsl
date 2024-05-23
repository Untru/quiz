﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЗаполнитьКлючьСвязиПоНомеруСтроки();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДатаПроведенияПриИзменении(Элемент)
	
	Объект.Наименование = СтрШаблон("Игра %1", Формат(Объект.ДатаПроведения, "ДЛФ=DD"));	
	
КонецПроцедуры

#Область МеханизмСвязиСтрокЧерезКлючСвязи

&НаКлиенте
Процедура РаундыПередУдалением(Элемент, Отказ)
	
	Для каждого ИдентификаторСтроки Из Элементы.Раунды.ВыделенныеСтроки Цикл
		СтрокаРаунда = Объект.Раунды.НайтиПоИдентификатору(ИдентификаторСтроки);
		НомерРаздела = Объект.Раунды.Индекс(СтрокаРаунда) + 1;
		УдалитьВопросыРаздела(НомерРаздела);
	КонецЦикла;
	
КонецПроцедуры 

&НаКлиенте
Процедура ВопросыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
		
	ТекущиеДанные = Элементы.Раунды.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда 
		КлючСвязи = 1;
	Иначе
		КлючСвязи = Элементы.Раунды.ТекущиеДанные.НомерСтроки;
	КонецЕсли;
		
	Элемент.ТекущиеДанные.КлючСвязи = КлючСвязи;
		
КонецПроцедуры

&НаКлиенте
Процедура РаундыПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	
	Отказ = Истина;
	НоваяСтрока = Объект.Раунды.Добавить();
	
	Если Копирование Тогда
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Родитель);
	КонецЕсли;
	
	НоваяСтрока.КлючСвязи = НоваяСтрока.НомерСтроки;

КонецПроцедуры

&НаКлиенте
Процедура РаундыПриАктивизацииСтроки(Элемент)
	
	СтрокаТабличнойЧасти = Элементы.Раунды.ТекущиеДанные;
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	КлючСвязи = Объект.Раунды.Индекс(СтрокаТабличнойЧасти) + 1;
	
	Элементы.Вопросы.ОтборСтрок = Новый ФиксированнаяСтруктура("КлючСвязи", КлючСвязи);

КонецПроцедуры

#КонецОбласти

&НаКлиенте
Процедура ВопросыПриИзменении(Элемент)
	
	НомерСтроки = Элемент.ТекущиеДанные.НомерСтроки;
	Вопрос = Элемент.ТекущиеДанные.Вопрос;
	Для Каждого СтрокаВопросы Из Объект.Вопросы Цикл
		Если СтрокаВопросы.НомерСтроки = НомерСтроки Тогда
			Продолжить;	
		КонецЕсли;
		Если СтрокаВопросы.Вопрос = Вопрос Тогда
			//todo Тут надо по идее строку надо удалять
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Таков вопрос уже есть в этом квиз, выберите другой'"));	
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьКомандуВИгру(Команда)
	
	Если Элементы.ЗаявкиНаИгру.ТекущиеДанные = Неопределено Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не выбранна заявка на игру'"));	
	КонецЕсли;
	ЗаявкаКоманды = Элементы.ЗаявкиНаИгру.ТекущиеДанные.Команда;
	
	ПараметрыОткрытияФормы = Новый Структура;
	ПараметрыОткрытияФормы.Вставить("Команда", ЗаявкаКоманды);

	ОткрытьФорму("ОбщаяФорма.ФормаВводаПароля", ПараметрыОткрытияФормы, ЭтотОбъект, УникальныйИдентификатор,,,
		Новый ОписаниеОповещения("ДействиеПринятьКомандуВИгруЗавершение", ЭтотОбъект) ,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры

&НаКлиенте
Процедура ДействиеПринятьКомандуВИгруЗавершение(ЛогинИПароль, ДополнительныеПараметры) Экспорт
	
	Если ЛогинИПароль = Неопределено Тогда
		Возврат;	
	КонецЕсли;

	ЗаявкаКоманды = Элементы.ЗаявкиНаИгру.ТекущиеДанные.Команда;
	ПринятьКомандуНаСервере(ЗаявкаКоманды, ЛогинИПароль);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПринятьКомандуНаСервере(ЗаявкаКоманды, ЛогинИПароль)
	
	СтрокаКоманды = Объект.Команды.Добавить();
	СтрокаКоманды.Команда = ЗаявкаКоманды;
	СтрокаКоманды.Логин = ЛогинИПароль.Логин;
	ИграВКвиз.ПринятьКомандуВКвиз(ЗаявкаКоманды, Объект.Ссылка, ЛогинИПароль.Логин, ЛогинИПароль.Пароль);
	
	Записать();	
	Элементы.ЗаявкиНаИгру.Обновить();
	
КонецПроцедуры

&НаСервере
Процедура УдалитьВопросыРаздела(КлючСвязи)
	
	Вопросы = Объект.Вопросы.НайтиСтроки(Новый Структура("КлючСвязи", КлючСвязи));
	Для Каждого СтрокаВопрос Из Вопросы Цикл
		Объект.Вопросы.Удалить(СтрокаВопрос);
	КонецЦикла;
	
	Если Объект.Раунды.Количество() > КлючСвязи Тогда
		ПересчитатьНомераРаундов(КлючСвязи);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПересчитатьНомераРаундов(КлючСвязи)
	
	Для каждого СтрокаТовары Из Объект.Вопросы Цикл
		Если СтрокаТовары.КлючСвязи > КлючСвязи Тогда
			СтрокаТовары.КлючСвязи = СтрокаТовары.КлючСвязи - 1;
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьКлючьСвязиПоНомеруСтроки()
	
	Для Каждого СтрокаРаунд Из Объект.Раунды Цикл
		СтрокаРаунд.КлючСвязи = СтрокаРаунд.НомерСтроки;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти

