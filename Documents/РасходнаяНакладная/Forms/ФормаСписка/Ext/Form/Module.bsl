﻿&НаКлиенте
Процедура ПечатьФормы()
	ТабДок = Новый ТабличныйДокумент;
	
	Массив = Элементы.Список.ВыделенныеСтроки;
	Для Каждого Объект Из Массив Цикл
		

	ПечатьНаСервере3(ТабДок,Объект);
	КонецЦикла;
	
	ТабДок.ОтображатьСетку = Ложь;
	ТабДок.ОтображатьЗаголовки = Ложь;
	ТабДок.Показать();
КонецПроцедуры

&НаСервере
Процедура ПечатьНаСервере3(ТабДок, Объект)
	Документы.РасходнаяНакладная.ПечатьНаСервереММ(ТабДок,Объект);
	ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
КонецПроцедуры	

&НаКлиенте
Процедура НовыеЗаказы(Команда)
		  
		  СсылкаНаДокумент = СоздатьНовыйДокумент();
		  ОткрытьЗначение(СсылкаНаДокумент);

КонецПроцедуры


&НаСервере
Функция СоздатьНовыйДокумент()
	   Перем НовыйКонтрагент;


		Сообщить("ВЫПОЛНИТЬ НАЖАТИЕ!");
	
	Connection = Новый COMОбъект("ADODB.Connection");
	
	АдресСервера 	= "localhost";
	НомерПорта 		= "3306";
	ИмяБД		    = "db_shop";
	Пользователь	= "admin";
	Пароль			= "123456";
	
	Connection.ConnectionString = "Driver={MySQL ODBC 5.1 Driver};Server="+СокрЛП(АдресСервера)+";Port=" + НомерПорта + ";Database=" + СокрЛП(ИмяБД) + ";User=" + Пользователь + ";Password=" + Пароль + ";";
	СтрокаПодключения = "DSN=myDSNuser;";
	Попытка
		Connection.Open(СтрокаПодключения); 
		//Connection.Open("Driver={MySQL ODBC 5.1 Driver(*.dbf)};DriverId=277;Dbq=C:");
	Исключение
		Сообщить("Ошибка подключения - " + ОписаниеОшибки());
		Возврат Ложь;
			
	КонецПопытки;
	
	ТекстSQL = "SELECT * FROM cart, table_products WHERE table_products.products_id = cart.cart_id_products";
	ЗаписиSQL = Connection.Execute(ТекстSQL);
	
	Таблица = Новый ТаблицаЗначений;
	Для НомерСтолбца = 0 По ЗаписиSQL.Fields.Count-1 Цикл
		ИмяСтолбца =ЗаписиSQL.Fields.Item(НомерСтолбца).Name;
		Таблица.Колонки.Добавить(ИмяСтолбца);
		//Сообщить(ИмяСтолбца);
	КонецЦикла;
	
	
   
  Пока ЗаписиSQL.EOF=0 Цикл    // Заполнение созданной таблицы
    
   НоваяСтрока =  Таблица.Добавить();
   Для НомерСтолбца = 0 По ЗаписиSQL.Fields.Count-1 Цикл
    НоваяСтрока.Установить(НомерСтолбца,ЗаписиSQL.Fields(НомерСтолбца).Value);
    //Сообщить ("Test " + ЗаписиSQL.Fields.Item(НомерСтолбца).Name + ЗаписиSQL.Fields.Item(НомерСтолбца).Value);
   КонецЦикла;
          
   ЗаписиSQL.MoveNext();
    
  КонецЦикла;

	
	
	ЗаписиSQL = Connection.Execute(ТекстSQL);

  Пока ЗаписиSQL.EOF=0 Цикл    // Заполнение созданной таблицы	
   
   
   НоваяСтрока =  Таблица.Добавить();
   Для НомерСтолбца = 0 По ЗаписиSQL.Fields.Count-1 Цикл
    НоваяСтрока.Установить(НомерСтолбца,ЗаписиSQL.Fields(НомерСтолбца).Value);
    
	  НовыйДокумент = Документы.РасходнаяНакладная.СоздатьДокумент();
	  НовыйДокумент.Номер = "0028";
   НовыйДокумент.Дата = ТекущаяДата();
   
   


        НовыйКонтрагент = Новый Структура("Наименование");
        НовыйКонтрагент.Наименование = ЗаписиSQL.Fields("cart_ip").Value;
		
	НовыйДокумент.Контрагент = ПроверитьЭлемент(НовыйКонтрагент.Наименование, НовыйКонтрагент);
   //НовыйДокумент.Контрагент = СоздатьНовогоКонтрагента(НовыйКонтрагент);

   НовыйДокумент.Склад = Справочники.Склады.НайтиПоНаименованию("Основной").Ссылка;

   НовыйДокумент.Записать();
   НовыйДокумент.Записать(РежимЗаписиДокумента.Проведение);
   Возврат НовыйДокумент.Ссылка;
	
   КонецЦикла;
   


    ЗаписиSQL.MoveNext();
  КонецЦикла;



КонецФункции   


&НаСервере
Функция СоздатьНовогоКонтрагента(СтруктураСправочника)

        Перем НовыйКонтрагент,СпрПользователи;

        СпрКонтрагенты = Справочники.Контрагенты;
        НовыйКонтрагент = СпрКонтрагенты.СоздатьЭлемент();
        НовыйКонтрагент.Наименование = СтруктураСправочника.Наименование;
        Попытка
                НовыйКонтрагент.Записать();
                Возврат НовыйКонтрагент.Ссылка;
        Исключение
                Возврат 0;
        КонецПопытки;

	КонецФункции
	
&НаСервере	
Функция ПроверитьЭлемент(Реквизит, Структура) Экспорт
      // Проверяем совпадение наименования
      Отбор = Реквизит;
      Найдено = Справочники.Контрагенты.НайтиПоНаименованию(Отбор, Истина);
      Если Найдено = Справочники.Контрагенты.ПустаяСсылка() Тогда
          // Такого элемента нет
          // Перезаписываем элемент справочника
		  Отказ = Ложь;
		  Возврат СоздатьНовогоКонтрагента(Структура);
      Иначе
           Сообщить("Такой элемент есть в справочнике");
           Возврат Справочники.Контрагенты.НайтиПоНаименованию(Отбор).Ссылка;
      КонецЕсли;
  КонецФункции
  
  &НаСервере
  Процедура ПередЗаписью(Отказ, Наименование)
     // Проверим существование элемента с таким Наименованием
     РаботаСоСправочниками.ПроверитьЭлемент(ЭтотОбъект, Наименование, Отказ);
КонецПроцедуры
	

