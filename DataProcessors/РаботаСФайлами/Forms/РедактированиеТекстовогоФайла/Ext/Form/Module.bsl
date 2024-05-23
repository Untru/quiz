﻿///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Файл = Параметры.Файл;
	ДанныеФайла = Параметры.ДанныеФайла;
	ИмяОткрываемогоФайла = Параметры.ИмяОткрываемогоФайла;
	ИдентификаторВладельца = Параметры.ИдентификаторВладельца;
	
	Если Не ЗначениеЗаполнено(ИдентификаторВладельца) Тогда
		ИдентификаторВладельца = УникальныйИдентификатор;
	КонецЕсли;
	
	Если ДанныеФайла.ФайлРедактируетТекущийПользователь Тогда
		РежимРедактирования = Истина;
	КонецЕсли;
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
		РежимРедактирования = Ложь;
	КонецЕсли;
	
	ТолькоПросмотр = Не ПравоДоступа("Редактирование", Файл.Метаданные());
	
	Элементы.Текст.ТолькоПросмотр                = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Видимость           = ОбщегоНазначения.ЭтоWindowsКлиент();
	Элементы.ПоказатьОтличия.Доступность         = РежимРедактирования;
	Элементы.Редактировать.Доступность           = Не РежимРедактирования И Не ТолькоПросмотр;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность        = РежимРедактирования;
	Элементы.Записать.Доступность                = РежимРедактирования;
	
	Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия
		ИЛИ ДанныеФайла.Служебный Тогда
		Элементы.Редактировать.Доступность = Ложь;
	КонецЕсли;
	
	ЗаголовокСтрока = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, ДанныеФайла.Расширение);
	
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + " " + НСтр("ru = '(только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
	Если ДанныеФайла.Свойство("Кодировка") Тогда
		КодировкаТекстаФайла = ДанныеФайла.Кодировка;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(КодировкаТекстаФайла) Тогда
		СписокКодировок = РаботаСФайламиСлужебный.Кодировки();
		ЭлементСписка = СписокКодировок.НайтиПоЗначению(КодировкаТекстаФайла);
		Если ЭлементСписка = Неопределено Тогда
			КодировкаПредставление = КодировкаТекстаФайла;
		Иначе
			КодировкаПредставление = ЭлементСписка.Представление;
		КонецЕсли;
	Иначе
		КодировкаПредставление = НСтр("ru = 'По умолчанию'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаДляЧтения());
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "Запись_Файл"
	   И Параметр.Событие = "ФайлРедактировался"
	   И Источник = Файл Тогда
		
		РежимРедактирования = Истина;
		УстановитьДоступностьКоманд();
	КонецЕсли;
	
	Если ИмяСобытия = "Запись_Файл"
	   И Параметр.Событие = "ДанныеФайлаИзменены"
	   И Источник = Файл Тогда
		
		ПараметрыДанныхФайла = РаботаСФайламиКлиентСервер.ПараметрыДанныхФайла();
		ПараметрыДанныхФайла.ПолучатьСсылкуНаДвоичныеДанные = Ложь;
		ДанныеФайла = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайла(Файл,,ПараметрыДанныхФайла);
		
		РежимРедактирования = Ложь;
		
		Если ДанныеФайла.ФайлРедактируетТекущийПользователь Тогда
			РежимРедактирования = Истина;
		КонецЕсли;
		
		Если ДанныеФайла.Версия <> ДанныеФайла.ТекущаяВерсия Тогда
			РежимРедактирования = Ложь;
		КонецЕсли;
		
		УстановитьДоступностьКоманд();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	Отказ = Истина;
	
	ИмяИРасширение = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, РасширениеФайла());
	
	Если ЗавершениеРаботы Тогда
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Изменения в файле ""%1"" будут потеряны.'"), ИмяИРасширение);
		Возврат;
	КонецЕсли;

	ОбработчикРезультата = Новый ОписаниеОповещения("ПередЗакрытиемПослеОтветаНаВопросПриВыходеИзТекстовогоРедактора", ЭтотОбъект);
	ТекстНапоминания = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Файл ""%1"" был изменен.
			|Сохранить изменения?'"), 
		ИмяИРасширение);
	Кнопки = Новый СписокЗначений;
	Кнопки.Добавить("Сохранить", НСтр("ru = 'Сохранить'"));
	Кнопки.Добавить("НеСохранять", НСтр("ru = 'Не сохранять'"));
	Кнопки.Добавить("Отмена",  НСтр("ru = 'Отмена'"));
	ПараметрыНапоминания = Новый Структура;
	ПараметрыНапоминания.Вставить("Картинка", БиблиотекаКартинок.Информация32);
	ПараметрыНапоминания.Вставить("Заголовок", НСтр("ru = 'Внимание'"));
	ПараметрыНапоминания.Вставить("ПредлагатьБольшеНеЗадаватьЭтотВопрос", Ложь);
	СтандартныеПодсистемыКлиент.ПоказатьВопросПользователю(
			ОбработчикРезультата, ТекстНапоминания, Кнопки, ПараметрыНапоминания);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьКак(Команда)
	
	ВыборФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	ВыборФайла.МножественныйВыбор = Ложь;
	
	ИмяСРасширением = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, РасширениеФайла());
	
	ВыборФайла.ПолноеИмяФайла = ИмяСРасширением;
	Фильтр = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Все файлы (*.%1)|*.%1'"), РасширениеФайла());
	ВыборФайла.Фильтр = Фильтр;
	
	Если ВыборФайла.Выбрать() Тогда
		
		ВыбранноеПолноеИмяФайла = ВыборФайла.ПолноеИмяФайла;
		ЗаписатьТекстВФайл(ВыбранноеПолноеИмяФайла);
		
		ПоказатьОповещениеПользователя(НСтр("ru = 'Файл успешно сохранен'"), , ВыбранноеПолноеИмяФайла);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьКарточку(Команда)
	
	ПоказатьЗначение(, Файл);
	
КонецПроцедуры

&НаКлиенте
Процедура ВнешнийРедактор(Команда)
	
	ЗаписатьТекст();
	ФайловаяСистемаКлиент.ОткрытьФайл(ИмяОткрываемогоФайла);
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура Редактировать(Команда)
	
	РаботаСФайламиСлужебныйКлиент.РедактироватьСОповещением(Неопределено, Файл, ИдентификаторВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура Записать(Команда)
	
	ЗаписатьТекст();
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Сценарий", "НеВыполнятьДействий");
	Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, ИдентификаторВладельца);
	ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
	РаботаСФайламиСлужебныйКлиент.СохранитьИзмененияФайлаСОповещением(Обработчик, Файл, ИдентификаторВладельца);
		
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактирование(Команда)
	
	ЗаписатьТекст();
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Сценарий", "ЗакончитьРедактирование");
	Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, ИдентификаторВладельца);
	ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьОтличия(Команда)
	
#Если ВебКлиент Тогда
	ПоказатьПредупреждение(, НСтр("ru = 'Сравнение версий файлов в веб-клиенте недоступно.'"));
	Возврат;
#ИначеЕсли МобильныйКлиент Тогда
	ПоказатьПредупреждение(, НСтр("ru = 'Сравнение версий файлов в мобильном клиенте недоступно.'"));
	Возврат;
#Иначе
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("ТекущийШаг", 1);
	ПараметрыВыполнения.Вставить("СпособСравненияВерсийФайлов", Неопределено);
	ПараметрыВыполнения.Вставить("ПолноеИмяФайлаСлева", ПолучитьИмяВременногоФайла(РасширениеФайла()));
	ВыполнитьСравнениеФайлов(-1, ПараметрыВыполнения);
#КонецЕсли
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ЗаписатьТекст();
	
	ПараметрыОбработчика = Новый Структура;
	ПараметрыОбработчика.Вставить("Сценарий", "ЗаписатьИЗакрыть");
	Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
	
	ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, ИдентификаторВладельца);
	ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
	РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировку(Команда)
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ТекущаяКодировка", КодировкаТекстаФайла);
	Обработчик = Новый ОписаниеОповещения("ВыбратьКодировкуЗавершение", ЭтотОбъект);
	ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВыборКодировки", ПараметрыФормы, ЭтотОбъект, , , , Обработчик);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ПередЗакрытиемПослеОтветаНаВопросПриВыходеИзТекстовогоРедактора(Результат, ПараметрыВыполнения) Экспорт
	
	Если Результат.Значение = "Сохранить" Тогда
		
		ЗаписатьТекст();
		ПараметрыОбработчика = Новый Структура;
		ПараметрыОбработчика.Вставить("Сценарий", "Закрыть");
		Обработчик = Новый ОписаниеОповещения("ЗакончитьРедактированиеЗавершение", ЭтотОбъект, ПараметрыОбработчика);
		ПараметрыОбновленияФайла = РаботаСФайламиСлужебныйКлиент.ПараметрыОбновленияФайла(Обработчик, Файл, ИдентификаторВладельца);
		ПараметрыОбновленияФайла.Кодировка = КодировкаТекстаФайла;
		РаботаСФайламиСлужебныйКлиент.ЗакончитьРедактированиеСОповещением(ПараметрыОбновленияФайла);
		
	ИначеЕсли Результат.Значение = "НеСохранять" Тогда
		
		Модифицированность = Ложь;
		Закрыть();
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьКодировкуЗавершение(Результат, ПараметрыВыполнения) Экспорт
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат;
	КонецЕсли;
	
	КодировкаТекстаФайла   = Результат.Значение;
	КодировкаПредставление = Результат.Представление;
	
	Если РежимРедактирования Тогда
		Модифицированность = Истина;
	КонецЕсли;
	
	ПрочитатьТекст();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗакончитьРедактированиеЗавершение(Результат, ПараметрыВыполнения) Экспорт
	Если Результат <> Истина Тогда
		Возврат;
	КонецЕсли;
	
	Если ПараметрыВыполнения.Сценарий = "ЗакончитьРедактирование" Тогда
		РежимРедактирования = Ложь;
		УстановитьДоступностьКоманд();
	ИначеЕсли ПараметрыВыполнения.Сценарий = "ЗаписатьИЗакрыть" Тогда
		РежимРедактирования = Ложь;
		УстановитьДоступностьКоманд();
		Закрыть();
	ИначеЕсли ПараметрыВыполнения.Сценарий = "Закрыть" Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекст()
	
	Если Не Модифицированность Тогда
		Возврат;
	КонецЕсли;
	
	ЗаписатьТекстВФайл(ИмяОткрываемогоФайла);
	Модифицированность = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьТекстВФайл(ИмяФайла)
	
	ТекстФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыXML(Текст.ПолучитьТекст());
	Текст.УстановитьТекст(ТекстФайла);
	
	Если КодировкаТекстаФайла = "utf-8_WithoutBOM" Тогда
		
		ДвоичныеДанные = ПолучитьДвоичныеДанныеИзСтроки(Текст.ПолучитьТекст(), "utf-8", Ложь);
		ДвоичныеДанные.Записать(ИмяФайла);
		
	Иначе
		
		Текст.Записать(ИмяФайла,
			?(ЗначениеЗаполнено(КодировкаТекстаФайла), КодировкаТекстаФайла, Неопределено));
		
	КонецЕсли;
	
	РаботаСФайламиСлужебныйВызовСервера.ЗаписатьКодировкуВерсииФайлаИИзвлеченныйТекст(
		ДанныеФайла.Версия, КодировкаТекстаФайла, Текст.ПолучитьТекст());
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьКоманд()
	
	Элементы.Текст.ТолькоПросмотр                = Не РежимРедактирования;
	Элементы.ПоказатьОтличия.Доступность         = РежимРедактирования;
	Элементы.Редактировать.Доступность           = Не РежимРедактирования;
	Элементы.ЗакончитьРедактирование.Доступность = РежимРедактирования;
	Элементы.ЗаписатьИЗакрыть.Доступность        = РежимРедактирования;
	Элементы.Записать.Доступность                = РежимРедактирования;
	Элементы.ФормаВыбратьКодировку.Доступность   = РежимРедактирования;
	
	ЗаголовокСтрока = ОбщегоНазначенияКлиентСервер.ПолучитьИмяСРасширением(
		ДанныеФайла.ПолноеНаименованиеВерсии, РасширениеФайла());
	
	Если Не РежимРедактирования Тогда
		ЗаголовокСтрока = ЗаголовокСтрока + " " + НСтр("ru = '(только просмотр)'");
	КонецЕсли;
	Заголовок = ЗаголовокСтрока;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрочитатьТекст()
	
	Текст.Прочитать(ИмяОткрываемогоФайла, КодировкаТекстаДляЧтения());
	
КонецПроцедуры

&НаКлиенте
Функция КодировкаТекстаДляЧтения()
	
	КодировкаТекстаДляЧтения = ?(ЗначениеЗаполнено(КодировкаТекстаФайла), КодировкаТекстаФайла, Неопределено);
	Если КодировкаТекстаДляЧтения = "utf-8_WithoutBOM" Тогда
		КодировкаТекстаДляЧтения = "utf-8";
	КонецЕсли;
	
	Возврат КодировкаТекстаДляЧтения;
	
КонецФункции

&НаКлиенте
Процедура ВыполнитьСравнениеФайлов(Результат, ПараметрыВыполнения) Экспорт
	Если ПараметрыВыполнения.ТекущийШаг = 1 Тогда
		ПерсональныеНастройки = РаботаСФайламиСлужебныйКлиент.ПерсональныеНастройкиРаботыСФайлами();
		ПараметрыВыполнения.СпособСравненияВерсийФайлов = ПерсональныеНастройки.СпособСравненияВерсийФайлов;
		// Первый вызов - еще не инициализирована настройка.
		Если ПараметрыВыполнения.СпособСравненияВерсийФайлов = Неопределено Тогда
			Обработчик = Новый ОписаниеОповещения("ВыполнитьСравнениеФайлов", ЭтотОбъект, ПараметрыВыполнения);
			ОткрытьФорму("Обработка.РаботаСФайлами.Форма.ВыборСпособаСравненияВерсий", , ЭтотОбъект, , , , Обработчик);
			ПараметрыВыполнения.ТекущийШаг = 1.1;
			Возврат;
		КонецЕсли;
		ПараметрыВыполнения.ТекущийШаг = 2;
	ИначеЕсли ПараметрыВыполнения.ТекущийШаг = 1.1 Тогда
		Если Результат <> КодВозвратаДиалога.ОК Тогда
			Возврат;
		КонецЕсли;
		ПерсональныеНастройки = РаботаСФайламиСлужебныйКлиент.ПерсональныеНастройкиРаботыСФайлами();
		ПараметрыВыполнения.СпособСравненияВерсийФайлов = ПерсональныеНастройки.СпособСравненияВерсийФайлов;
		Если ПараметрыВыполнения.СпособСравненияВерсийФайлов = Неопределено Тогда
			Возврат;
		КонецЕсли;
		ПараметрыВыполнения.ТекущийШаг = 2;
	КонецЕсли;
	
	Если ПараметрыВыполнения.ТекущийШаг = 2 Тогда
		// Сохранение файла для правой части.
		ЗаписатьТекст(); // Полное имя помещается в реквизит ИмяОткрываемогоФайла.
		
		// Сохранение файла для левой части.
		Если ДанныеФайла.ТекущаяВерсия = ДанныеФайла.Версия Тогда
			ДанныеФайлаСлева = РаботаСФайламиСлужебныйВызовСервера.ДанныеФайлаДляСохранения(Файл, , ИдентификаторВладельца);
			АдресФайлаСлева = ДанныеФайлаСлева.НавигационнаяСсылкаТекущейВерсии;
		Иначе
			АдресФайлаСлева = РаботаСФайламиСлужебныйВызовСервера.ПолучитьНавигационнуюСсылкуДляОткрытия(
				ДанныеФайла.Версия,
				ИдентификаторВладельца);
		КонецЕсли;
		ПередаваемыеФайлы = Новый Массив;
		ПередаваемыеФайлы.Добавить(Новый ОписаниеПередаваемогоФайла(ПараметрыВыполнения.ПолноеИмяФайлаСлева, АдресФайлаСлева));
		Если Не ПолучитьФайлы(ПередаваемыеФайлы,, ПараметрыВыполнения.ПолноеИмяФайлаСлева, Ложь) Тогда
			Возврат;
		КонецЕсли;
		
		// Сравнение.
		РаботаСФайламиСлужебныйКлиент.ВыполнитьСравнениеФайлов(
			ПараметрыВыполнения.ПолноеИмяФайлаСлева,
			ИмяОткрываемогоФайла,
			ПараметрыВыполнения.СпособСравненияВерсийФайлов);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция РасширениеФайла()
	
	Данные = ДанныеФайла; // См. РаботаСФайлами.ДанныеФайла
	Возврат Данные.Расширение;
	
КонецФункции

#КонецОбласти
