  SELECT *
  FROM Pizza..Feuil

  EXEC sp_help 'Feuil'

  -----------Drop the primary key constraint of Orders table---------
  ALTER TABLE Orders 
  DROP CONSTRAINT PK__Orders__F1E4639BC8F49E7F;
  --------change column type of Orders table ---------------------
  Alter table Orders
  Alter column Order_ID varchar(20)

  Alter table Orders
  Alter column CustomerID varchar(20)

   Alter table Orders
  Alter column Address_ID varchar(20)

  Alter table Orders
  Alter column Delivery varchar(20)

  select* from Orders
  select* from Feuil
  insert into Orders (Row_Id, Order_ID, Created_at, Item_ID, Quantity, CustomerID, Delivery, Address_ID)
  select row_id, order_id, Created_at, item_name, Quantity, Cust_id, Delivery, Add_id from Feuil

  EXEC sp_help 'Orders'

  -----------Drop the primary key constraint of Item table---------
  ALTER TABLE Item 
  DROP CONSTRAINT PK__Item__3FB50F944C5BC101;
  --------change column type of Item table ---------------------
  Alter table Item
  Alter column Item_ID varchar(20)
  ------insert data into tables------

  insert into Item (Item_ID, Sku, Item_name, Item_cat, Item_size, Item_price)
  select Item_ID, Sku, Item_name, Item_cat, Item_size, Item_price from Feuil1

  select* from Item

  insert into Ingredient (Ing_id, Ing_name, Ing_weight, Ing_meas, Ing_price)
  select Ing_id, Ing_name, Ing_weight, Ing_meas, Ing_price from Feuil2

  select* from Ingredient

  insert into Recipe (Row_id, Recipe_id, Ing_id, Quantity)
  select Row_id, Recipe_id, Ing_id, Quantity from Feuil3

  insert into Inventory (Inv_id, Item_id, Quantity)
  select Inv_id, Item_id, Quantity from Feuil11

  ---------change & insert data into staff & shift & Rotation tables-------
  Alter table sta1
  Alter column hourly_rate float

  Alter table Staff
  Alter column Staff_id varchar(20)

  insert into Staff (staff_id, first_name, last_name, position, hourly_rate)
  select staff_id, first_name, last_name, position, hourly_rate from sta1

  insert into Shift1 (shift_id, days_of_week, start_time, end_time)
  select shift_id, day_of_week, start_time, end_time from shift11

  Alter table Rotation
  Alter column Staff_id varchar(20)

  insert into Rotation (Row_id, Rota_id, date, Shift_id, Staff_id)
  select Row_id, Rota_id, date, Shift_id, Staff_id from Rotat
  
  Select* from Rotation
  Select* from Shift1
  select* from Staff
  select* from Inventory
  select* from Orders
  select* from Item
  select* from Ingredient
  select* from Recipe

  Select o.Order_ID, o.Item_ID, i.item_price, o.quantity, i.Sku, i.item_name, o.created_at, o.delivery
  from Orders o left join Item i 
  on o.Item_ID = i.Item_ID


  -----Total quantity by ingredient------
  select* from Item
  select* from Ingredient
  select* from Recipe
  select* from Orders

  Select 
  S1.Item_ID,
  S1.SKU,
  S1.item_name,
  S1.Ing_name,
  S1.Ing_id,
  S1.recipe_quantity,
  S1.order_quantity,
  S1.unit_price,
  S1.recipe_quantity*S1.order_quantity*S1.unit_price as ingredient_cost
  from (Select
  o.Item_ID,
  i.Sku,
  i.item_name,
  r.ing_id,
  ing.ing_name,
  r.Quantity as recipe_quantity,
  sum(o.Quantity) as order_quantity,
  ing.Ing_weight,
  ing.Ing_price,
  ing.Ing_price/ing.Ing_weight as unit_price
  From Orders o
  left join Item i on o.Item_ID = i.Item_ID
  left join Recipe r on i.Sku = r.Recipe_id
  left join Ingredient ing on r.Ing_id = ing.Ing_id
  group by  o.Item_ID,
  r.ing_id,
  i.Sku,
  i.item_name,
  ing.ing_name,
  r.Quantity,
  ing.Ing_weight,
  ing.Ing_price) S1
  group by S1.Item_ID,
  S1.Ing_id,
  S1.SKU,
  S1.item_name,
  S1.Ing_name,
  S1.recipe_quantity,
  S1.order_quantity,
  S1.unit_price

  --------Create view-------
  Create view S2 as 
  Select 
  S1.Item_ID,
  S1.SKU,
  S1.item_name,
  S1.Ing_name,
  S1.Ing_id,
  S1.recipe_quantity,
  S1.order_quantity,
  S1.recipe_quantity*S1.order_quantity as ordered_weight,
  S1.unit_price,
  S1.recipe_quantity*S1.order_quantity*S1.unit_price as ingredient_cost
  from (Select
  o.Item_ID,
  i.Sku,
  i.item_name,
  r.ing_id,
  ing.ing_name,
  r.Quantity as recipe_quantity,
  sum(o.Quantity) as order_quantity,
  ing.Ing_weight,
  ing.Ing_price,
  ing.Ing_price/ing.Ing_weight as unit_price
  From Orders o
  left join Item i on o.Item_ID = i.Item_ID
  left join Recipe r on i.Sku = r.Recipe_id
  left join Ingredient ing on r.Ing_id = ing.Ing_id
  group by  o.Item_ID,
  r.ing_id,
  i.Sku,
  i.item_name,
  ing.ing_name,
  r.Quantity,
  ing.Ing_weight,
  ing.Ing_price) S1
  group by S1.Item_ID,
  S1.Ing_id,
  S1.SKU,
  S1.item_name,
  S1.Ing_name,
  S1.recipe_quantity,
  S1.order_quantity,
  S1.unit_price

  select * from S2
  
  -----Calculate ingredient cost per each item-------

  select S3.Ing_name, S3.Ing_id, S3.ordered_weight, inv.Inv_id, inv.Quantity, ing.Ing_weight, 
  inv.Quantity*ing.Ing_weight as total_inv_weight, (inv.Quantity*ing.Ing_weight)-S3.ordered_weight as remaining_weight
  from (select 
  Ing_name, ing_id,
  sum(ordered_weight) as ordered_weight
  from S2
  group by Ing_name, ing_id) S3
  left join Inventory inv on  inv.Item_id = S3.Ing_id
  left join Ingredient ing on ing.Ing_id = S3.Ing_id
  

  Select* from Rotation
  Select* from Shift1
  select* from Staff

  ------Calculate staff cost-----
  select S5.Rota_id, S5.date, Sum(S5.Worker_cost) as daily_staff_cost
  from (select ro.Rota_id, ro.date, ro.Shift_id, ro.Staff_id, sh.start_time, sh.end_time, sta.Hourly_rate,
  DATEDIFF(HOUR, sh.start_time, sh.end_time) AS Heures_de_travail, DATEDIFF(HOUR, sh.start_time, sh.end_time)*Hourly_rate as Worker_cost
  from Rotation ro left join Shift1 sh on ro.Shift_id = sh.Shift_id
  left join Staff sta on ro.Staff_id = sta.Staff_id) S5
  Group by S5.Rota_id, S5.date

