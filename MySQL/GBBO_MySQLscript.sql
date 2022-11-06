
##GBBO dataset questions and SQL statements by Monica Kim

#Youngest contestant all time
SELECT series, baker, age
FROM gbbo_bakers
ORDER BY age
LIMIT 1

#Eldest contestant all time
SELECT series, baker, age
FROM gbbo_bakers
ORDER BY age DESC
LIMIT 1

#Youngest winner
WITH winners AS (SELECT series, baker FROM gbbo_challengeresults WHERE outcome = "WINNER")
SELECT w.series AS series, w.baker AS baker, b.age AS age
FROM winners w
LEFT JOIN gbbo_bakers b
ON (w.baker = b.baker AND w.series = b.series)
ORDER BY b.age 
LIMIT 1

#Eldest winner
WITH winners AS (SELECT series, baker FROM gbbo_challengeresults WHERE outcome = "WINNER")
SELECT w.series AS series, w.baker AS baker, b.age AS age 
FROM winners w 
LEFT JOIN gbbo_bakers b
ON (w.baker = b.baker AND w.series = b.series)
ORDER BY b.age DESC
LIMIT 1

#Who got the most star baker?
SELECT series, baker, count(*) AS starbaker FROM gbbo_challengeresults
WHERE outcome = "STARBAKER"
GROUP BY series, baker
ORDER BY starbaker DESC
LIMIT 5

#Did the top 5 people that earned the most star baker won the series?
SELECT series, baker, SUM(CASE WHEN outcome = "STARBAKER" THEN 1 ELSE 0 END) AS starbaker,
SUM(CASE WHEN outcome = "WINNER" THEN 1 ELSE 0 END) AS seriesresult
FROM gbbo_challengeresults gc 
GROUP BY series, baker
ORDER BY starbaker DESC 
LIMIT 10

#Did the top 5 people that earned the most star baker made it to the final?
SELECT series, baker, SUM(CASE WHEN outcome = "STARBAKER" THEN 1 ELSE 0 END) AS starbaker,
SUM(CASE WHEN (outcome = "RUNNERUP" OR outcome = "WINNER") THEN 1 ELSE 0 END) AS seriesfinal3,
SUM(CASE WHEN outcome = "WINNER" THEN 1 ELSE 0 END) AS seriesresult
FROM gbbo_challengeresults gc 
GROUP BY series, baker
ORDER BY starbaker DESC 
LIMIT 10


#Average age of contestants all time?
SELECT ROUND(AVG(age)) AS average_age
FROM gbbo_bakers;

#Average age of contestants of each season?
SELECT series, ROUND(AVG(age)) AS average_age
FROM gbbo_bakers
GROUP BY series 
ORDER BY average_age;

#Average age of winners?
SELECT AVG(gb.age) AS average_age
FROM gbbo_bakers gb
INNER JOIN (SELECT series, baker FROM gbbo_challengeresults WHERE outcome = "WINNER" ) gc
ON (gb.series = gc.series AND gb.baker = gc.baker);

#Average age of winners and runner-ups?
SELECT AVG(gb.age) AS average_age
FROM gbbo_bakers gb
INNER JOIN (SELECT series, baker FROM gbbo_challengeresults WHERE (outcome = "WINNER" OR outcome = "RUNNERUP")) gc
ON (gb.series = gc.series AND gb.baker = gc.baker);



#Star baker count by winners
WITH
winner AS 
	(SELECT series, baker
	FROM gbbo_challengeresults WHERE outcome = "WINNER"),
starbaker AS
	(SELECT series, baker, SUM(CASE WHEN outcome = "STARBAKER" THEN 1 ELSE 0 END) AS starbakercount
	FROM gbbo_challengeresults GROUP BY series, baker)


SELECT w.series AS series, w.baker AS baker, s.starbakercount AS starbakercount
FROM winner w 
LEFT JOIN starbaker s
ON (w.series = s.series AND w.baker = s.baker)


#Star baker count by winners, runner-ups
WITH
winnerrunnerup AS 
	(SELECT series, baker, outcome As results
	FROM gbbo_challengeresults WHERE outcome = "WINNER" OR outcome = "RUNNERUP"),
starbaker AS
	(SELECT series, baker, SUM(CASE WHEN outcome = "STARBAKER" THEN 1 ELSE 0 END) AS starbakercount
	FROM gbbo_challengeresults GROUP BY series, baker)


SELECT w.series AS series, w.baker AS baker, w.results AS results, s.starbakercount AS starbakercount
FROM winnerrunnerup w 
LEFT JOIN starbaker s
ON (w.series = s.series AND w.baker = s.baker);

#Number of contestants per season order by contestant count
SELECT series, COUNT(*) AS bakercount FROM gbbo_bakers GROUP BY series ORDER BY bakercount DESC

#Seasons that had episodes where two contestants were eliminated
SELECT series, episode, COUNT(*) AS contestantcount
FROM gbbo_challengeresults WHERE outcome = "OUT" GROUP BY series, episode HAVING contestantcount = 2;

#Seasons that had episodes where no contestants were eliminated
SELECT
	series,
	episode,
	SUM(CASE WHEN outcome = "OUT" THEN 1
			 WHEN outcome = "WINNER" THEN 1
			 ELSE 0 END) AS contestantcount
FROM gbbo_challengeresults
GROUP BY series, episode
HAVING contestantcount = 0;

#Contestants who skipped an episode

SELECT series, episode, baker
FROM gbbo_challengeresult
WHERE outcome = "SKIP";


#How many contestants got Paul Hollywood handshake for signature bake?
SELECT
	t.series AS series,
	t.totalcontestants AS totalcontestants,
	s.contestants AS contestants,
	CONCAT(ROUND(s.contestants/t.totalcontestants*100)," %") as percentage
FROM
(SELECT series, COUNT(*) AS totalcontestants FROM gbbo_bakers GROUP BY series) AS t 
LEFT JOIN
(SELECT series, COUNT(DISTINCT baker) AS contestants FROM gbbo_challengeresults WHERE signature_handshake = "Yes" GROUP BY series) AS s
ON t.series = s.series


#How many contestants got Paul Hollywood handshake for showstopper?

SELECT 
	series,
	COUNT(DISTINCT baker) AS totalcontestants,
	COUNT(DISTINCT CASE WHEN showstopper_handshake = "YES" THEN baker END) AS contestants,
	CONCAT(IFNULL(ROUND(COUNT(DISTINCT baker)/COUNT(DISTINCT CASE WHEN showstopper_handshake = "YES" THEN baker END)),0)," %") AS percentage
FROM gbbo_challengeresults
GROUP BY series

#Number of signature and showstopper handshakes by season
SELECT
	series,
	SUM(CASE WHEN signature_handshake = "YES" THEN 1 ELSE 0 END) AS signature_handshakes,
	SUM(CASE WHEN showstopper_handshake = "YES" THEN 1 ELSE 0 END) AS showstopper_handshakes
FROM gbbo_challengeresults
GROUP BY series

#Who are the star bakers of Bread Week and what episode was Bread Week for each season?

SELECT c.series AS series, c.episode AS episode, c.baker AS baker
FROM
(SELECT * FROM gbbo_episodes WHERE episode_name = "Bread") e
LEFT JOIN
(SELECT series, episode, baker FROM
gbbo_challengeresults 
WHERE outcome = "STARBAKER") c
ON (e.season = c.series AND e.episode = c.episode)




#What are the showstopper flavors of Star bakers during Patisserie week?
SELECT c.series, c.episode, c.showstopper_ingredients
FROM (SELECT * FROM gbbo_challengeresults WHERE outcome = "STARBAKER" ) c
RIGHT JOIN (SELECT * FROM gbbo_episodes WHERE episode_name = "Patisserie") e
ON (c.series = e.season AND c.episode = e.episode)
WHERE c.showstopper_ingredients IS NOT NULL;

#Average percentile rank of technical bake of winners vs other contestants
WITH raw AS (SELECT series, episode, 
SUM(CASE WHEN (outcome IS NOT NULL OR outcome <> "SKIP" OR outcome <> "WITHDRAWN") THEN 1 ELSE 0 END) OVER(PARTITION BY episode, series) AS contestants
FROM gbbo_challengeresults ORDER BY series, episode)

SELECT DISTINCT series, episode, contestants FROM raw


WITH 
techpercentile AS (SELECT series, episode, baker, technical,
ROUND(PERCENT_RANK() OVER(PARTITION BY series, episode ORDER BY technical DESC),3) percentrank FROM gbbo_challengeresults WHERE technical IS NOT NULL),
winners AS (SELECT series, baker, outcome AS r FROM gbbo_challengeresults WHERE outcome = "WINNER")

SELECT t.series,
ROUND(AVG(CASE WHEN w.r = "Winner" THEN t.percentrank ELSE NULL END),2) Winner,
ROUND(AVG(CASE WHEN w.r IS NULL THEN t.percentrank ELSE NULL END),2) Contestant
FROM techpercentile t
LEFT JOIN winners w
ON (t.series = w.series AND t.baker = w.baker)
GROUP BY t.series


#Is there a case where contestant got a handshake but had to leave the tent?
SELECT * FROM gbbo_challengeresults WHERE (signature_handshake = "YES" OR showstopper_handshake = "YES") AND outcome = "OUT";

#Is there a case where contestant rank 1 in the technical but had to leave the tent?
SELECT series, episode, baker FROM gbbo_challengeresults WHERE technical = 1 AND outcome = "OUT"

#Is there a case where contestant was last in technical but won star baker?
WITH techbakers AS (SELECT DISTINCT series, episode,
MAX(technical) OVER(PARTITION BY series, episode) techbakercount FROM gbbo_challengeresults WHERE technical IS NOT NULL)
SELECT gc.series, gc.episode, gc.baker, gc.outcome, t.techbakercount AS technicalrank
FROM gbbo_challengeresults gc
LEFT JOIN techbakers t 
ON (gc.series = t.series AND gc.episode = t.episode)
WHERE
gc.outcome  = "STARBAKER" AND gc.technical = t.techbakercount

#When did the first handshake happen for signature bake?
SELECT series, episode FROM gbbo_challengeresults WHERE signature_handshake = "YES" ORDER BY series, episode LIMIT 1

#When did the first handshake happen for showstopper?
SELECT series, episode FROM gbbo_challengeresults WHERE showstopper_handshake = "YES" ORDER BY series, episode LIMIT 1

#How many handshakes have been given in each series?
SELECT series,
SUM(CASE WHEN signature_handshake = "YES" THEN 1 ELSE 0 END) signature_hs,
SUM(CASE WHEN showstopper_handshake = "YES" THEN 1 ELSE 0 END) showstopper_hs
FROM gbbo_challengeresults
GROUP BY series

#What week did winners won starbaker?
WITH winners AS (SELECT series, baker FROM gbbo_challengeresults WHERE outcome = "WINNER")
SELECT gc.series, gc.episode, e.episode_name, gc.baker
FROM (SELECT * FROM gbbo_challengeresults  WHERE outcome = "STARBAKER") gc
LEFT JOIN winners w 
ON gc.series = w.series
LEFT JOIN gbbo_episodes e 
ON (gc.series = e.series AND gc.episode = e.episode)
WHERE gc.baker = w.baker
ORDER BY series, episode, e.episode_name
