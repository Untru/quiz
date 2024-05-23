﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

Функция ОтветПринят(Вопрос, ЭталонныйОтвет, Ответ) Экспорт
	
	РезультатСравнения = ДжароВинклер(НРег(ЭталонныйОтвет), НРег(Ответ));
	
	//Логику расчета я скопировал из другого источника, 
	//https://infostart.ru/1c/tools/820798/
	//Код не менял, так как идея тут показать подход с использованием стратегий
	//Смысла делать не него код ревью нет, так же как и тратить время на его рефакторинг
	Если РезультатСравнения > 0.7 Тогда
		Возврат Истина	
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

#КонецОбласти

#Область СкопированнныйКодНеДелатьКодРевью

Процедура ИнициализироватьМассив(Мас, Кол)
	
	Для инд = 1 По Кол Цикл
		Мас.Добавить(Ложь);		
	КонецЦикла;
	
КонецПроцедуры

Функция ПодсчетСовпадений(prmTextInitial, b1)
	
	Рез = "";
	Для i = 1 По СтрДлина(prmTextInitial) Цикл
		Если b1[i] Тогда
			Рез = Рез + Сред(prmTextInitial, i, 1);
		КонецЕсли;
	КонецЦикла;  
	
	Возврат Рез;
	
КонецФункции

Функция ДжароВинклер(prmT1, prmT2, p=0.1) Экспорт
	
	ЭкартоваяШирина = Окр(Макс(СтрДлина(prmT1), СтрДлина(prmT2))/2)-1;
 
 	Если (СокрЛП(prmT1) = "") or СокрЛП(prmT2 = "") Тогда
 		Возврат 0;
	КонецЕсли;
	
	КолСовпадений = 0;
	КолТранспозиций = 0;
	l1 = СтрДлина(prmT1);
	l2 = СтрДлина(prmT2);

	b1 = Новый Массив;
	b2 = Новый Массив;
	ИнициализироватьМассив(b1, l1+1);
	ИнициализироватьМассив(b2, l2+1);

	Для i = 1 По l1 Цикл
		b1[i] = Ложь;
  	КонецЦикла;
	
	Для i = 1 По l2 Цикл
		b2[i] = Ложь;
	КонецЦикла;
  
	Для i = 1 По l1 Цикл
		c1 = Сред(prmT1,i,1);
		
		Если (i <= l2) Тогда
			c2 = Сред(prmT2,i,1);
			Если c1 = c2 Тогда
				b1[i] = true;
				b2[i] = true;
				КолСовпадений = КолСовпадений + 1;
				Продолжить;
			КонецЕсли;
		Иначе
			c2 = "";
		КонецЕсли;		
		
		Для j = Макс(i-ЭкартоваяШирина, 1) По Min(i+ЭкартоваяШирина, l2) Цикл
			c2 = Сред(prmT2,j,1);
			Если c1 = c2 Тогда
				b1[i] = true;
				b2[j] = true;
				КолСовпадений = КолСовпадений + 1;
				Прервать;;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
				
	Если КолСовпадений = 0 Тогда
		Возврат 0;
	КонецЕсли;
	
	СтрокаСовпадений1 = ПодсчетСовпадений(prmT1, b1);
	СтрокаСовпадений2 = ПодсчетСовпадений(prmT2, b2);

	Если СтрокаСовпадений1 <> СтрокаСовпадений2 Тогда
		Для i = 1 По СтрДлина(СтрокаСовпадений1) Цикл
	    	Если Сред(СтрокаСовпадений1,i,1) <> Сред(СтрокаСовпадений2, i,1) Тогда
	      		КолТранспозиций = КолТранспозиций + 1;
			КонецЕсли;
	  	КонецЦикла;
	Иначе
		КолТранспозиций = 0;
	КонецЕсли;
	
	РасстояниеДжаро = 1/3 * ((КолСовпадений/l1)+(КолСовпадений/l2)+((КолСовпадений- (КолТранспозиций/2) )/КолСовпадений));
	
	Винклер = 0;
	Для i = 1 По Мин(4, l1,l2) Цикл
		c1 = Сред(prmT1,i,1);
		c2 = Сред(prmT2,i,1);
		Если c1 = c2 Тогда
			Винклер = Винклер + 1;
		else
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Возврат РасстояниеДжаро + (Винклер * p * (1 - РасстояниеДжаро));

КонецФункции

Функция СравнитьТекст(Стр1, Стр2, МинДлиннаСлова=3, МинимальныйРезультат=0.1, p=0.1) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Стр1) ИЛИ НЕ ЗначениеЗаполнено(Стр2) Тогда
		Возврат 0;
	КонецЕсли;
	
	ГотоваяСтрока1 = НРег(Стр1);
	ГотоваяСтрока2 = НРег(Стр2);
	
	ГотоваяСтрока1 = УдалитьНенужныеСимволы(ГотоваяСтрока1);
	ГотоваяСтрока2 = УдалитьНенужныеСимволы(ГотоваяСтрока2);
	
	МассивСлов1 = Новый Массив;
	МассивСлов2 = Новый Массив;
	
	МассивСлов1 = РазложитьСтрокуВМассивПодстрок(ГотоваяСтрока1, " ");
	МассивСлов2 = РазложитьСтрокуВМассивПодстрок(ГотоваяСтрока2, " ");
	
	КоличествоСравнений = 0;
	ОбщийРезультат = 0;
	СреднийРезультат = 0;
	Для Каждого сл1 Из МассивСлов1 Цикл
		Если СтрДлина(сл1) < МинДлиннаСлова Тогда
			Продолжить;
		КонецЕсли;
		МаксРез = 0;
		слово2 = "";
		Для Каждого сл2 Из МассивСлов2 Цикл
			Если СтрДлина(сл2) < МинДлиннаСлова Тогда
				Продолжить;
			КонецЕсли;
			Рез = ДжароВинклер(сл1, сл2, p);
			Если Рез > МаксРез Тогда
				МаксРез = Макс(МаксРез, Рез);
				слово2 = сл2;
			КонецЕсли;
		КонецЦикла;
		
		Если МаксРез > МинимальныйРезультат Тогда
			КоличествоСравнений = КоличествоСравнений + 1;
			ОбщийРезультат = ОбщийРезультат + МаксРез;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоСравнений <> 0 Тогда
		СреднийРезультат = ОбщийРезультат / КоличествоСравнений;
	Иначе
		СреднийРезультат = 0;
	КонецЕсли;
	
	Возврат ОбщийРезультат;
	
КонецФункции

Функция СравнитьТекстПодробно(Стр1, Стр2, МинДлиннаСлова=3, МинимальныйРезультат=0.1, p=0.1) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Стр1) ИЛИ НЕ ЗначениеЗаполнено(Стр2) Тогда
		Возврат 0;
	КонецЕсли;
	
	ГотоваяСтрока1 = НРег(Стр1);
	ГотоваяСтрока2 = НРег(Стр2);
	
	ГотоваяСтрока1 = УдалитьНенужныеСимволы(ГотоваяСтрока1);
	ГотоваяСтрока2 = УдалитьНенужныеСимволы(ГотоваяСтрока2);
	
	МассивСлов1 = Новый Массив;
	МассивСлов2 = Новый Массив;
	
	МассивСлов1 = РазложитьСтрокуВМассивПодстрок(ГотоваяСтрока1, " ");
	МассивСлов2 = РазложитьСтрокуВМассивПодстрок(ГотоваяСтрока2, " ");
	
	КоличествоСравнений = 0;
	ОбщийРезультат = 0;
	СреднийРезультат = 0;
	Для Каждого сл1 Из МассивСлов1 Цикл
		Если СтрДлина(сл1) < МинДлиннаСлова Тогда
			Продолжить;
		КонецЕсли;
		МаксРез = 0;
		слово2 = "";
		Для Каждого сл2 Из МассивСлов2 Цикл
			Если СтрДлина(сл2) < МинДлиннаСлова Тогда
				Продолжить;
			КонецЕсли;
			Рез = ДжароВинклер(сл1, сл2, p);
			Если Рез > МаксРез Тогда
				МаксРез = Макс(МаксРез, Рез);
				слово2 = сл2;
			КонецЕсли;
		КонецЦикла;
		
		Если МаксРез > МинимальныйРезультат Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Результат слов ("+сл1+")и("+слово2+"): "+МаксРез);
			КоличествоСравнений = КоличествоСравнений + 1;
			ОбщийРезультат = ОбщийРезультат + МаксРез;
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоСравнений <> 0 Тогда
		СреднийРезультат = ОбщийРезультат / КоличествоСравнений;
	Иначе
		СреднийРезультат = 0;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Общий результат: "+ОбщийРезультат);
	Возврат ОбщийРезультат;
	
КонецФункции

Функция РазложитьСтрокуВМассивПодстрок(Знач Стр, Разделитель = "###") Экспорт

	МассивСтрок = Новый Массив();
	Если Разделитель = " " Тогда
		Стр = СокрЛП(Стр);
		Пока Истина Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = СокрЛ(Сред(Стр,Поз));
		КонецЦикла;
	Иначе
		ДлинаРазделителя = СтрДлина(Разделитель);
		Пока Истина Цикл
			Поз = Найти(Стр,Разделитель);
			Если Поз=0 Тогда
				МассивСтрок.Добавить(Стр);
				Возврат МассивСтрок;
			КонецЕсли;
			МассивСтрок.Добавить(Лев(Стр,Поз-1));
			Стр = Сред(Стр,Поз+ДлинаРазделителя);
		КонецЦикла;
	КонецЕсли;

КонецФункции

Функция УдалитьНенужныеСимволы(Стр)
	
	Рез = СокрЛП(Стр);
	
	//цифры здесь тоже удаляются, если нужно уберите эти строки
	Рез = СтрЗаменить(Рез, "0", " ");
	Рез = СтрЗаменить(Рез, "1", " ");
	Рез = СтрЗаменить(Рез, "2", " ");
	Рез = СтрЗаменить(Рез, "3", " ");
	Рез = СтрЗаменить(Рез, "4", " ");
	Рез = СтрЗаменить(Рез, "5", " ");
	Рез = СтрЗаменить(Рез, "6", " ");
	Рез = СтрЗаменить(Рез, "7", " ");
	Рез = СтрЗаменить(Рез, "8", " ");
	Рез = СтрЗаменить(Рез, "9", " ");	
	
	Рез = СтрЗаменить(Рез, "{", " ");
	Рез = СтрЗаменить(Рез, "}", " ");
	Рез = СтрЗаменить(Рез, ";", " ");
	Рез = СтрЗаменить(Рез, ":", " ");
	Рез = СтрЗаменить(Рез, ",", " ");
	Рез = СтрЗаменить(Рез, "(", " ");
	Рез = СтрЗаменить(Рез, ")", " ");
	Рез = СтрЗаменить(Рез, "_", " ");
	Рез = СтрЗаменить(Рез, "=", " ");
	Рез = СтрЗаменить(Рез, "+", " ");
	Рез = СтрЗаменить(Рез, "/", " ");
	Рез = СтрЗаменить(Рез, "|", " ");
	Рез = СтрЗаменить(Рез, "\", " ");
	Рез = СтрЗаменить(Рез, "<", " ");
	Рез = СтрЗаменить(Рез, ">", " ");

	Рез = СтрЗаменить(Рез, "  ", " ");
	Рез = СтрЗаменить(Рез, "  ", " ");
	Рез = СтрЗаменить(Рез, "  ", " ");
	Рез = СтрЗаменить(Рез, "  ", " ");
	Рез = СтрЗаменить(Рез, "  ", " ");
	
	
	Возврат Рез;
	
КонецФункции

Процедура СравнениеПоСловамНаСервере(Стр1, Стр2)
	
	МинДлиннаСлова = 3;
	МинимальныйРезультат = 0.7;
	
	Если НЕ ЗначениеЗаполнено(Стр1) ИЛИ НЕ ЗначениеЗаполнено(Стр2) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("НЕТ ДАННЫХ!!!");
		Возврат;
	КонецЕсли;
	
	ГотоваяСтрока1 = НРег(Стр1);
	ГотоваяСтрока2 = НРег(Стр2);
	
	ГотоваяСтрока1 = УдалитьНенужныеСимволы(ГотоваяСтрока1);
	ГотоваяСтрока2 = УдалитьНенужныеСимволы(ГотоваяСтрока2);
	
	МассивСлов1 = Новый Массив;
	МассивСлов2 = Новый Массив;
	
	МассивСлов1 = РазложитьСтрокуВМассивПодстрок(ГотоваяСтрока1, " ");
	МассивСлов2 = РазложитьСтрокуВМассивПодстрок(ГотоваяСтрока2, " ");
	
	КоличествоСравнений = 0;
	ОбщийРезультат = 0;
	СреднийРезультат = 0;
	Для Каждого сл1 Из МассивСлов1 Цикл
		Если СтрДлина(сл1) < МинДлиннаСлова Тогда
			Продолжить;
		КонецЕсли;
		МаксРез = 0;
		слово2 = "";
		Для Каждого сл2 Из МассивСлов2 Цикл
			Если СтрДлина(сл2) < МинДлиннаСлова Тогда
				Продолжить;
			КонецЕсли;
			Рез = ДжароВинклер(сл1, сл2);
			Если Рез > МаксРез Тогда
				МаксРез = Макс(МаксРез, Рез);
				слово2 = сл2;
			КонецЕсли;
		КонецЦикла;
		
		Если МаксРез > МинимальныйРезультат Тогда
			КоличествоСравнений = КоличествоСравнений + 1;
			ОбщийРезультат = ОбщийРезультат + МаксРез;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Промежуточный результат ("+сл1+"     ---     "+слово2+") : "+МаксРез);
		КонецЕсли;
	КонецЦикла;
	
	Если КоличествоСравнений <> 0 Тогда
		СреднийРезультат = ОбщийРезультат / КоличествоСравнений;
	Иначе
		СреднийРезультат = 0;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Средний результат: " + СреднийРезультат + "   Общий результат: " + ОбщийРезультат);
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли