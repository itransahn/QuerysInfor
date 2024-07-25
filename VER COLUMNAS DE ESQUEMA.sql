--pruebas de carga
--aqui se hizo una prueba
SELECT table_name,
       column_name,
       data_type
FROM information_schema.columns
WHERE table_schema = 'wmwhse51'
    AND column_name = 'TASKTYPE';