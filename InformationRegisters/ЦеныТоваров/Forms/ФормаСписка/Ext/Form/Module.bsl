﻿&НаКлиенте
Процедура Печать(Команда)
	ПечатьНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере()
    ТабДок = Новый ТабличныйДокумент;
    ТабДок.ТолькоПросмотр = Истина;
    ТабДок.АвтоМасштаб = Истина;
    //ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
   
    //Макет = РеквизитФормыВЗначение("Объект").ПолучитьМакет("Макет");
	
	Объект1 = РеквизитФормыВЗначение("Объект");
    Макет = Объект1.ПолучитьМакет("Макет");
       
    ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("Шапка");
   
    ОбластьСтрокаТаблицы = Макет.ПолучитьОбласть("Строка");
   
    Табдок.Вывести(ОбластьШапкаТаблицы);
   
    // Заполнение таблицы
    Запрос = Новый Запрос;
    Запрос.Текст =
        "ВЫБРАТЬ
        | ЦеныТоваров.Товар,
        | ЦеныТоваров.Цена
        |ИЗ
        | РегистрСведений.ЦеныТоваров КАК ЦеныТоваров";
       
    РезультатЗапроса = Запрос.Выполнить();   
    ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
   
    Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
        ОбластьСтрокаТаблицы.Параметры.Товар = ВыборкаДетальныеЗаписи.Товар;
        ОбластьСтрокаТаблицы.Параметры.Цена = ВыборкаДетальныеЗаписи.Цена;
        ТабДок.Вывести(ОбластьСтрокаТаблицы);
	КонецЦикла; 
    ТабДок.Показать();           
//    Возврат ТабДок;
//КонецФункции
КонецПроцедуры

