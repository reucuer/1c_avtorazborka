﻿
&НаКлиенте
Процедура СсылкаНаКартинкуНажатие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь; 
	Режим = РежимДиалогаВыбораФайла.Открытие; 
	ДиалогОткрытия = Новый ДиалогВыбораФайла(Режим); 
	ДиалогОткрытия.ПолноеИмяФайла = "C:\1c\111111.jpg"; 
	Фильтр = "Файл Jpg (*.jpg)|*.jpg"; 
	ДиалогОткрытия.Фильтр = Фильтр; 
	ДиалогОткрытия.МножественныйВыбор = Ложь; 
	ДиалогОткрытия.Заголовок = "Выберете файл для загрузки";
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеЗагрузкиФайла",ЭтаФорма); 
	ДиалогОткрытия.Показать(ОписаниеОповещения);	
КонецПроцедуры

&НаКлиенте 
Процедура ПослеЗагрузкиФайла(ФайлИсточник,ДопПараметр) Экспорт 
	Если ФайлИсточник = Неопределено Тогда 
		Возврат; 
	КонецЕсли; 
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеПомещенияФайла", ЭтаФорма); 
	НачатьПомещениеФайла(ОписаниеОповещения,, ФайлИсточник[0], Ложь, УникальныйИдентификатор); 
КонецПроцедуры

&НаКлиенте 
Процедура ПослеПомещенияФайла(Результат, Адрес, ВыбранноеИмяФайла,ДопПараметры) Экспорт 
	Если Не Результат Тогда 
		Возврат; 
	КонецЕсли; 
	СсылкаНаКартинку = Адрес;
	Объект.Путь = СтрЗаменить(ВыбранноеИмяФайла, "C:\xampp\htdocs\avtorazborka\1c\","");
	Модифицированность = Истина; 
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ЭтоАдресВременногоХранилища(СсылкаНаКартинку)  Тогда 
		ФайлКартинки = ПолучитьИзВременногоХранилища(СсылкаНаКартинку); 
			
		//ИмяФайла = "C:\1c\111111.jpg"; 
		//ФайлИсточник = Новый Файл(ИмяФайла);
		
		//ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
		ТекущийОбъект.Картинка = Новый ХранилищеЗначения(ФайлКартинки); 
		УдалитьИзВременногоХранилища(СсылкаНаКартинку);
		СсылкаНаКартинку = ПолучитьНавигационнуюСсылку(Объект.Ссылка,"Картинка"); 
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СсылкаНаКартинку = ПолучитьНавигационнуюСсылку(Объект.Ссылка,"Картинка");
	
	// Добвляем команду формы
	НоваяКоманда = ЭтаФорма.Команды.Добавить("Добавить_JSON");
	// Свойство "Действие" содержит имя процедуры-обработчика команды
	НоваяКоманда.Действие = "Добавить_JSON";
	
	// Добавляем элемент "КомандаПредупредить" с типом "Кнопка формы"
	НовыйЭлемент = Элементы.ДобавитьJSON;
	// Присваиваем команду для созданной кнопке
	НовыйЭлемент.ИмяКоманды = "Добавить_JSON";
	
КонецПроцедуры


&НаКлиенте
Процедура Добавить_JSON(Элемент)
	//Сообщить();
	Запись_JSON();
	Сообщить("JSON Добавлен!");
	
КонецПроцедуры

&НаСервере
Процедура Запись_JSON()
	ДокументОбъект = РеквизитФормыВЗначение("Объект");
	//ДокументОбъект.ПроцедураМодуляОбъектаЭкспортная();
	ДокументОбъект.ЗаписьJSON();
	ВыгрузкаВMySQL();
	
КонецПроцедуры

&НаСервере
Процедура КнопкаНаСервере()
	
	
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьНажатие(Команда)

	КнопкаНаСервере();
КонецПроцедуры

&НаСервере
Функция ВыгрузкаВMySQL()
	Сообщить("ВыгрузкаВMySQL");
	
	Connection = Новый COMОбъект("ADODB.Connection");
	Выборка     = Новый COMОбъект("ADODB.RecordSet");
	
	АдресСервера 	= "localhost";
	НомерПорта 		= "3306";
	ИмяБД		    = "db_shop";
	Пользователь	= "admin";
	Пароль			= "123456";
	ТаблицаSQL 		= "table_products";
	price 		= "100110";
	
	Connection.ConnectionString = "Driver={MySQL ODBC 5.1 Driver};Server="+СокрЛП(АдресСервера)+";Port=" + НомерПорта + ";Database=" + СокрЛП(ИмяБД) + ";User=" + Пользователь + ";Password=" + Пароль + ";";
	СтрокаПодключения = "DSN=myDSNuser;";
	Попытка
		Connection.Open(СтрокаПодключения); 
		//Connection.Open("Driver={MySQL ODBC 5.1 Driver(*.dbf)};DriverId=277;Dbq=C:");
	Исключение
		Сообщить("Ошибка подключения - " + ОписаниеОшибки());
		Возврат Ложь;
			
	КонецПопытки;
	
	ВыборкаГорода = Справочники.Товары.Выбрать();	
Пока ВыборкаГорода.Следующий() Цикл
	
	  price = ПолучитьЦену(ВыборкаГорода.ПолучитьОбъект().Наименование);
	  image = Строка(ВыборкаГорода.Путь);
	  title = Строка( ВыборкаГорода.Наименование);
	  mini_features = Строка(ВыборкаГорода.Описание);
   ТекстТекущейИнструкции =
        "INSERT INTO "+ТаблицаSQL+" (price, image,title,mini_features) VALUES ("+price+",'"+image+"','"+title+"','"+mini_features+"')";
    Попытка
        Connection.Execute(ТекстТекущейИнструкции,128);
        Сообщить("Запись добавлена!");
    Исключение
        Сообщить(ОписаниеОшибки());
    КонецПопытки;
 КонецЦикла;
  
	
КонецФункции

&НаСервере 
Функция ПолучитьЦену(СсылкаНаОбъект)
	    Запрос = Новый Запрос;
     Запрос.Текст =
      "ВЫБРАТЬ
		|	ЦеныТоваров.Цена КАК Цена
		|ИЗ
		|	РегистрСведений.ЦеныТоваров КАК ЦеныТоваров
		|ГДЕ 
		|	ЦеныТоваров.Товар.Наименование = &Товар";
     
     Запрос.УстановитьПараметр("Товар", СсылкаНаОбъект);
    ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();

    Если ВыборкаДетальныеЗаписи.Следующий() Тогда
     Возврат  ВыборкаДетальныеЗаписи.Цена;     
Иначе
    Возврат 0;
КонецЕсли;
      
КонецФункции


