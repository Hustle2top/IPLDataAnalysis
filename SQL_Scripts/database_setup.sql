CREATE DATABASE IPL_DATA;

USE IPL_DATA;

CREATE TABLE IPLBAT (
PlayerName VARCHAR(100),
Team VARCHAR(10),
IPLYear YEAR,
Matches INT,
Innings INT, Notout INT, TotalRuns INT, HighestScore INT, Average FLOAT, BallsFaced INT, StrikeRate FLOAT,
Centuries INT, HalfCenturies INT, Ducks INT, Fours INT, Sixes INT);

CREATE TABLE IPLBOWL (
PlayerName VARCHAR(100),
Team VARCHAR(10),
IPLYear YEAR,
Matches INT, BallsBowled INT, OversBowled FLOAT, Maidens INT,
Innings INT, RunsGiven INT, WicketsTaken INT, BowlingAverage FLOAT, Economy FLOAT, BowlingStrikeRate FLOAT,
FourWickets INT, FiveWickets INT);

USE IPL_DATA;
SHOW TABLES;
SELECT * FROM iplbat;
SELECT * FROM iplbowl;