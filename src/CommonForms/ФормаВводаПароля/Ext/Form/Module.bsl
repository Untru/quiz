﻿#Область ОписаниеПеременных
Перем Команда;
#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Команда = Параметры.Команда;
	Элементы.ДекорацияВведитеЛогинИПароль.Заголовок = СтрШаблон("Введите логин и пароль 
																|Для команды %1", Команда);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ПринятьКоманду(Команда)
		
	ЛогинПароль = Новый Структура;
	ЛогинПароль.Вставить("Логин", Логин);
	ЛогинПароль.Вставить("Пароль", Пароль);
	
	Закрыть(ЛогинПароль);
	
КонецПроцедуры


#КонецОбласти

