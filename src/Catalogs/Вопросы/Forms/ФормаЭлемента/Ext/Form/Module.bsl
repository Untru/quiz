﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьНастройкиОтображения();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПриИзменении(Элемент)

	УстановитьНастройкиОтображения();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьНастройкиОтображения()

	Элементы.ЭталонныйОтвет.ОграничениеТипа = Новый ОписаниеТипов(Строка(Объект.ТипОтвета));
	
КонецПроцедуры

#КонецОбласти




