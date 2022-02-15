CREATE DEFINER=`root`@`localhost` PROCEDURE `display_rating_supplier`()
BEGIN
select supplier.supp_id, supplier.supp_name, rating.rat_ratstars, case
when rating.rat_ratstars > 4 then 'Genuine Supplier'
when rating.rat_ratstars > 2 then 'Average Supplier'
else 'Supplier should not be considered'
end as verdict from rating inner join supplier on supplier.supp_id = rating.supp_id;
END