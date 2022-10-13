select d.dname from domains as d
inner join users as u on (u.user_id = d.user_id) and (u."name" = 'Иван Иванов')
order by dname;
