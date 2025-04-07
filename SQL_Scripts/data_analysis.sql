-- LIST TOP RUN SCORERS(ORANGE CAP) IN EACH IPL SEASON
SELECT * FROM (
SELECT PlayerName, TotalRuns, IPLYear,
DENSE_RANK() OVER (PARTITION BY IPLYear ORDER BY TotalRuns DESC) as YearlyRunRank FROM iplbat) as abc
WHERE YearlyRunRank = 1 ORDER BY IPLYear;


-- LIST TOP WICKET TAKERS(PURPLE CAP) IN EACH IPL SEASON
SELECT * FROM (
SELECT PlayerName, WicketsTaken, Team, IPLYear, DENSE_RANK() OVER (PARTITION BY IPLYear ORDER BY WicketsTaken DESC) as WickRank
FROM iplbowl) as abc WHERE WickRank = 1;

-- WHO ARE THE TOP 3 RUN SCORERS IN EACH IPL SEASON
SELECT * FROM (
SELECT PlayerName, IPLYear, TotalRuns, DENSE_RANK() OVER (PARTITION BY IPLYear ORDER BY TotalRuns DESC) as RunRank
FROM iplbat) as abc
WHERE RunRank <= 3;

-- WHO ARE THE TOP-3 WICKET TAKERS IN EACH IPL SEASON?
SELECT PlayerName, WicketsTaken, IPLYear, WickRank FROM (
SELECT PlayerName, WicketsTaken, IPLYear, DENSE_RANK() OVER (PARTITION BY IPLYear ORDER BY WicketsTaken DESC, Economy) as WickRank
FROM iplbowl) as abc WHERE WickRank <= 3;


-- WHICH PLAYERS HAVE SCORED THE MOST CENTURIES (100+ runs) IN A SEASON?
SELECT PlayerName, Team, Centuries, IPLYear FROM (
SELECT PlayerName, Team, Centuries, IPLYear, DENSE_RANK() OVER (PARTITION BY IPLyear ORDER BY Centuries DESC) as CenRank
 FROM iplbat ORDER BY IPLYear) as abc WHERE CenRank = 1 AND Centuries >= 1;

-- WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (min 100 balls faced) IN EACH SEASON?
SELECT PlayerName, StrikeRate, IPLYear FROM (
SELECT PlayerName, TotalRuns, StrikeRate, BallsFaced, IPLYear, DENSE_RANK() OVER (PARTITION  BY IPLyear ORDER BY StrikeRate DESC) as Rnk
FROM iplbat WHERE BallsFaced >= 100) as abc WHERE Rnk = 1 ORDER BY IPLyear;

-- WHICH PLAYERS SCORED 500+ RUNS IN MULTIPLE SEASONS & HOW MANY TIMES?
SELECT PlayerName, COUNT(DISTINCT IPLyear) as TotalTimes FROM iplbat WHERE TotalRuns >= 500
GROUP BY PlayerName HAVING TotalTimes >= 2 ORDER BY TotalTimes DESC;


-- WHICH TOP-10 BOWLERS HAS THE BEST ECONOMY RATE OVERALL(MIN. 50 OVERS BOWLED)?
SELECT PlayerName, ROUND(AVG(Economy),2) as EcoAvg FROM (
SELECT PlayerName, Economy, IPLYear FROM iplbowl WHERE OversBowled >= 50) as abc GROUP BY PlayerName ORDER BY EcoAvg LIMIT 10;

-- WHICH ALL-ROUNDER (BAT + BOWL) HAS CONTRIBUTED THE MOST IN A SINGLE SEASON?
SELECT a.PlayerName, a.TotalRuns, a.IPLYear, b.WicketsTaken FROM iplbat a JOIN iplbowl b ON
a.PlayerName = b.PlayerName ORDER BY TotalRuns DESC, WicketsTaken DESC LIMIT 1;

-- LIST PLAYERS WHO APPEAR IN BOTH TABLES (iplbat & iplbowl), AND HAVE SCORED 300+ RUNS AND TAKEN 10+ WICKETS IN A SEASON?
SELECT a.PlayerName, a.TotalRuns, b.WicketsTaken, a.IPLYear FROM iplbat a JOIN iplbowl b ON a.PlayerName = b.PlayerName
WHERE a.TotalRuns >= 300 AND b.WicketsTaken >= 10;

-- FOR EACH YEAR, WHICH TEAM HAD THE MOST PLAYERS WITH 500+ RUNS OR 15+ WICKETS?
SELECT IPLYear, Team, SUM(OneCount) as FinalCount FROM (
(SELECT IPLYear, Team, COUNT(*) as OneCount FROM iplbat WHERE TotalRuns >= 500 GROUP BY IPLYear, Team ORDER BY IPLYear)
UNION ALL
(SELECT IPLYear, Team, COUNT(*) as OneCount FROM iplbowl WHERE WicketsTaken >= 15 GROUP BY IPLYear, Team ORDER BY IPLYear)) as abc
GROUP BY IPLYear, Team ORDER BY IPLYear;

-- FIND PLAYERS WHOSE RUN TALLY INCREASED IN ATLEAST 3 CONSECUTIVE IPL YEARS.
SELECT DISTINCT PlayerName FROM (
SELECT PlayerName, IPLYear, TotalRuns, LAG(TotalRuns, 1) OVER (PARTITION BY PlayerName ORDER BY IPLYear) as Prev1,
LAG(TotalRuns, 2) OVER (PARTITION BY PlayerName ORDER BY IPLYear) as Prev2
FROM iplbat) as abc
WHERE TotalRuns > Prev1 AND Prev1 > Prev2;

-- FIND PLAYERS WHO HAD ONLY 1 SEASON WITH 500+ RUNS OR 20+ WICKETS, AND NEVER PERFORMED CLOSE TO THAT AGAIN.
SELECT DISTINCT PlayerName FROM (
(SELECT DISTINCT PlayerName, COUNT(PlayerName) as TotalCount FROM iplbat WHERE TotalRuns >= 500 GROUP BY PlayerName HAVING TotalCount = 1)
UNION ALL
(SELECT DISTINCT PlayerName, COUNT(PlayerName) as TotalCount FROM iplbowl WHERE WicketsTaken >= 20 GROUP BY PlayerName HAVING TotalCount = 1))
as abc

-- WHICH TEAM HAD THE HIGHEST COMBINED WICKETS FROM ALL ITS BOWLERS IN EACH IPL YEAR?
SELECT Team, IPLyear, TotalWick FROM (
SELECT Team, IPLYear, TotalWick, RANK() OVER (PARTITION BY IPLYear ORDER BY TotalWick DESC) as WickRank FROM (
SELECT Team, IPLyear, SUM(WicketsTaken) as TotalWick FROM iplbowl GROUP BY IPLYear, Team ORDER BY IPLyear, TotalWick DESC) as abc) as xyz
WHERE WickRank = 1;

-- LIST TOP 10 BATSMEN WITH HIGHEST AVERAGE RUNS PER MATCH, ACROSS ALL SEASONS (MIN. 20 MATCHES).
SELECT DISTINCT PlayerName, SUM(Matches) as TotalMatches, ROUND(SUM(Average)/COUNT(*),2) as FinalAvg FROM iplbat GROUP BY PlayerName
HAVING TotalMatches >= 20 ORDER BY FinalAvg DESC LIMIT 10;

-- FOR EACH TEAM, CALCULATE TOTAL RUNS + WICKETS PER YEAR AND FIND THE YEAR WHEN THE TEAM HAD ITS HIGHEST OVERALL IMPACT
SELECT Team, IPLYear FROM
(SELECT Team, IPLYear, SUM(ImpactPoints) as TotalImpact, RANK() OVER (PARTITION BY Team ORDER BY SUM(ImpactPoints) DESC, IPLYear ASC
) as ImpactRank
FROM
((SELECT * FROM 
(SELECT Team, IPLYear, (CASE WHEN ImpactRank1 = 1 THEN 15 WHEN ImpactRank1 = 2 THEN 10 WHEN ImpactRank1 = 3 THEN 5 ELSE 0 END) AS ImpactPoints FROM
(SELECT Team, IPLYear, RANK() OVER (PARTITION BY Team ORDER BY MegaTotal DESC) as ImpactRank1 FROM
(SELECT Team, IPLYear, SUM(TotalRuns) as MegaTotal FROM iplbat GROUP BY Team, IPLYear ORDER BY Team, MegaTotal DESC) as abc) as xyz) axy
WHERE ImpactPoints > 0)
UNION ALL
(SELECT * FROM
(SELECT Team, IPLYear, CASE WHEN ImpactRank2 = 1 THEN 15 WHEN ImpactRank2 = 2 THEN 10 WHEN ImpactRank2 = 3 THEN 5 ELSE 0 END AS ImpactPoints FROM
(SELECT Team, IPLYear, RANK() OVER (PARTITION BY Team ORDER BY MegaWick DESC) as ImpactRank2 FROM
(SELECT Team, IPLYear, SUM(WicketsTaken) as MegaWick FROM iplbowl GROUP BY Team, IPLYear ORDER BY Team, MegaWick DESC) as def) as tuv) duv
WHERE ImpactPoints > 0)) as abc GROUP BY Team, IPLYear) as FinalTable
WHERE ImpactRank = 1


-- FIND TOP 5 BOWLERS WITH LOWEST ECONOMY RATE ACROSS ALL SEASONS (MIN. 120 OVERS BOWLED IN TOTAL).
SELECT PlayerName, ROUND(AVG(Economy),2) as AvgEco, ROUND(SUM(OversBowled),2) as TotalOvers FROM iplbowl GROUP BY PlayerName HAVING
SUM(OversBowled) >= 120
ORDER BY AvgEco ASC LIMIT 5

-- IDENTIFY PLAYERS WHO HAVE HIT MORE THAN 100 SIXES IN TOTAL (all seasons) AND ALSO HAVE A STRIKE RATE ABOVE 140.
SELECT PlayerName, SUM(Sixes) as TotalSixes, ROUND(AVG(StrikeRate),2) as AvgStrike FROM iplbat GROUP BY PlayerName 
HAVING SUM(Sixes) >= 100 AND AVG(StrikeRate) >= 140

-- FIND PLAYERS WHO MAINTAINED AN AVERAGE OF AT LEAST 40, IN AT LEAST 3 CONSECUTIVE IPL SEASONS.
SELECT DISTINCT PlayerName FROM
(SELECT PlayerName, IPLyear, Average, LAG(IPLYear, 1) OVER (PARTITION BY PlayerName ORDER BY IPLYear) as PrevYear1,
LAG(IPLYear,2) OVER (PARTITION BY PlayerName ORDER BY IPLYear) as PrevYear2
FROM iplbat
WHERE Average >= 40) as abc
WHERE IPLYear = Prevyear1 + 1 AND PrevYear1 = PrevYear2 + 1

-- FIND PLAYERS WHO CONTRIBUTED THE HIGHEST TO THEIR TEAM'S SUCCESS BY COMBINING BATTING AND BOWLING IMPACT.
SELECT PlayerName, (batAvg + 10*BowlSR) as ImpactScore FROM
(SELECT a.PlayerName, ROUND(SUM(a.TotalRuns)/SUM(a.Matches),2) as batAvg, ROUND(SUM(b.WicketsTaken)/SUM(b.Matches),2) as BowlSR
FROM iplbat a JOIN iplbowl b ON a.PlayerName = b.PlayerName GROUP BY a.PlayerName) abc ORDER BY ImpactScore DESC
 
 
 
 
 