-- Selecciona las columnas DisplayName, Location y Reputation de los usuarios con mayor reputación
SELECT TOP 100 DisplayName, Location, Reputation
FROM Users
ORDER BY Reputation DESC;
-- Selecciona las columnas Title de Posts y DisplayName de Users para los posts que tienen propietario
SELECT TOP 100 Posts.Title, Users.DisplayName
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
WHERE Posts.OwnerUserId IS NOT NULL;
-- Calcula el promedio de Score de los Posts por cada usuario y muestra el DisplayName del usuario junto con el promedio
SELECT TOP 100 Users.DisplayName, AVG(Posts.Score) AS AverageScore
FROM Posts
JOIN Users ON Posts.OwnerUserId = Users.Id
GROUP BY Users.DisplayName;
-- Encuentra el DisplayName de los usuarios que han realizado más de 100 comentarios en total
SELECT TOP 100 Users.DisplayName
FROM Users
WHERE Id IN (
    SELECT UserId
    FROM Comments
    GROUP BY UserId
    HAVING COUNT(*) > 100
);
-- Actualiza la columna Location de la tabla Users cambiando todas las ubicaciones vacías por "Desconocido"
UPDATE Users
SET Location = 'Desconocido'
WHERE Location IS NULL OR Location = '';

-- Mensaje indicando que la actualización se realizó correctamente.
SELECT 'Actualización completada' AS Mensaje;


-- Crear una tabla temporal para almacenar los comentarios a eliminar
SELECT * INTO #TempCommentsToDelete
FROM Comments
WHERE UserId IN (
    SELECT Id
    FROM Users
    WHERE Reputation < 100
);

-- Mostrar cuántos comentarios serán eliminados
SELECT COUNT(*) AS ComentariosAEliminar FROM #TempCommentsToDelete;

-- Eliminar los comentarios seleccionados
DELETE FROM Comments
WHERE Id IN (
    SELECT Id FROM #TempCommentsToDelete
);

-- Mostrar cuántos comentarios fueron eliminados
SELECT COUNT(*) AS ComentariosEliminados FROM #TempCommentsToDelete;

-- Eliminar la tabla temporal
DROP TABLE #TempCommentsToDelete;


-- Muestra el número total de publicaciones, comentarios y medallas por usuario
SELECT TOP 100 Users.DisplayName,
       COUNT(DISTINCT Posts.Id) AS TotalPosts,
       COUNT(DISTINCT Comments.Id) AS TotalComments,
       COUNT(DISTINCT Badges.Id) AS TotalBadges
FROM Users
LEFT JOIN Posts ON Users.Id = Posts.OwnerUserId
LEFT JOIN Comments ON Users.Id = Comments.UserId
LEFT JOIN Badges ON Users.Id = Badges.UserId
GROUP BY Users.DisplayName;



-- Muestra las 10 publicaciones más populares basadas en la puntuación (Score)
SELECT TOP 10 Title, Score
FROM Posts
ORDER BY Score DESC;


-- Muestra los 5 comentarios más recientes
SELECT TOP 5 Text, CreationDate
FROM Comments
ORDER BY CreationDate DESC;
