-- 2.Self join: finding prescribers where the first’s age is above 40 and the second one has the same age
SELECT R1.PRESCRIBER_ID, R2.PRESCRIBER_ID
FROM  PRESCRIBER R1, PRESCRIBER R2
WHERE R1.Age > 40 
AND R1.Age = R2.Age
AND R1.PRESCRIBER_ID < R2.PRESCRIBER_ID; 

-- 3. Minus: Select the prescriber ID, and profession. The prescribers are older and 30 but do not have patients 
SELECT R.PRESCRIBER_ID, R.PROFESSION
FROM PRESCRIBER R 
WHERE R.Age > 30 
MINUS 
SELECT R.PRESCRIBER_ID, R.PROFESSION 
FROM PRESCRIBER R, PATIENT P 
WHERE R.PRESCRIBER_ID = P.PRESCRIBER_ID;
-- 4. AVG, MAX, MIN: Calculates the max age average age, and minimum age
SELECT MAX(age) AS maxAge, AVG(age) AS averageAge, MIN(age) as minAge 
FROM PATIENT; 
-- 5. GROUP BY, HAVING, and ORDER BY, all appearing in the same query: Select lastname, and age. Where they are prescribed more then one dose less then 10. Ordered by age
SELECT P.LAST_NAME, P.Age
FROM PATIENT P, PRESCRIBER R, PRESCRIPTION S 
WHERE P.PATIENT_ID = S.PATIENT_ID AND S.DOSAGE<10
GROUP BY P.LAST_NAME, P.Age 
HAVING COUNT(*) > 1 
ORDER BY P.Age;
-- top N-Query: 6.   Select the patient ID, last name and weight, and ordered by weight descending
with  ordered_query  AS
	( Select PATIENT_ID, LAST_NAME, WEIGHT  
		from PATIENT P
        order by WEIGHT DESC)
Select PATIENT_ID, LAST_NAME, WEIGHT
from ordered_query
where ROWNUM<5;

-- rank Query: 7. Select the patient who has a height higher then 160 gives the ranks from highest to lowest
Select rank
from (Select Distinct height,
             RANK() Over (order by height) as rank
from PATIENT)
where height>160;

-- division: 8. Select patient ID and last name. Select patients who prescribers prescribe those taking medicine 1 "oxycodone" but are younger then 50.

SELECT P.PATIENT_ID, P.LAST_NAME
FROM   PATIENT P
WHERE  NOT EXISTS (
       (SELECT Pr.PRESCRIBER_ID
        FROM   PRESCRIPTION Pr
        WHERE  Pr.MEDICINE_ID =1)
       MINUS
       (SELECT PR.PRESCRIBER_ID
        FROM PRESCRIBER PR
        WHERE  PR.Age<50 ))
ORDER BY P.LAST_NAME;

-- correlated Subquerry: 9. Selects Patient ID, Patient Last name, and weight. This patients has a higher weight then the patients with average weight of patients with the same prescriber
SELECT P1.PATIENT_ID,  P1.LAST_NAME, P1.WEIGHT
FROM   PATIENT P1
WHERE  P1.WEIGHT >
       (SELECT AVG(P2.WEIGHT)
        FROM   PATIENT P2
        WHERE  P1.PRESCRIBER_ID= P2.PRESCRIBER_ID)
ORDER BY P1.WEIGHT;

-- noncorrelated Subquerry: Selects the patient_ID, and last name, of the patients not prescribing drugs
SELECT P.PATIENT_ID, P.LAST_NAME
FROM PATIENT P
WHERE P.PATIENT_ID NOT IN (SELECT Pr.PATIENT_ID
 FROM PRESCRIPTION Pr 
);
 
 -- outer join: 10. Select the patient id, last name. join the prescription patient_ID with patient PATIENT_ID
 
 SELECT P.PATIENT_ID, P.LAST_NAME
FROM PATIENT P LEFT OUTER JOIN PRESCRIPTION Pr ON P.PATIENT_ID = Pr.PATIENT_ID; 